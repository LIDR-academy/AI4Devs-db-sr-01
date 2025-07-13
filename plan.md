# Plan de Refactorización de Base de Datos - AI4Devs

## Análisis del Estado Actual

### Base de Datos Actual
El proyecto actualmente tiene una base de datos simple con 4 tablas:
- `Candidate` (candidatos)
- `Education` (educación)
- `WorkExperience` (experiencia laboral) 
- `Resume` (archivos CV)

### Diferencias con el Nuevo Diseño
El diagrama Mermaid propone un sistema mucho más complejo para un **Sistema de Gestión de Reclutamiento** que incluye:
- Gestión de empresas y empleados
- Posiciones de trabajo con flujos de entrevistas
- Aplicaciones y proceso de entrevistas
- Tipos de entrevistas y pasos estructurados

## PLAN 1: MIGRACIÓN A LA NUEVA ESTRUCTURA

### Fase 1: Análisis y Preparación
**Objetivo**: Preparar el terreno para la migración

#### Paso 1.1: Backup y Preparación
- [ ] Crear backup completo de la base de datos actual
- [ ] Crear branch específico para la migración: `feature/db-refactoring`
- [ ] Documentar datos existentes y su mapeo al nuevo esquema

#### Paso 1.2: Análisis de Dependencias
- [ ] Identificar todos los modelos, servicios y controladores que se verán afectados
- [ ] Mapear las relaciones actuales vs las nuevas relaciones
- [ ] Identificar datos que se perderán o necesitarán transformación

### Fase 2: Creación de Nuevas Tablas
**Objetivo**: Implementar la nueva estructura sin afectar la funcionalidad actual

#### Paso 2.1: Tablas Base del Sistema
```sql
-- Crear tablas independientes primero
CREATE TABLE "COMPANY" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    CONSTRAINT "COMPANY_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "INTERVIEW_TYPE" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    CONSTRAINT "INTERVIEW_TYPE_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "INTERVIEW_FLOW" (
    "id" SERIAL NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    CONSTRAINT "INTERVIEW_FLOW_pkey" PRIMARY KEY ("id")
);
```

#### Paso 2.2: Tablas con Dependencias
```sql
CREATE TABLE "EMPLOYEE" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "role" VARCHAR(100) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "EMPLOYEE_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "EMPLOYEE_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "COMPANY"("id")
);

CREATE TABLE "INTERVIEW_STEP" (
    "id" SERIAL NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "interview_type_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "order_index" INTEGER NOT NULL,
    CONSTRAINT "INTERVIEW_STEP_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "INTERVIEW_STEP_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "INTERVIEW_FLOW"("id"),
    CONSTRAINT "INTERVIEW_STEP_interview_type_id_fkey" FOREIGN KEY ("interview_type_id") REFERENCES "INTERVIEW_TYPE"("id")
);

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
    CONSTRAINT "POSITION_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "COMPANY"("id"),
    CONSTRAINT "POSITION_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") REFERENCES "INTERVIEW_FLOW"("id")
);
```

#### Paso 2.3: Tablas de Proceso
```sql
CREATE TABLE "APPLICATION" (
    "id" SERIAL NOT NULL,
    "position_id" INTEGER NOT NULL,
    "candidate_id" INTEGER NOT NULL,
    "application_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "status" VARCHAR(50) NOT NULL DEFAULT 'pending',
    "notes" TEXT,
    CONSTRAINT "APPLICATION_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "APPLICATION_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "POSITION"("id"),
    CONSTRAINT "APPLICATION_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id")
);

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
    CONSTRAINT "INTERVIEW_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "APPLICATION"("id"),
    CONSTRAINT "INTERVIEW_interview_step_id_fkey" FOREIGN KEY ("interview_step_id") REFERENCES "INTERVIEW_STEP"("id"),
    CONSTRAINT "INTERVIEW_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "EMPLOYEE"("id")
);
```

### Fase 3: Actualización del Schema de Prisma
**Objetivo**: Actualizar el schema.prisma para reflejar la nueva estructura

