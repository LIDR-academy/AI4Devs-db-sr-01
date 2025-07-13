-- =====================================================
-- FASE 2 - SCRIPT DE VERIFICACIÓN
-- =====================================================
-- Script para verificar que todas las tablas y datos se crearon correctamente

-- Verificar que todas las tablas existen
SELECT 
    table_name,
    CASE 
        WHEN table_name IN ('COMPANY', 'INTERVIEW_TYPE', 'INTERVIEW_FLOW', 'EMPLOYEE', 'INTERVIEW_STEP', 'POSITION', 'APPLICATION', 'INTERVIEW') 
        THEN '✅ NUEVA TABLA'
        ELSE '✅ TABLA ORIGINAL'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('Candidate', 'Education', 'WorkExperience', 'Resume', 'COMPANY', 'INTERVIEW_TYPE', 'INTERVIEW_FLOW', 'EMPLOYEE', 'INTERVIEW_STEP', 'POSITION', 'APPLICATION', 'INTERVIEW')
ORDER BY table_name;

-- Verificar foreign keys
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name IN ('EMPLOYEE', 'INTERVIEW_STEP', 'POSITION', 'APPLICATION', 'INTERVIEW')
ORDER BY tc.table_name, kcu.column_name;

-- Verificar índices
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename IN ('COMPANY', 'INTERVIEW_TYPE', 'INTERVIEW_FLOW', 'EMPLOYEE', 'INTERVIEW_STEP', 'POSITION', 'APPLICATION', 'INTERVIEW')
ORDER BY tablename, indexname;

-- Verificar constraints
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name IN ('COMPANY', 'INTERVIEW_TYPE', 'INTERVIEW_FLOW', 'EMPLOYEE', 'INTERVIEW_STEP', 'POSITION', 'APPLICATION', 'INTERVIEW')
ORDER BY tc.table_name, tc.constraint_type;

-- Verificar datos en las nuevas tablas
SELECT 'COMPANY' as table_name, COUNT(*) as record_count FROM "COMPANY"
UNION ALL
SELECT 'INTERVIEW_TYPE', COUNT(*) FROM "INTERVIEW_TYPE"
UNION ALL
SELECT 'INTERVIEW_FLOW', COUNT(*) FROM "INTERVIEW_FLOW"
UNION ALL
SELECT 'EMPLOYEE', COUNT(*) FROM "EMPLOYEE"
UNION ALL
SELECT 'INTERVIEW_STEP', COUNT(*) FROM "INTERVIEW_STEP"
UNION ALL
SELECT 'POSITION', COUNT(*) FROM "POSITION";

-- Verificar relaciones entre tablas
SELECT 
    'COMPANY -> EMPLOYEE' as relationship,
    COUNT(e.id) as employee_count
FROM "COMPANY" c
LEFT JOIN "EMPLOYEE" e ON c.id = e.company_id
GROUP BY c.id, c.name
ORDER BY c.id;

SELECT 
    'INTERVIEW_FLOW -> INTERVIEW_STEP' as relationship,
    if.description as flow_description,
    COUNT(is.id) as step_count
FROM "INTERVIEW_FLOW" if
LEFT JOIN "INTERVIEW_STEP" is ON if.id = is.interview_flow_id
GROUP BY if.id, if.description
ORDER BY if.id;

SELECT 
    'POSITION -> COMPANY' as relationship,
    p.title as position_title,
    c.name as company_name
FROM "POSITION" p
JOIN "COMPANY" c ON p.company_id = c.id
ORDER BY c.name, p.title;

-- Verificar que las tablas originales siguen intactas
SELECT 'Candidate' as table_name, COUNT(*) as record_count FROM "Candidate"
UNION ALL
SELECT 'Education', COUNT(*) FROM "Education"
UNION ALL
SELECT 'WorkExperience', COUNT(*) FROM "WorkExperience"
UNION ALL
SELECT 'Resume', COUNT(*) FROM "Resume";

-- Mensaje de confirmación
DO $$
BEGIN
    RAISE NOTICE '=====================================================';
    RAISE NOTICE 'VERIFICACIÓN DE FASE 2 COMPLETADA';
    RAISE NOTICE '=====================================================';
    RAISE NOTICE 'Si todas las consultas anteriores se ejecutaron sin errores,';
    RAISE NOTICE 'la Fase 2 se ha implementado correctamente.';
    RAISE NOTICE '';
    RAISE NOTICE 'Próximos pasos:';
    RAISE NOTICE '1. Actualizar el schema.prisma';
    RAISE NOTICE '2. Crear nuevos modelos de dominio';
    RAISE NOTICE '3. Implementar servicios y controladores';
    RAISE NOTICE '=====================================================';
END $$; 