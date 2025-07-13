-- =====================================================
-- FASE 2 - DATOS SEMILLA (SEED DATA)
-- =====================================================
-- Insertar datos básicos para que el sistema funcione
-- Estos datos son necesarios para que las nuevas funcionalidades trabajen

-- Insertar empresas de ejemplo
INSERT INTO "COMPANY" ("name") VALUES 
('Tech Solutions Inc.'),
('Digital Innovations Ltd.'),
('StartUp Dynamics'),
('Global Tech Corp.'),
('Innovation Hub');

-- Insertar tipos de entrevista
INSERT INTO "INTERVIEW_TYPE" ("name", "description") VALUES 
('Technical Interview', 'Evaluación de habilidades técnicas y conocimientos específicos'),
('HR Interview', 'Entrevista de recursos humanos para evaluar fit cultural'),
('Cultural Fit', 'Evaluación de ajuste cultural y valores de la empresa'),
('Final Interview', 'Entrevista final con directivos o stakeholders'),
('Code Review', 'Revisión de código y resolución de problemas técnicos'),
('Behavioral Interview', 'Evaluación de comportamiento y situaciones pasadas'),
('System Design', 'Diseño de sistemas y arquitectura'),
('Leadership Assessment', 'Evaluación de habilidades de liderazgo');

-- Insertar flujos de entrevista
INSERT INTO "INTERVIEW_FLOW" ("description") VALUES 
('Flujo estándar de entrevistas para posiciones junior'),
('Flujo para posiciones senior con múltiples rondas'),
('Flujo para posiciones de liderazgo'),
('Flujo rápido para posiciones urgentes'),
('Flujo completo para posiciones críticas');

-- Insertar empleados de ejemplo
INSERT INTO "EMPLOYEE" ("company_id", "name", "email", "role") VALUES 
(1, 'John Manager', 'john.manager@techsolutions.com', 'HR Manager'),
(1, 'Jane Tech Lead', 'jane.techlead@techsolutions.com', 'Technical Lead'),
(1, 'Mike Senior Dev', 'mike.senior@techsolutions.com', 'Senior Developer'),
(2, 'Bob Director', 'bob.director@digitalinnovations.com', 'Director'),
(2, 'Alice HR', 'alice.hr@digitalinnovations.com', 'HR Specialist'),
(3, 'Carlos CTO', 'carlos.cto@startupdynamics.com', 'CTO'),
(3, 'Maria Recruiter', 'maria.recruiter@startupdynamics.com', 'Recruiter'),
(4, 'David VP', 'david.vp@globaltech.com', 'VP Engineering'),
(5, 'Sarah Lead', 'sarah.lead@innovationhub.com', 'Team Lead');

-- Insertar pasos de entrevista para el flujo estándar (id=1)
INSERT INTO "INTERVIEW_STEP" ("interview_flow_id", "interview_type_id", "name", "order_index") VALUES 
(1, 1, 'Screening Técnico', 1),
(1, 2, 'Entrevista HR', 2),
(1, 3, 'Cultural Fit', 3);

-- Insertar pasos de entrevista para el flujo senior (id=2)
INSERT INTO "INTERVIEW_STEP" ("interview_flow_id", "interview_type_id", "name", "order_index") VALUES 
(2, 1, 'Screening Técnico Inicial', 1),
(2, 5, 'Code Review', 2),
(2, 7, 'System Design', 3),
(2, 2, 'Entrevista HR', 4),
(2, 3, 'Cultural Fit', 5),
(2, 4, 'Entrevista Final', 6);

-- Insertar pasos de entrevista para el flujo de liderazgo (id=3)
INSERT INTO "INTERVIEW_STEP" ("interview_flow_id", "interview_type_id", "name", "order_index") VALUES 
(3, 1, 'Screening Técnico', 1),
(3, 6, 'Behavioral Interview', 2),
(3, 8, 'Leadership Assessment', 3),
(3, 2, 'Entrevista HR', 4),
(3, 4, 'Entrevista Final con CEO', 5);