#### Paso 3.1: Nuevo Schema Prisma
```prisma
model Company {
  id        Int        @id @default(autoincrement())
  name      String     @db.VarChar(255)
  employees Employee[]
  positions Position[]
}

model Employee {
  id         Int       @id @default(autoincrement())
  companyId  Int       @map("company_id")
  name       String    @db.VarChar(255)
  email      String    @unique @db.VarChar(255)
  role       String    @db.VarChar(100)
  isActive   Boolean   @default(true) @map("is_active")
  company    Company   @relation(fields: [companyId], references: [id])
  interviews Interview[]
}

model Position {
  id                  Int             @id @default(autoincrement())
  companyId           Int             @map("company_id")
  interviewFlowId     Int             @map("interview_flow_id")
  title               String          @db.VarChar(255)
  description         String?         @db.Text
  status              String          @default("active") @db.VarChar(50)
  isVisible           Boolean         @default(true) @map("is_visible")
  location            String?         @db.VarChar(255)
  jobDescription      String?         @map("job_description") @db.Text
  requirements        String?         @db.Text
  responsibilities    String?         @db.Text
  salaryMin           Decimal?        @map("salary_min") @db.Decimal(10,2)
  salaryMax           Decimal?        @map("salary_max") @db.Decimal(10,2)
  employmentType      String?         @map("employment_type") @db.VarChar(50)
  benefits            String?         @db.Text
  companyDescription  String?         @map("company_description") @db.Text
  applicationDeadline DateTime?       @map("application_deadline") @db.Date
  contactInfo         String?         @map("contact_info") @db.Text
  company             Company         @relation(fields: [companyId], references: [id])
  interviewFlow       InterviewFlow   @relation(fields: [interviewFlowId], references: [id])
  applications        Application[]
}

model InterviewFlow {
  id              Int             @id @default(autoincrement())
  description     String          @db.VarChar(255)
  positions       Position[]
  interviewSteps  InterviewStep[]
}

model InterviewStep {
  id               Int           @id @default(autoincrement())
  interviewFlowId  Int           @map("interview_flow_id")
  interviewTypeId  Int           @map("interview_type_id")
  name             String        @db.VarChar(255)
  orderIndex       Int           @map("order_index")
  interviewFlow    InterviewFlow @relation(fields: [interviewFlowId], references: [id])
  interviewType    InterviewType @relation(fields: [interviewTypeId], references: [id])
  interviews       Interview[]
}

model InterviewType {
  id              Int             @id @default(autoincrement())
  name            String          @db.VarChar(100)
  description     String?         @db.Text
  interviewSteps  InterviewStep[]
}

model Application {
  id              Int         @id @default(autoincrement())
  positionId      Int         @map("position_id")
  candidateId     Int         @map("candidate_id")
  applicationDate DateTime    @default(now()) @map("application_date") @db.Date
  status          String      @default("pending") @db.VarChar(50)
  notes           String?     @db.Text
  position        Position    @relation(fields: [positionId], references: [id])
  candidate       Candidate   @relation(fields: [candidateId], references: [id])
  interviews      Interview[]
}

model Interview {
  id               Int           @id @default(autoincrement())
  applicationId    Int           @map("application_id")
  interviewStepId  Int           @map("interview_step_id")
  employeeId       Int           @map("employee_id")
  interviewDate    DateTime      @map("interview_date") @db.Date
  result           String?       @db.VarChar(50)
  score            Int?
  notes            String?       @db.Text
  application      Application   @relation(fields: [applicationId], references: [id])
  interviewStep    InterviewStep @relation(fields: [interviewStepId], references: [id])
  employee         Employee      @relation(fields: [employeeId], references: [id])
}

// Modelo Candidate actualizado
model Candidate {
  id              Int               @id @default(autoincrement())
  firstName       String            @db.VarChar(100)
  lastName        String            @db.VarChar(100)
  email           String            @unique @db.VarChar(255)
  phone           String?           @db.VarChar(15)
  address         String?           @db.VarChar(100)
  educations      Education[]
  workExperiences WorkExperience[]
  resumes         Resume[]
  applications    Application[]     // Nueva relación
}
```

### Fase 4: Migración de Datos
**Objetivo**: Migrar datos existentes y crear datos de prueba

#### Paso 4.1: Datos Semilla (Seed Data)
```sql
-- Insertar datos básicos para que el sistema funcione
INSERT INTO "COMPANY" ("name") VALUES 
('Tech Solutions Inc.'),
('Digital Innovations Ltd.'),
('StartUp Dynamics');

INSERT INTO "INTERVIEW_TYPE" ("name", "description") VALUES 
('Technical Interview', 'Evaluación de habilidades técnicas'),
('HR Interview', 'Entrevista de recursos humanos'),
('Cultural Fit', 'Evaluación de ajuste cultural'),
('Final Interview', 'Entrevista final con directivos');

INSERT INTO "INTERVIEW_FLOW" ("description") VALUES 
('Flujo estándar de entrevistas'),
('Flujo para posiciones senior'),
('Flujo para posiciones junior');

-- Crear empleados de ejemplo
INSERT INTO "EMPLOYEE" ("company_id", "name", "email", "role") VALUES 
(1, 'John Manager', 'john.manager@techsolutions.com', 'HR Manager'),
(1, 'Jane Tech Lead', 'jane.techlead@techsolutions.com', 'Technical Lead'),
(2, 'Bob Director', 'bob.director@digitalinnovations.com', 'Director');
```

