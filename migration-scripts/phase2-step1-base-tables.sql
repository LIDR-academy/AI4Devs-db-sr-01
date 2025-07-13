-- =====================================================
-- FASE 2 - PASO 2.1: TABLAS BASE DEL SISTEMA
-- =====================================================
-- Crear tablas independientes primero (sin dependencias)
-- Estas tablas son la base para el sistema de reclutamiento

-- Tabla de empresas
CREATE TABLE "COMPANY" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    CONSTRAINT "COMPANY_pkey" PRIMARY KEY ("id")
);

-- Tabla de tipos de entrevista
CREATE TABLE "INTERVIEW_TYPE" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    CONSTRAINT "INTERVIEW_TYPE_pkey" PRIMARY KEY ("id")
);

-- Tabla de flujos de entrevista
CREATE TABLE "INTERVIEW_FLOW" (
    "id" SERIAL NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    CONSTRAINT "INTERVIEW_FLOW_pkey" PRIMARY KEY ("id")
);

-- Crear índices para mejorar performance
CREATE INDEX "idx_company_name" ON "COMPANY" ("name");
CREATE INDEX "idx_interview_type_name" ON "INTERVIEW_TYPE" ("name");
CREATE INDEX "idx_interview_flow_description" ON "INTERVIEW_FLOW" ("description");

-- Comentarios para documentación
COMMENT ON TABLE "COMPANY" IS 'Empresas que utilizan el sistema de reclutamiento';
COMMENT ON TABLE "INTERVIEW_TYPE" IS 'Tipos de entrevistas disponibles (técnica, HR, cultural, etc.)';
COMMENT ON TABLE "INTERVIEW_FLOW" IS 'Flujos de entrevistas que definen el proceso para cada posición';

COMMENT ON COLUMN "COMPANY"."id" IS 'Identificador único de la empresa';
COMMENT ON COLUMN "COMPANY"."name" IS 'Nombre de la empresa';

COMMENT ON COLUMN "INTERVIEW_TYPE"."id" IS 'Identificador único del tipo de entrevista';
COMMENT ON COLUMN "INTERVIEW_TYPE"."name" IS 'Nombre del tipo de entrevista';
COMMENT ON COLUMN "INTERVIEW_TYPE"."description" IS 'Descripción detallada del tipo de entrevista';

COMMENT ON COLUMN "INTERVIEW_FLOW"."id" IS 'Identificador único del flujo de entrevista';
COMMENT ON COLUMN "INTERVIEW_FLOW"."description" IS 'Descripción del flujo de entrevista'; 