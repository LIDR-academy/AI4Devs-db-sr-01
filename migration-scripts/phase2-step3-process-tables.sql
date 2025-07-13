-- =====================================================
-- FASE 2 - PASO 2.3: TABLAS DE PROCESO
-- =====================================================
-- Crear tablas que manejan el proceso de reclutamiento
-- Estas tablas conectan candidatos con posiciones y entrevistas

-- Tabla de aplicaciones (conecta candidatos con posiciones)
CREATE TABLE "APPLICATION" (
    "id" SERIAL NOT NULL,
    "position_id" INTEGER NOT NULL,
    "candidate_id" INTEGER NOT NULL,
    "application_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "status" VARCHAR(50) NOT NULL DEFAULT 'pending',
    "notes" TEXT,
    CONSTRAINT "APPLICATION_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "APPLICATION_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "POSITION"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "APPLICATION_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla de entrevistas (conecta aplicaciones con empleados y pasos)
CREATE TABLE "INTERVIEW" (
    "id" SERIAL NOT NULL,
    "application_id" INTEGER NOT NULL,
    "interview_step_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "interview_date" DATE NOT NULL,
    "result" VARCHAR(50),
    "score" INTEGER,
    "notes" TEXT,
    CONSTRAINT "INTERVIEW_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "INTERVIEW_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "APPLICATION"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "INTERVIEW_interview_step_id_fkey" FOREIGN KEY ("interview_step_id") REFERENCES "INTERVIEW_STEP"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "INTERVIEW_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "EMPLOYEE"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Crear índices para mejorar performance
CREATE INDEX "idx_application_position_id" ON "APPLICATION" ("position_id");
CREATE INDEX "idx_application_candidate_id" ON "APPLICATION" ("candidate_id");
CREATE INDEX "idx_application_status" ON "APPLICATION" ("status");
CREATE INDEX "idx_application_date" ON "APPLICATION" ("application_date");

CREATE INDEX "idx_interview_application_id" ON "INTERVIEW" ("application_id");
CREATE INDEX "idx_interview_step_id" ON "INTERVIEW" ("interview_step_id");
CREATE INDEX "idx_interview_employee_id" ON "INTERVIEW" ("employee_id");
CREATE INDEX "idx_interview_date" ON "INTERVIEW" ("interview_date");
CREATE INDEX "idx_interview_result" ON "INTERVIEW" ("result");

-- Crear constraint para validar el score de la entrevista
ALTER TABLE "INTERVIEW" 
ADD CONSTRAINT "chk_score_range" CHECK (
    "score" IS NULL OR ("score" >= 0 AND "score" <= 100)
);

-- Crear constraint para validar el estado de la aplicación
ALTER TABLE "APPLICATION" 
ADD CONSTRAINT "chk_application_status" CHECK (
    "status" IN ('pending', 'reviewing', 'shortlisted', 'rejected', 'hired', 'withdrawn')
);

-- Crear constraint para validar el resultado de la entrevista
ALTER TABLE "INTERVIEW" 
ADD CONSTRAINT "chk_interview_result" CHECK (
    "result" IS NULL OR "result" IN ('passed', 'failed', 'pending', 'cancelled', 'rescheduled')
);

-- Crear constraint para evitar aplicaciones duplicadas
ALTER TABLE "APPLICATION" 
ADD CONSTRAINT "unique_candidate_position" UNIQUE ("candidate_id", "position_id");

-- Comentarios para documentación
COMMENT ON TABLE "APPLICATION" IS 'Aplicaciones de candidatos a posiciones específicas';
COMMENT ON TABLE "INTERVIEW" IS 'Entrevistas realizadas como parte del proceso de selección';

COMMENT ON COLUMN "APPLICATION"."id" IS 'Identificador único de la aplicación';
COMMENT ON COLUMN "APPLICATION"."position_id" IS 'Referencia a la posición a la que se aplica';
COMMENT ON COLUMN "APPLICATION"."candidate_id" IS 'Referencia al candidato que aplica';
COMMENT ON COLUMN "APPLICATION"."application_date" IS 'Fecha en que se realizó la aplicación';
COMMENT ON COLUMN "APPLICATION"."status" IS 'Estado de la aplicación (pending, reviewing, shortlisted, rejected, hired, withdrawn)';
COMMENT ON COLUMN "APPLICATION"."notes" IS 'Notas adicionales sobre la aplicación';

COMMENT ON COLUMN "INTERVIEW"."id" IS 'Identificador único de la entrevista';
COMMENT ON COLUMN "INTERVIEW"."application_id" IS 'Referencia a la aplicación asociada';
COMMENT ON COLUMN "INTERVIEW"."interview_step_id" IS 'Referencia al paso de entrevista específico';
COMMENT ON COLUMN "INTERVIEW"."employee_id" IS 'Referencia al empleado que realiza la entrevista';
COMMENT ON COLUMN "INTERVIEW"."interview_date" IS 'Fecha programada para la entrevista';
COMMENT ON COLUMN "INTERVIEW"."result" IS 'Resultado de la entrevista (passed, failed, pending, cancelled, rescheduled)';
COMMENT ON COLUMN "INTERVIEW"."score" IS 'Puntuación de la entrevista (0-100)';
COMMENT ON COLUMN "INTERVIEW"."notes" IS 'Notas del entrevistador sobre la entrevista'; 