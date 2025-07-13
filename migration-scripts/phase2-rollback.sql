-- =====================================================
-- FASE 2 - ROLLBACK SCRIPT
-- =====================================================
-- Script para revertir todos los cambios de la Fase 2
-- EJECUTAR SOLO EN CASO DE PROBLEMAS O PARA REVERTIR CAMBIOS

-- Eliminar tablas de proceso (en orden inverso por dependencias)
DROP TABLE IF EXISTS "INTERVIEW" CASCADE;
DROP TABLE IF EXISTS "APPLICATION" CASCADE;

-- Eliminar tablas con dependencias
DROP TABLE IF EXISTS "POSITION" CASCADE;
DROP TABLE IF EXISTS "INTERVIEW_STEP" CASCADE;
DROP TABLE IF EXISTS "EMPLOYEE" CASCADE;

-- Eliminar tablas base
DROP TABLE IF EXISTS "INTERVIEW_FLOW" CASCADE;
DROP TABLE IF EXISTS "INTERVIEW_TYPE" CASCADE;
DROP TABLE IF EXISTS "COMPANY" CASCADE;

-- Verificar que las tablas se eliminaron correctamente
-- Las siguientes consultas deberían fallar si las tablas se eliminaron correctamente
-- SELECT COUNT(*) FROM "COMPANY";
-- SELECT COUNT(*) FROM "INTERVIEW_TYPE";
-- SELECT COUNT(*) FROM "INTERVIEW_FLOW";
-- SELECT COUNT(*) FROM "EMPLOYEE";
-- SELECT COUNT(*) FROM "INTERVIEW_STEP";
-- SELECT COUNT(*) FROM "POSITION";
-- SELECT COUNT(*) FROM "APPLICATION";
-- SELECT COUNT(*) FROM "INTERVIEW";

-- Mensaje de confirmación
DO $$
BEGIN
    RAISE NOTICE 'Rollback de Fase 2 completado. Todas las tablas nuevas han sido eliminadas.';
    RAISE NOTICE 'Las tablas originales (Candidate, Education, WorkExperience, Resume) permanecen intactas.';
END $$; 