#### Paso 4.2: Script de Migración de Datos
```typescript
// migration-script.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function migrateExistingData() {
    // Los candidatos existentes ya están en la base de datos
    // Solo necesitamos crear datos de ejemplo para las nuevas tablas
    
    // Crear posiciones de ejemplo
    const positions = await prisma.position.createMany({
        data: [
            {
                companyId: 1,
                interviewFlowId: 1,
                title: 'Full Stack Developer',
                description: 'Desarrollador Full Stack con experiencia en React y Node.js',
                location: 'Madrid, España',
                salaryMin: 35000,
                salaryMax: 50000,
                employmentType: 'full-time'
            },
            {
                companyId: 1,
                interviewFlowId: 2,
                title: 'Senior Backend Developer',
                description: 'Desarrollador Backend Senior con experiencia en microservicios',
                location: 'Barcelona, España',
                salaryMin: 50000,
                salaryMax: 70000,
                employmentType: 'full-time'
            }
        ]
    });
}
```

### Fase 5: Actualización del Código de Aplicación
**Objetivo**: Actualizar modelos, servicios y controladores

#### Paso 5.1: Nuevos Modelos de Dominio
- [ ] Crear modelo `Company`
- [ ] Crear modelo `Employee`
- [ ] Crear modelo `Position`
- [ ] Crear modelo `Application`
- [ ] Crear modelo `Interview`
- [ ] Crear modelo `InterviewFlow`
- [ ] Crear modelo `InterviewStep`
- [ ] Crear modelo `InterviewType`

#### Paso 5.2: Nuevos Servicios
- [ ] `companyService.ts` - Gestión de empresas
- [ ] `employeeService.ts` - Gestión de empleados
- [ ] `positionService.ts` - Gestión de posiciones
- [ ] `applicationService.ts` - Gestión de aplicaciones
- [ ] `interviewService.ts` - Gestión de entrevistas

#### Paso 5.3: Nuevos Controladores
- [ ] `companyController.ts`
- [ ] `employeeController.ts`
- [ ] `positionController.ts`
- [ ] `applicationController.ts`
- [ ] `interviewController.ts`

#### Paso 5.4: Nuevas Rutas
- [ ] `/companies` - CRUD de empresas
- [ ] `/employees` - CRUD de empleados
- [ ] `/positions` - CRUD de posiciones
- [ ] `/applications` - CRUD de aplicaciones
- [ ] `/interviews` - CRUD de entrevistas

### Fase 6: Testing y Validación
**Objetivo**: Asegurar que todo funciona correctamente

#### Paso 6.1: Tests Unitarios
- [ ] Tests para todos los nuevos modelos
- [ ] Tests para todos los nuevos servicios
- [ ] Tests para todos los nuevos controladores

#### Paso 6.2: Tests de Integración
- [ ] Tests de flujo completo de aplicación
- [ ] Tests de flujo completo de entrevistas
- [ ] Tests de relaciones entre entidades

#### Paso 6.3: Validación de Datos
- [ ] Verificar integridad referencial
- [ ] Verificar que no se han perdido datos
- [ ] Verificar que las funcionalidades existentes siguen funcionando

---

## PLAN 2: NORMALIZACIÓN DE LA BASE DE DATOS

### Análisis de Normalización

#### Estado Actual de Normalización
La base de datos actual ya está bastante normalizada:
- **1NF**: ✅ Cumple (no hay grupos repetidos)
- **2NF**: ✅ Cumple (no hay dependencias parciales)
- **3NF**: ✅ Cumple (no hay dependencias transitivas)

#### Oportunidades de Mejora en la Nueva Estructura

### Fase 1: Normalización de Datos de Ubicación

#### Problema Identificado
En la tabla `POSITION`, el campo `location` almacena texto libre, lo que puede causar inconsistencias.

