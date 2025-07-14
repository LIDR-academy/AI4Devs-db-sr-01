-- Script SQL para implementar el ERD del sistema de aplicaciones laborales
-- Basado en el diagrama Mermaid proporcionado

-- =====================================================
-- 1. CREACIÓN DE ENUMS PARA VALIDACIÓN DE DATOS
-- =====================================================

CREATE TYPE "PositionStatus" AS ENUM ('DRAFT', 'ACTIVE', 'PAUSED', 'CLOSED');
CREATE TYPE "EmploymentType" AS ENUM ('FULL_TIME', 'PART_TIME', 'CONTRACT', 'INTERNSHIP');
CREATE TYPE "ApplicationStatus" AS ENUM ('APPLIED', 'REVIEWING', 'INTERVIEWING', 'OFFERED', 'HIRED', 'REJECTED', 'WITHDRAWN');
CREATE TYPE "InterviewResult" AS ENUM ('PENDING', 'PASSED', 'FAILED', 'CANCELLED');

-- =====================================================
-- 2. CREACIÓN DE TABLAS PRINCIPALES
-- =====================================================

-- Tabla de empresas
CREATE TABLE "Company" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100)
);

-- Tabla de empleados
CREATE TABLE "Employee" (
    "id" SERIAL PRIMARY KEY,
    "companyId" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) UNIQUE NOT NULL,
    "role" VARCHAR(100) NOT NULL,
    "isActive" BOOLEAN DEFAULT true,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100),
    FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE
);

-- Tabla de flujos de entrevista
CREATE TABLE "InterviewFlow" (
    "id" SERIAL PRIMARY KEY,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100)
);

-- Tabla de tipos de entrevista
CREATE TABLE "InterviewType" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) UNIQUE NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100)
);

-- Tabla de posiciones laborales
CREATE TABLE "Position" (
    "id" SERIAL PRIMARY KEY,
    "companyId" INTEGER NOT NULL,
    "interviewFlowId" INTEGER NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "status" "PositionStatus" DEFAULT 'DRAFT',
    "isVisible" BOOLEAN DEFAULT true,
    "location" VARCHAR(255),
    "jobDescription" TEXT,
    "requirements" TEXT,
    "responsibilities" TEXT,
    "salaryMin" DECIMAL(10,2),
    "salaryMax" DECIMAL(10,2),
    "employmentType" "EmploymentType",
    "benefits" TEXT,
    "companyDescription" TEXT,
    "applicationDeadline" TIMESTAMP,
    "contactInfo" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100),
    FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE,
    FOREIGN KEY ("interviewFlowId") REFERENCES "InterviewFlow"("id")
);

-- Tabla de pasos de entrevista
CREATE TABLE "InterviewStep" (
    "id" SERIAL PRIMARY KEY,
    "interviewFlowId" INTEGER NOT NULL,
    "interviewTypeId" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "orderIndex" INTEGER NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100),
    FOREIGN KEY ("interviewFlowId") REFERENCES "InterviewFlow"("id") ON DELETE CASCADE,
    FOREIGN KEY ("interviewTypeId") REFERENCES "InterviewType"("id"),
    UNIQUE("interviewFlowId", "orderIndex")
);

-- Tabla de aplicaciones
CREATE TABLE "Application" (
    "id" SERIAL PRIMARY KEY,
    "positionId" INTEGER NOT NULL,
    "candidateId" INTEGER NOT NULL,
    "applicationDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "status" "ApplicationStatus" DEFAULT 'APPLIED',
    "notes" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100),
    FOREIGN KEY ("positionId") REFERENCES "Position"("id") ON DELETE CASCADE,
    FOREIGN KEY ("candidateId") REFERENCES "Candidate"("id") ON DELETE CASCADE,
    UNIQUE("positionId", "candidateId")
);

-- Tabla de entrevistas
CREATE TABLE "Interview" (
    "id" SERIAL PRIMARY KEY,
    "applicationId" INTEGER NOT NULL,
    "interviewStepId" INTEGER NOT NULL,
    "employeeId" INTEGER NOT NULL,
    "interviewDate" TIMESTAMP NOT NULL,
    "result" "InterviewResult" DEFAULT 'PENDING',
    "score" INTEGER CHECK ("score" >= 0 AND "score" <= 100),
    "notes" TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "createdBy" VARCHAR(100),
    "updatedBy" VARCHAR(100),
    FOREIGN KEY ("applicationId") REFERENCES "Application"("id") ON DELETE CASCADE,
    FOREIGN KEY ("interviewStepId") REFERENCES "InterviewStep"("id"),
    FOREIGN KEY ("employeeId") REFERENCES "Employee"("id")
);

-- =====================================================
-- 3. CREACIÓN DE ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices básicos para consultas frecuentes
CREATE INDEX "idx_employee_company" ON "Employee"("companyId");
CREATE INDEX "idx_employee_email" ON "Employee"("email");
CREATE INDEX "idx_position_company" ON "Position"("companyId");
CREATE INDEX "idx_position_status" ON "Position"("status");
CREATE INDEX "idx_position_visible" ON "Position"("isVisible");
CREATE INDEX "idx_application_position" ON "Application"("positionId");
CREATE INDEX "idx_application_candidate" ON "Application"("candidateId");
CREATE INDEX "idx_application_status" ON "Application"("status");
CREATE INDEX "idx_interview_application" ON "Interview"("applicationId");
CREATE INDEX "idx_interview_employee" ON "Interview"("employeeId");
CREATE INDEX "idx_interview_date" ON "Interview"("interviewDate");
CREATE INDEX "idx_interview_step_flow" ON "InterviewStep"("interviewFlowId");

