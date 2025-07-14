-- Script de verificación para validar la migración del ERD
-- Ejecutar después de aplicar la migración principal

-- =====================================================
-- 1. VERIFICACIÓN DE ENUMS
-- =====================================================

SELECT 
    'VERIFICACIÓN DE ENUMS' as section,
    t.typname as enum_name,
    CASE 
        WHEN t.typname IS NOT NULL THEN '✅ Enum creado'
        ELSE '❌ Enum faltante'
    END as status,
    array_agg(e.enumlabel ORDER BY e.enumsortorder) as values
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
WHERE t.typname IN ('positionstatus', 'employmenttype', 'applicationstatus', 'interviewresult')
GROUP BY t.typname
ORDER BY t.typname;

-- =====================================================
-- 2. VERIFICACIÓN DE TABLAS NUEVAS
-- =====================================================

SELECT 
    'VERIFICACIÓN DE TABLAS NUEVAS' as section,
    table_name,
    CASE 
        WHEN table_name IS NOT NULL THEN '✅ Tabla creada'
        ELSE '❌ Tabla faltante'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
    'Company', 'Employee', 'InterviewFlow', 'InterviewType',
    'Position', 'InterviewStep', 'Application', 'Interview'
)
ORDER BY table_name;

-- =====================================================
-- 3. VERIFICACIÓN DE ÍNDICES
-- =====================================================

-- Índices básicos
SELECT 
    'VERIFICACIÓN ÍNDICES BÁSICOS' as section,
    indexname,
    tablename,
    CASE 
        WHEN indexname IS NOT NULL THEN '✅ Índice creado'
        ELSE '❌ Índice faltante'
    END as status
FROM pg_indexes 
WHERE indexname IN (
    'idx_employee_company', 'idx_employee_email', 'idx_position_company',
    'idx_position_status', 'idx_position_visible', 'idx_application_position',
    'idx_application_candidate', 'idx_application_status', 'idx_interview_application',
    'idx_interview_employee', 'idx_interview_date', 'idx_interview_step_flow'
)
ORDER BY indexname;

-- Índices de texto completo
SELECT 
    'VERIFICACIÓN ÍNDICES TEXTO COMPLETO' as section,
    indexname,
    tablename,
    CASE 
        WHEN indexname IS NOT NULL THEN '✅ Índice GIN creado'
        ELSE '❌ Índice GIN faltante'
    END as status
FROM pg_indexes 
WHERE indexname IN (
    'idx_position_title_gin', 'idx_position_description_gin',
    'idx_position_job_description_gin', 'idx_position_requirements_gin'
)
ORDER BY indexname;

-- =====================================================
-- 4. VERIFICACIÓN DE TRIGGERS
-- =====================================================

SELECT 
    'VERIFICACIÓN TRIGGERS' as section,
    trigger_name,
    event_manipulation,
    action_timing,
    CASE 
        WHEN trigger_name IS NOT NULL THEN '✅ Trigger creado'
        ELSE '❌ Trigger faltante'
    END as status
FROM information_schema.triggers 
WHERE trigger_name IN (
    'update_company_updated_at', 'update_employee_updated_at',
    'update_interview_flow_updated_at', 'update_interview_type_updated_at',
    'update_position_updated_at', 'update_interview_step_updated_at',
    'update_application_updated_at', 'update_interview_updated_at',
    'check_interview_overlap_trigger'
)
ORDER BY trigger_name;

-- =====================================================
-- 5. VERIFICACIÓN DE FOREIGN KEYS
-- =====================================================

SELECT 
    'VERIFICACIÓN FOREIGN KEYS' as section,
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    CASE 
        WHEN tc.constraint_name IS NOT NULL THEN '✅ Foreign key creado'
        ELSE '❌ Foreign key faltante'
    END as status
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_name IN ('Employee', 'Position', 'InterviewStep', 'Application', 'Interview')
ORDER BY tc.table_name, kcu.column_name;

-- =====================================================
-- 6. VERIFICACIÓN DE CONSTRAINTS ÚNICOS
-- =====================================================

SELECT 
    'VERIFICACIÓN CONSTRAINTS ÚNICOS' as section,
    constraint_name,
    table_name,
    CASE 
        WHEN constraint_name IS NOT NULL THEN '✅ Constraint único creado'
        ELSE '❌ Constraint único faltante'
    END as status
FROM information_schema.table_constraints 
WHERE constraint_type = 'UNIQUE'
AND constraint_name IN (
    'interview_step_interviewFlowId_orderIndex_key',
    'application_positionId_candidateId_key'
)
ORDER BY table_name;

-- =====================================================
-- 7. VERIFICACIÓN DE DATOS DE EJEMPLO
-- =====================================================

-- Tipos de entrevista
SELECT 
    'VERIFICACIÓN DATOS - INTERVIEW_TYPE' as section,
    COUNT(*) as record_count,
    CASE 
        WHEN COUNT(*) >= 6 THEN '✅ Datos de ejemplo insertados'
        ELSE '❌ Datos de ejemplo faltantes'
    END as status,
    string_agg(name, ', ') as tipos_creados