#### Solución Propuesta
```sql
-- Crear tabla de países
CREATE TABLE "COUNTRY" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "code" VARCHAR(2) NOT NULL UNIQUE,
    CONSTRAINT "COUNTRY_pkey" PRIMARY KEY ("id")
);

-- Crear tabla de ciudades
CREATE TABLE "CITY" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "country_id" INTEGER NOT NULL,
    CONSTRAINT "CITY_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "CITY_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "COUNTRY"("id")
);

-- Modificar tabla POSITION
ALTER TABLE "POSITION" 
DROP COLUMN "location",
ADD COLUMN "city_id" INTEGER,
ADD CONSTRAINT "POSITION_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "CITY"("id");
```

### Fase 2: Normalización de Información de Contacto

#### Problema Identificado
Los campos `email` y `phone` en `Candidate` y `Employee` podrían normalizarse para permitir múltiples contactos.

#### Solución Propuesta
```sql
-- Crear tabla de tipos de contacto
CREATE TABLE "CONTACT_TYPE" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    CONSTRAINT "CONTACT_TYPE_pkey" PRIMARY KEY ("id")
);

-- Crear tabla de contactos
CREATE TABLE "CONTACT" (
    "id" SERIAL NOT NULL,
    "contact_type_id" INTEGER NOT NULL,
    "value" VARCHAR(255) NOT NULL,
    "is_primary" BOOLEAN DEFAULT false,
    "candidate_id" INTEGER,
    "employee_id" INTEGER,
    CONSTRAINT "CONTACT_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "CONTACT_contact_type_id_fkey" FOREIGN KEY ("contact_type_id") REFERENCES "CONTACT_TYPE"("id"),
    CONSTRAINT "CONTACT_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id"),
    CONSTRAINT "CONTACT_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "EMPLOYEE"("id")
);
```

### Fase 3: Normalización de Direcciones

#### Problema Identificado
El campo `address` en `Candidate` almacena toda la dirección en un solo campo.

#### Solución Propuesta
```sql
-- Crear tabla de direcciones
CREATE TABLE "ADDRESS" (
    "id" SERIAL NOT NULL,
    "street" VARCHAR(255),
    "number" VARCHAR(10),
    "postal_code" VARCHAR(10),
    "city_id" INTEGER,
    "candidate_id" INTEGER,
    "company_id" INTEGER,
    CONSTRAINT "ADDRESS_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "ADDRESS_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "CITY"("id"),
    CONSTRAINT "ADDRESS_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id"),
    CONSTRAINT "ADDRESS_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "COMPANY"("id")
);
```

### Fase 4: Normalización de Habilidades y Competencias

#### Problema Identificado
No hay forma de almacenar habilidades de candidatos de manera estructurada.

#### Solución Propuesta
```sql
-- Crear tabla de categorías de habilidades
CREATE TABLE "SKILL_CATEGORY" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    CONSTRAINT "SKILL_CATEGORY_pkey" PRIMARY KEY ("id")
);

-- Crear tabla de habilidades
CREATE TABLE "SKILL" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "category_id" INTEGER NOT NULL,
    CONSTRAINT "SKILL_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "SKILL_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "SKILL_CATEGORY"("id")
);

-- Crear tabla de habilidades de candidatos
CREATE TABLE "CANDIDATE_SKILL" (
    "id" SERIAL NOT NULL,
    "candidate_id" INTEGER NOT NULL,
    "skill_id" INTEGER NOT NULL,
    "level" VARCHAR(50), -- beginner, intermediate, advanced, expert
    "years_experience" INTEGER,
    CONSTRAINT "CANDIDATE_SKILL_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "CANDIDATE_SKILL_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "Candidate"("id"),
    CONSTRAINT "CANDIDATE_SKILL_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "SKILL"("id")
);

-- Crear tabla de habilidades requeridas para posiciones
CREATE TABLE "POSITION_SKILL" (
    "id" SERIAL NOT NULL,
    "position_id" INTEGER NOT NULL,
    "skill_id" INTEGER NOT NULL,
    "required_level" VARCHAR(50),
    "is_mandatory" BOOLEAN DEFAULT false,
    CONSTRAINT "POSITION_SKILL_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "POSITION_SKILL_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "POSITION"("id"),
    CONSTRAINT "POSITION_SKILL_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "SKILL"("id")
);
```

### Fase 5: Normalización de Archivos

#### Problema Identificado
La tabla `Resume` solo permite un tipo de archivo por candidato.

