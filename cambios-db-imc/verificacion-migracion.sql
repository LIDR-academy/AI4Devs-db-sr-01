-- Verificación de tablas creadas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
    'Candidate','Company','Employee','Position','InterviewFlow','InterviewStep','InterviewType','Application','Interview','Education','WorkExperience','Resume'
  );

-- Verificación de columnas clave (ejemplo)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'Position'
  AND column_name IN ('salaryMin','salaryMax','interviewFlowId');

-- Verificación de claves foráneas en tablas principales
SELECT tc.constraint_name,
       tc.table_name,
       kcu.column_name,
       ccu.table_name AS foreign_table,
       ccu.column_name AS foreign_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name IN ('Employee','Position','InterviewStep','Application','Interview','Education','WorkExperience','Resume');

-- Verificación de índices en tablas con FKs
SELECT indexname, tablename
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN ('Employee','Position','InterviewStep','Application','Interview');

-- Conteo de tablas principales (post-migración)
SELECT 'Candidate' AS table, COUNT(*) FROM "Candidate"
UNION ALL
SELECT 'Company', COUNT(*) FROM "Company"; 