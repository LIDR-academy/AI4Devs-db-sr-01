-- =====================================================
-- FASE 2 - PASO 2.2: TABLAS CON DEPENDENCIAS
-- =====================================================
-- Crear tablas que dependen de las tablas base
-- Estas tablas tienen foreign keys hacia las tablas creadas en el paso anterior

-- Tabla de empleados (depende de COMPANY)
CREATE TABLE "EMPLOYEE" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "role" VARCHAR(100) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "EMPLOYEE_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "EMPLOYEE_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "COMPANY"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla de pasos de entrevista (depende de INTERVIEW_FLOW e INTERVIEW_TYPE)
CREATE TABLE "INTERVIEW_STEP" (
    "id" SERIAL NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "interview_type_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "order_index" INTEGER NOT NULL,
    CONSTRAINT "INTERVIEW_STEP_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "INTERVIEW_STEP_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "INTERVIEW_FLOW"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "INTERVIEW_STEP_interview_type_id_fkey" FOREIGN KEY ("interview_type_id") REFERENCES "INTERVIEW_TYPE"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabla de posiciones (depende de COMPANY e INTERVIEW_FLOW)
CREATE TABLE "POSITION" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(50) NOT NULL DEFAULT 'active',
    "is_visible" BOOLEAN NOT NULL DEFAULT true,
    "location" VARCHAR(255),
    "job_description" TEXT,
    "requirements" TEXT,
    "responsibilities" TEXT,
    "salary_min" DECIMAL(10,2),
    "salary_max" DECIMAL(10,2),
    "employment_type" VARCHAR(50),
    "benefits" TEXT,
    "company_description" TEXT,
    "application_deadline" DATE,
    "contact_info" TEXT,
    CONSTRAINT "POSITION_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "POSITION_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "COMPANY"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "POSITION_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "INTERVIEW_FLOW"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Crear índices para mejorar performance
CREATE INDEX "idx_employee_company_id" ON "EMPLOYEE" ("company_id");
CREATE INDEX "idx_employee_email" ON "EMPLOYEE" ("email");
CREATE INDEX "idx_employee_is_active" ON "EMPLOYEE" ("is_active");

CREATE INDEX "idx_interview_step_flow_id" ON "INTERVIEW_STEP" ("interview_flow_id");
CREATE INDEX "idx_interview_step_type_id" ON "INTERVIEW_STEP" ("interview_type_id");
CREATE INDEX "idx_interview_step_order" ON "INTERVIEW_STEP" ("order_index");

CREATE INDEX "idx_position_company_id" ON "POSITION" ("company_id");
CREATE INDEX "idx_position_flow_id" ON "POSITION" ("interview_flow_id");
CREATE INDEX "idx_position_status" ON "POSITION" ("status");
CREATE INDEX "idx_position_is_visible" ON "POSITION" ("is_visible");
CREATE INDEX "idx_position_title" ON "POSITION" ("title");

-- Crear constraint para validar el orden de los pasos
ALTER TABLE "INTERVIEW_STEP" 
ADD CONSTRAINT "chk_order_index_positive" CHECK ("order_index" > 0);

-- Crear constraint para validar rangos de salario
ALTER TABLE "POSITION" 
ADD CONSTRAINT "chk_salary_range" CHECK (
    ("salary_min" IS NULL AND "salary_max" IS NULL) OR 
    ("salary_min" IS NOT NULL AND "salary_max" IS NOT NULL AND "salary_min" <= "salary_max")
);

-- Comentarios para documentación
COMMENT ON TABLE "EMPLOYEE" IS 'Empleados de las empresas que pueden realizar entrevistas';
COMMENT ON TABLE "INTERVIEW_STEP" IS 'Pasos individuales dentro de un flujo de entrevista';
COMMENT ON TABLE "POSITION" IS 'Posiciones de trabajo ofrecidas por las empresas';

COMMENT ON COLUMN "EMPLOYEE"."id" IS 'Identificador único del empleado';
COMMENT ON COLUMN "EMPLOYEE"."company_id" IS 'Referencia a la empresa a la que pertenece';
COMMENT ON COLUMN "EMPLOYEE"."name" IS 'Nombre completo del empleado';
COMMENT ON COLUMN "EMPLOYEE"."email" IS 'Email único del empleado';
COMMENT ON COLUMN "EMPLOYEE"."role" IS 'Rol o cargo del empleado';
COMMENT ON COLUMN "EMPLOYEE"."is_active" IS 'Indica si el empleado está activo en el sistema';

COMMENT ON COLUMN "INTERVIEW_STEP"."id" IS 'Identificador único del paso de entrevista';
COMMENT ON COLUMN "INTERVIEW_STEP"."interview_flow_id" IS 'Referencia al flujo de entrevista';
COMMENT ON COLUMN "INTERVIEW_STEP"."interview_type_id" IS 'Referencia al tipo de entrevista';
COMMENT ON COLUMN "INTERVIEW_STEP"."name" IS 'Nombre del paso de entrevista';
COMMENT ON COLUMN "INTERVIEW_STEP"."order_index" IS 'Orden del paso dentro del flujo';

COMMENT ON COLUMN "POSITION"."id" IS 'Identificador único de la posición';
COMMENT ON COLUMN "POSITION"."company_id" IS 'Referencia a la empresa que ofrece la posición';
COMMENT ON COLUMN "POSITION"."interview_flow_id" IS 'Referencia al flujo de entrevista para esta posición';
COMMENT ON COLUMN "POSITION"."title" IS 'Título de la posición';
COMMENT ON COLUMN "POSITION"."description" IS 'Descripción general de la posición';
COMMENT ON COLUMN "POSITION"."status" IS 'Estado de la posición (active, inactive, closed)';
COMMENT ON COLUMN "POSITION"."is_visible" IS 'Indica si la posición es visible públicamente';
COMMENT ON COLUMN "POSITION"."location" IS 'Ubicación de la posición';
COMMENT ON COLUMN "POSITION"."job_description" IS 'Descripción detallada del trabajo';
COMMENT ON COLUMN "POSITION"."requirements" IS 'Requisitos para la posición';
COMMENT ON COLUMN "POSITION"."responsibilities" IS 'Responsabilidades del puesto';
COMMENT ON COLUMN "POSITION"."salary_min" IS 'Salario mínimo ofrecido';
COMMENT ON COLUMN "POSITION"."salary_max" IS 'Salario máximo ofrecido';
COMMENT ON COLUMN "POSITION"."employment_type" IS 'Tipo de empleo (full-time, part-time, contract)';
COMMENT ON COLUMN "POSITION"."benefits" IS 'Beneficios ofrecidos';
COMMENT ON COLUMN "POSITION"."company_description" IS 'Descripción de la empresa';
COMMENT ON COLUMN "POSITION"."application_deadline" IS 'Fecha límite para aplicar';
COMMENT ON COLUMN "POSITION"."contact_info" IS 'Información de contacto para la posición'; 