#### Solución Propuesta
```sql
-- Crear tabla de tipos de documentos
CREATE TABLE "DOCUMENT_TYPE" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" TEXT,
    CONSTRAINT "DOCUMENT_TYPE_pkey" PRIMARY KEY ("id")
);

-- Modificar tabla Resume para ser más genérica
ALTER TABLE "Resume" RENAME TO "DOCUMENT";
ALTER TABLE "DOCUMENT" 
ADD COLUMN "document_type_id" INTEGER,
ADD COLUMN "name" VARCHAR(255),
ADD CONSTRAINT "DOCUMENT_document_type_id_fkey" FOREIGN KEY ("document_type_id") REFERENCES "DOCUMENT_TYPE"("id");
```

### Fase 6: Auditoría y Trazabilidad

#### Problema Identificado
No hay forma de rastrear cambios en los datos.

#### Solución Propuesta
```sql
-- Añadir campos de auditoría a todas las tablas principales
ALTER TABLE "Candidate" 
ADD COLUMN "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN "created_by" INTEGER,
ADD COLUMN "updated_by" INTEGER;

ALTER TABLE "POSITION" 
ADD COLUMN "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN "created_by" INTEGER,
ADD COLUMN "updated_by" INTEGER;

-- Crear tabla de auditoría
CREATE TABLE "AUDIT_LOG" (
    "id" SERIAL NOT NULL,
    "table_name" VARCHAR(50) NOT NULL,
    "record_id" INTEGER NOT NULL,
    "action" VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
    "old_values" JSONB,
    "new_values" JSONB,
    "user_id" INTEGER,
    "timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "AUDIT_LOG_pkey" PRIMARY KEY ("id")
);
```

---

## Patrones de Codificación Identificados

### Backend (Clean Architecture)
- **Estructura por capas**: `domain/`, `application/`, `presentation/`
- **Modelos de dominio**: Clases con lógica de negocio y métodos `save()`, `findOne()`
- **Servicios de aplicación**: Funciones que orquestan operaciones (`addCandidate`, `getCandidateById`)
- **Controladores**: Manejan HTTP requests/responses y delegan a servicios
- **Validación centralizada**: Módulo `validator.ts` con funciones específicas
- **Manejo de errores**: Try-catch con mensajes específicos según tipo de error

### Naming Conventions
- **Archivos**: camelCase con sufijo del tipo (`candidateService.ts`, `candidateController.ts`)
- **Clases**: PascalCase (`Candidate`, `Education`)
- **Funciones**: camelCase (`addCandidate`, `validateEmail`)
- **Variables**: camelCase (`candidateData`, `savedCandidate`)
- **Constantes**: UPPER_SNAKE_CASE (`NAME_REGEX`, `EMAIL_REGEX`)

### Testing Patterns
- **Estructura**: `describe` para grupos, `it` para casos específicos
- **Mocking**: Jest mocks para dependencias externas (Prisma, modelos)
- **Assertions**: Uso de `expect` con matchers específicos
- **Setup/Teardown**: `beforeEach`, `afterEach` para limpieza

### Prisma Patterns
- **Mapeo de campos**: `@map()` para nombres de BD diferentes
- **Relaciones**: Definición explícita con `@relation()`
- **Constraints**: `@unique`, `@default()`, tipos específicos `@db.VarChar()`
- **Naming**: PascalCase para modelos, camelCase para campos

---

## Cronograma Estimado

### Plan 1: Migración (8-10 semanas)
- **Semana 1-2**: Análisis y preparación
- **Semana 3-4**: Creación de nuevas tablas y schema
- **Semana 5-6**: Migración de datos y nuevos modelos
- **Semana 7-8**: Servicios y controladores
- **Semana 9-10**: Testing y validación

### Plan 2: Normalización (4-6 semanas)
- **Semana 1-2**: Normalización de ubicaciones y contactos
- **Semana 3-4**: Normalización de habilidades y documentos
- **Semana 5-6**: Auditoría y optimización

## Riesgos Identificados

1. **Pérdida de datos**: Durante la migración
2. **Downtime**: Durante la implementación
3. **Incompatibilidad**: Con el frontend existente
4. **Performance**: Con la nueva estructura más compleja
5. **Complejidad**: Aumento significativo de la complejidad del sistema

## Recomendaciones

1. **Implementar por fases**: No hacer todo de una vez
2. **Mantener compatibilidad**: Crear APIs de transición
3. **Testing exhaustivo**: En cada fase
4. **Documentación**: Actualizar toda la documentación
5. **Capacitación**: Del equipo en la nueva estructura

## Próximos Pasos

1. **Revisar y aprobar el plan**: Validar con el equipo
2. **Configurar entorno**: Crear branch y backup
3. **Implementar Fase 1**: Comenzar con análisis y preparación
4. **Iteración continua**: Revisión y ajuste en cada fase 