-- Índices de texto completo para búsquedas avanzadas
CREATE INDEX "idx_position_title_gin" ON "Position" USING gin(to_tsvector('english', "title"));
CREATE INDEX "idx_position_description_gin" ON "Position" USING gin(to_tsvector('english', "description"));
CREATE INDEX "idx_position_job_description_gin" ON "Position" USING gin(to_tsvector('english', "jobDescription"));
CREATE INDEX "idx_position_requirements_gin" ON "Position" USING gin(to_tsvector('english', "requirements"));

-- =====================================================
-- 4. FUNCIONES Y TRIGGERS
-- =====================================================

-- Función para actualizar updatedAt automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para actualizar updatedAt en todas las tablas
CREATE TRIGGER "update_company_updated_at" BEFORE UPDATE ON "Company" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER "update_employee_updated_at" BEFORE UPDATE ON "Employee" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER "update_interview_flow_updated_at" BEFORE UPDATE ON "InterviewFlow" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER "update_interview_type_updated_at" BEFORE UPDATE ON "InterviewType" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER "update_position_updated_at" BEFORE UPDATE ON "Position" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER "update_interview_step_updated_at" BEFORE UPDATE ON "InterviewStep" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER "update_application_updated_at" BEFORE UPDATE ON "Application" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER "update_interview_updated_at" BEFORE UPDATE ON "Interview" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para evitar superposición de entrevistas
CREATE OR REPLACE FUNCTION check_interview_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM "Interview" 
        WHERE "employeeId" = NEW."employeeId" 
        AND "interviewDate" = NEW."interviewDate"
        AND "id" != COALESCE(NEW."id", -1)
    ) THEN
        RAISE EXCEPTION 'El empleado ya tiene una entrevista programada en esta fecha y hora';
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER "check_interview_overlap_trigger" 
    BEFORE INSERT OR UPDATE ON "Interview" 
    FOR EACH ROW EXECUTE FUNCTION check_interview_overlap();

-- =====================================================
-- 5. DATOS DE EJEMPLO
-- =====================================================

-- Insertar tipos de entrevista predefinidos
INSERT INTO "InterviewType" ("name", "description", "createdBy", "createdAt", "updatedAt") VALUES
('Entrevista telefónica', 'Entrevista inicial por teléfono para evaluar candidato', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Entrevista técnica', 'Evaluación de habilidades técnicas del candidato', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Entrevista cultural', 'Evaluación de fit cultural y valores de la empresa', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Entrevista final', 'Entrevista final con el equipo directivo', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Prueba técnica', 'Evaluación práctica de habilidades técnicas', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Entrevista con el equipo', 'Entrevista con miembros del equipo de trabajo', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insertar flujo de entrevista estándar
INSERT INTO "InterviewFlow" ("description", "createdBy", "createdAt", "updatedAt") VALUES
('Flujo estándar de entrevistas', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Flujo técnico avanzado', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Flujo ejecutivo', 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insertar pasos del flujo estándar
INSERT INTO "InterviewStep" ("interviewFlowId", "interviewTypeId", "name", "orderIndex", "createdBy", "createdAt", "updatedAt") VALUES
(1, 1, 'Entrevista telefónica inicial', 1, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 2, 'Entrevista técnica', 2, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 3, 'Entrevista cultural', 3, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 4, 'Entrevista final', 4, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insertar pasos del flujo técnico avanzado
INSERT INTO "InterviewStep" ("interviewFlowId", "interviewTypeId", "name", "orderIndex", "createdBy", "createdAt", "updatedAt") VALUES
(2, 1, 'Entrevista telefónica inicial', 1, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 5, 'Prueba técnica', 2, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, 'Entrevista técnica profunda', 3, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 6, 'Entrevista con el equipo', 4, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 4, 'Entrevista final', 5, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insertar pasos del flujo ejecutivo
INSERT INTO "InterviewStep" ("interviewFlowId", "interviewTypeId", "name", "orderIndex", "createdBy", "createdAt", "updatedAt") VALUES
(3, 1, 'Entrevista telefónica inicial', 1, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 3, 'Entrevista cultural', 2, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 4, 'Entrevista final ejecutiva', 3, 'system', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- =====================================================
-- 6. COMENTARIOS Y DOCUMENTACIÓN
-- =====================================================

COMMENT ON TABLE "Company" IS 'Empresas que publican posiciones laborales';
COMMENT ON TABLE "Employee" IS 'Empleados de las empresas que pueden conducir entrevistas';
COMMENT ON TABLE "InterviewFlow" IS 'Flujos de entrevista configurables para diferentes tipos de posiciones';
COMMENT ON TABLE "InterviewType" IS 'Tipos de entrevista disponibles en el sistema';
COMMENT ON TABLE "Position" IS 'Posiciones laborales con información completa';
COMMENT ON TABLE "InterviewStep" IS 'Pasos específicos dentro de un flujo de entrevista';
COMMENT ON TABLE "Application" IS 'Aplicaciones de candidatos a posiciones';
COMMENT ON TABLE "Interview" IS 'Entrevistas específicas con resultados y puntuaciones';

COMMENT ON COLUMN "Position"."salaryMin" IS 'Salario mínimo en formato decimal (10,2)';
COMMENT ON COLUMN "Position"."salaryMax" IS 'Salario máximo en formato decimal (10,2)';
COMMENT ON COLUMN "Interview"."score" IS 'Puntuación de la entrevista (0-100)';
COMMENT ON COLUMN "InterviewStep"."orderIndex" IS 'Orden secuencial del paso en el flujo';

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================

-- Para ejecutar este script:
-- docker exec -i ai4devs-db-sr-01-db-1 psql -U LTIdbUser -d LTIdb < backend/prisma/erd_migration.sql
-- 
-- Después de ejecutar, regenerar el cliente Prisma:
-- npx prisma generate 