-- Insertar posiciones de ejemplo
INSERT INTO "POSITION" (
    "company_id", 
    "interview_flow_id", 
    "title", 
    "description", 
    "location", 
    "job_description", 
    "requirements", 
    "responsibilities", 
    "salary_min", 
    "salary_max", 
    "employment_type", 
    "benefits", 
    "company_description", 
    "application_deadline"
) VALUES 
(
    1, 1, 'Junior Full Stack Developer',
    'Desarrollador Full Stack Junior con experiencia en React y Node.js',
    'Madrid, España',
    'Desarrollar aplicaciones web completas usando React en el frontend y Node.js en el backend. Trabajar en equipo con metodologías ágiles.',
    'Conocimientos básicos de JavaScript, React, Node.js. Ganas de aprender y crecer profesionalmente.',
    'Desarrollar features, escribir tests, participar en code reviews, colaborar con el equipo.',
    25000, 35000, 'full-time',
    'Seguro médico, formación continua, horario flexible, teletrabajo parcial',
    'Tech Solutions Inc. es una empresa líder en desarrollo de software con más de 10 años de experiencia.',
    '2024-12-31'
),
(
    1, 2, 'Senior Backend Developer',
    'Desarrollador Backend Senior con experiencia en microservicios y arquitecturas escalables',
    'Barcelona, España',
    'Diseñar e implementar arquitecturas de microservicios, optimizar performance, liderar proyectos técnicos.',
    '5+ años de experiencia en desarrollo backend, conocimiento profundo de bases de datos, experiencia con microservicios.',
    'Diseñar arquitecturas, mentorizar desarrolladores junior, optimizar performance, code reviews.',
    50000, 70000, 'full-time',
    'Seguro médico premium, stock options, formación avanzada, horario flexible',
    'Tech Solutions Inc. ofrece un entorno de trabajo dinámico con proyectos desafiantes.',
    '2024-11-30'
),
(
    2, 2, 'Frontend Lead',
    'Líder de desarrollo Frontend con experiencia en React y arquitecturas modernas',
    'Valencia, España',
    'Liderar el desarrollo frontend, establecer mejores prácticas, mentorizar al equipo.',
    '3+ años de experiencia en React, TypeScript, liderazgo técnico, experiencia con testing.',
    'Liderar el equipo frontend, establecer arquitecturas, code reviews, mentorizar.',
    45000, 65000, 'full-time',
    'Seguro médico, formación, horario flexible, teletrabajo',
    'Digital Innovations Ltd. es una startup innovadora en el sector fintech.',
    '2024-10-31'
),
(
    3, 3, 'Engineering Manager',
    'Manager de ingeniería para liderar equipos de desarrollo',
    'Madrid, España',
    'Liderar equipos de desarrollo, establecer procesos, gestionar proyectos técnicos.',
    '5+ años de experiencia técnica, 2+ años de liderazgo, experiencia con metodologías ágiles.',
    'Gestionar equipos, establecer procesos, mentorizar, planificar proyectos.',
    60000, 85000, 'full-time',
    'Seguro médico premium, stock options, formación ejecutiva, horario flexible',
    'StartUp Dynamics es una empresa en crecimiento con proyectos innovadores.',
    '2024-09-30'
),
(
    4, 1, 'DevOps Engineer',
    'Ingeniero DevOps para automatizar y optimizar procesos de desarrollo',
    'Bilbao, España',
    'Implementar CI/CD, gestionar infraestructura cloud, optimizar procesos de deployment.',
    'Experiencia con Docker, Kubernetes, AWS/Azure, automatización, scripting.',
    'Mantener infraestructura, automatizar procesos, optimizar performance, documentar.',
    40000, 60000, 'full-time',
    'Seguro médico, formación en cloud, horario flexible, teletrabajo',
    'Global Tech Corp. es una empresa global con presencia en múltiples países.',
    '2024-08-31'
);

-- Verificar que los datos se insertaron correctamente
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