FROM "InterviewType";

-- Flujos de entrevista
SELECT 
    'VERIFICACIÓN DATOS - INTERVIEW_FLOW' as section,
    COUNT(*) as record_count,
    CASE 
        WHEN COUNT(*) >= 3 THEN '✅ Flujos de entrevista creados'
        ELSE '❌ Flujos de entrevista faltantes'
    END as status,
    string_agg(description, ', ') as flujos_creados
FROM "InterviewFlow";

-- Pasos de entrevista
SELECT 
    'VERIFICACIÓN DATOS - INTERVIEW_STEP' as section,
    COUNT(*) as record_count,
    CASE 
        WHEN COUNT(*) >= 12 THEN '✅ Pasos de entrevista creados'
        ELSE '❌ Pasos de entrevista faltantes'
    END as status
FROM "InterviewStep";

-- =====================================================
-- 8. VERIFICACIÓN DE FUNCIONES
-- =====================================================

SELECT 
    'VERIFICACIÓN FUNCIONES' as section,
    routine_name,
    routine_type,
    CASE 
        WHEN routine_name IS NOT NULL THEN '✅ Función creada'
        ELSE '❌ Función faltante'
    END as status
FROM information_schema.routines 
WHERE routine_name IN ('update_updated_at_column', 'check_interview_overlap')
AND routine_schema = 'public'
ORDER BY routine_name;

-- =====================================================
-- 9. VERIFICACIÓN DE COMENTARIOS
-- =====================================================

SELECT 
    'VERIFICACIÓN COMENTARIOS' as section,
    obj_description(c.oid) as table_comment,
    c.relname as table_name,
    CASE 
        WHEN obj_description(c.oid) IS NOT NULL THEN '✅ Comentario agregado'
        ELSE '❌ Comentario faltante'
    END as status
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
AND c.relname IN ('Company', 'Employee', 'InterviewFlow', 'InterviewType', 'Position', 'InterviewStep', 'Application', 'Interview')
ORDER BY c.relname;

-- =====================================================
-- 10. VERIFICACIÓN DE TIPOS DE DATOS ESPECÍFICOS
-- =====================================================

-- Verificar campos DECIMAL en Position
SELECT 
    'VERIFICACIÓN TIPOS DE DATOS' as section,
    column_name,
    data_type,
    numeric_precision,
    numeric_scale,
    CASE 
        WHEN data_type = 'numeric' AND numeric_precision = 10 AND numeric_scale = 2 THEN '✅ Tipo DECIMAL correcto'
        ELSE '❌ Tipo de dato incorrecto'
    END as status
FROM information_schema.columns 
WHERE table_name = 'position' 
AND column_name IN ('salaryMin', 'salaryMax');

-- Verificar constraint de puntuación en Interview
SELECT 
    'VERIFICACIÓN CONSTRAINT PUNTUACIÓN' as section,
    cc.constraint_name,
    cc.check_clause,
    CASE 
        WHEN cc.check_clause LIKE '%score% >= 0%' AND cc.check_clause LIKE '%score% <= 100%' THEN '✅ Constraint de puntuación correcto'
        ELSE '❌ Constraint de puntuación incorrecto'
    END as status
FROM information_schema.check_constraints cc
JOIN information_schema.table_constraints tc ON cc.constraint_name = tc.constraint_name
WHERE tc.table_name = 'interview'
AND cc.check_clause LIKE '%score%';

-- =====================================================
-- 11. RESUMEN FINAL
-- =====================================================

SELECT 
    'RESUMEN DE VERIFICACIÓN' as section,
    'Verificar que todos los elementos anteriores muestren ✅' as instruction,
    'Si hay algún ❌, revisar la migración y ejecutar nuevamente' as action,
    'Después de verificar, ejecutar: npx prisma generate' as next_step;

-- =====================================================
-- 12. CONSULTAS DE PRUEBA
-- =====================================================

-- Prueba de búsqueda de texto completo
SELECT 
    'PRUEBA BÚSQUEDA TEXTO COMPLETO' as section,
    'Ejecutar: SELECT * FROM "Position" WHERE to_tsvector(''english'', title) @@ plainto_tsquery(''english'', ''developer'');' as test_query,
    'Debería funcionar sin errores' as expected_result;

-- Prueba de trigger de updatedAt
SELECT 
    'PRUEBA TRIGGER UPDATED_AT' as section,
    'Actualizar cualquier registro y verificar que updatedAt se actualice automáticamente' as test_instruction,
    'Campo updatedAt debe cambiar al timestamp actual' as expected_result;

-- Prueba de validación de superposición
SELECT 
    'PRUEBA VALIDACIÓN SUPERPOSICIÓN' as section,
    'Intentar crear dos entrevistas para el mismo empleado en la misma fecha' as test_instruction,
    'Debería fallar con mensaje de error' as expected_result; 