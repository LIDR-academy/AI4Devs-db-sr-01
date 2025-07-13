# Base de Datos - AI4Devs

## Descripción

La base de datos de AI4Devs utiliza PostgreSQL como sistema de gestión de bases de datos relacionales, con Prisma como ORM (Object-Relational Mapping) para TypeScript. El esquema está diseñado para gestionar candidatos, su educación, experiencia laboral y archivos de CV.

## Tecnologías

- **PostgreSQL**: Sistema de gestión de bases de datos
- **Prisma**: ORM para TypeScript/Node.js
- **Docker**: Contenedorización de la base de datos

## Esquema de Base de Datos

### Modelo Principal: Candidate

```prisma
model Candidate {
  id                Int               @id @default(autoincrement())
  firstName         String            @db.VarChar(100)
  lastName          String            @db.VarChar(100)
  email             String            @unique @db.VarChar(255)
  phone             String?           @db.VarChar(15)
  address           String?           @db.VarChar(100)
  educations        Education[]
  workExperiences   WorkExperience[]
  resumes           Resume[]
}
```

#### Campos del Candidato
- **id**: Identificador único autoincremental
- **firstName**: Nombre del candidato (máximo 100 caracteres)
- **lastName**: Apellido del candidato (máximo 100 caracteres)
- **email**: Correo electrónico único (máximo 255 caracteres)
- **phone**: Número de teléfono opcional (máximo 15 caracteres)
- **address**: Dirección opcional (máximo 100 caracteres)

### Modelo: Education

```prisma
model Education {
  id            Int       @id @default(autoincrement())
  institution   String    @db.VarChar(100)
  title         String    @db.VarChar(250)
  startDate     DateTime
  endDate       DateTime?
  candidateId   Int
  candidate     Candidate @relation(fields: [candidateId], references: [id])
}
```

#### Campos de Educación
- **id**: Identificador único autoincremental
- **institution**: Nombre de la institución (máximo 100 caracteres)
- **title**: Título o grado obtenido (máximo 250 caracteres)
- **startDate**: Fecha de inicio (obligatoria)
- **endDate**: Fecha de finalización (opcional)
- **candidateId**: Referencia al candidato (clave foránea)

### Modelo: WorkExperience

```prisma
model WorkExperience {
  id          Int       @id @default(autoincrement())
  company     String    @db.VarChar(100)
  position    String    @db.VarChar(100)
  description String?   @db.VarChar(200)
  startDate   DateTime
  endDate     DateTime?
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
}
```

#### Campos de Experiencia Laboral
- **id**: Identificador único autoincremental
- **company**: Nombre de la empresa (máximo 100 caracteres)
- **position**: Cargo o puesto (máximo 100 caracteres)
- **description**: Descripción de responsabilidades (máximo 200 caracteres, opcional)
- **startDate**: Fecha de inicio (obligatoria)
- **endDate**: Fecha de finalización (opcional)
- **candidateId**: Referencia al candidato (clave foránea)

### Modelo: Resume

```prisma
model Resume {
  id          Int       @id @default(autoincrement())
  filePath    String    @db.VarChar(500)
  fileType    String    @db.VarChar(50)
  uploadDate  DateTime
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
}
```

#### Campos de CV
- **id**: Identificador único autoincremental
- **filePath**: Ruta del archivo (máximo 500 caracteres)
- **fileType**: Tipo de archivo (máximo 50 caracteres)
- **uploadDate**: Fecha de subida (obligatoria)
- **candidateId**: Referencia al candidato (clave foránea)

## Relaciones

### Relación 1:N (Candidate → Education)
- Un candidato puede tener múltiples registros de educación
- Cada educación pertenece a un solo candidato
- Clave foránea: `Education.candidateId` → `Candidate.id`

### Relación 1:N (Candidate → WorkExperience)
- Un candidato puede tener múltiples experiencias laborales
- Cada experiencia laboral pertenece a un solo candidato
- Clave foránea: `WorkExperience.candidateId` → `Candidate.id`

### Relación 1:N (Candidate → Resume)
- Un candidato puede tener múltiples archivos de CV
- Cada CV pertenece a un solo candidato
- Clave foránea: `Resume.candidateId` → `Candidate.id`

## Configuración de Prisma

### Generador de Cliente
```prisma
generator client {
  provider      = "prisma-client-js"
  binaryTargets = ["native", "debian-openssl-3.0.x"]
}
```

### Configuración de Datasource
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

## Migraciones

### Migración Inicial
La migración inicial crea todas las tablas con sus relaciones:

```sql
-- CreateTable
CREATE TABLE "Candidate" (
    "id" SERIAL NOT NULL,
    "firstName" VARCHAR(100) NOT NULL,
    "lastName" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(15),
    "address" VARCHAR(100),

    CONSTRAINT "Candidate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Education" (
    "id" SERIAL NOT NULL,
    "institution" VARCHAR(100) NOT NULL,
    "title" VARCHAR(250) NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "candidateId" INTEGER NOT NULL,

    CONSTRAINT "Education_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkExperience" (
    "id" SERIAL NOT NULL,
    "company" VARCHAR(100) NOT NULL,
    "position" VARCHAR(100) NOT NULL,
    "description" VARCHAR(200),
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "candidateId" INTEGER NOT NULL,

    CONSTRAINT "WorkExperience_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Resume" (
    "id" SERIAL NOT NULL,
    "filePath" VARCHAR(500) NOT NULL,
    "fileType" VARCHAR(50) NOT NULL,
    "uploadDate" TIMESTAMP(3) NOT NULL,
    "candidateId" INTEGER NOT NULL,

    CONSTRAINT "Resume_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Candidate_email_key" ON "Candidate"("email");

-- AddForeignKey
ALTER TABLE "Education" ADD CONSTRAINT "Education_candidateId_fkey" FOREIGN KEY ("candidateId") REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkExperience" ADD CONSTRAINT "WorkExperience_candidateId_fkey" FOREIGN KEY ("candidateId") REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Resume" ADD CONSTRAINT "Resume_candidateId_fkey" FOREIGN KEY ("candidateId") REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
```

## Configuración de Docker

### docker-compose.yml
```yaml
version: "3.1"

services:
  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - ${DB_PORT}:5432
```

### Variables de Entorno
```env
DB_PASSWORD=tu_password
DB_USER=tu_usuario
DB_NAME=tu_base_de_datos
DB_PORT=5432
DATABASE_URL="postgresql://tu_usuario:tu_password@localhost:5432/tu_base_de_datos"
```

## Comandos de Prisma

### Generar Cliente
```bash
npx prisma generate
```

### Ejecutar Migraciones
```bash
npx prisma migrate dev
```

### Ver Base de Datos
```bash
npx prisma studio
```

### Reset de Base de Datos
```bash
npx prisma migrate reset
```

### Deploy de Migraciones
```bash
npx prisma migrate deploy
```

## Consultas Típicas

### Obtener Candidato con Relaciones
```typescript
const candidate = await prisma.candidate.findUnique({
  where: { id: candidateId },
  include: {
    educations: true,
    workExperiences: true,
    resumes: true
  }
});
```

### Crear Candidato con Relaciones
```typescript
const candidate = await prisma.candidate.create({
  data: {
    firstName: "Juan",
    lastName: "Pérez",
    email: "juan@example.com",
    educations: {
      create: [
        {
          institution: "Universidad XYZ",
          title: "Ingeniero Informático",
          startDate: new Date("2018-09-01"),
          endDate: new Date("2022-06-30")
        }
      ]
    },
    workExperiences: {
      create: [
        {
          company: "Empresa ABC",
          position: "Desarrollador Full Stack",
          startDate: new Date("2022-07-01"),
          description: "Desarrollo de aplicaciones web"
        }
      ]
    }
  }
});
```

### Actualizar Candidato
```typescript
const updatedCandidate = await prisma.candidate.update({
  where: { id: candidateId },
  data: {
    firstName: "Juan Carlos",
    phone: "+1234567890"
  }
});
```

### Eliminar Candidato
```typescript
const deletedCandidate = await prisma.candidate.delete({
  where: { id: candidateId }
});
```

## Índices y Optimización

### Índices Automáticos
- **Primary Key**: `id` en todas las tablas
- **Unique Index**: `email` en tabla `Candidate`
- **Foreign Key Indexes**: Automáticos en PostgreSQL

### Índices Recomendados
```sql
-- Para búsquedas por nombre
CREATE INDEX idx_candidate_name ON "Candidate"("firstName", "lastName");

-- Para búsquedas por fecha en educación
CREATE INDEX idx_education_dates ON "Education"("startDate", "endDate");

-- Para búsquedas por fecha en experiencia laboral
CREATE INDEX idx_work_experience_dates ON "WorkExperience"("startDate", "endDate");
```

## Validaciones a Nivel de Base de Datos

### Constraints
- **NOT NULL**: Campos obligatorios
- **UNIQUE**: Email único por candidato
- **FOREIGN KEY**: Integridad referencial
- **CHECK**: Validaciones de formato (si se implementan)

### Triggers (Opcionales)
```sql
-- Trigger para validar formato de email
CREATE OR REPLACE FUNCTION validate_email()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
    RAISE EXCEPTION 'Invalid email format';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER email_validation
  BEFORE INSERT OR UPDATE ON "Candidate"
  FOR EACH ROW
  EXECUTE FUNCTION validate_email();
```

## Backup y Restauración

### Backup
```bash
pg_dump -h localhost -U tu_usuario -d tu_base_de_datos > backup.sql
```

### Restauración
```bash
psql -h localhost -U tu_usuario -d tu_base_de_datos < backup.sql
```

## Monitoreo y Performance

### Consultas de Monitoreo
```sql
-- Tamaño de las tablas
SELECT 
  schemaname,
  tablename,
  attname,
  n_distinct,
  correlation
FROM pg_stats 
WHERE tablename IN ('Candidate', 'Education', 'WorkExperience', 'Resume');

-- Estadísticas de uso
SELECT 
  schemaname,
  tablename,
  n_tup_ins,
  n_tup_upd,
  n_tup_del
FROM pg_stat_user_tables;
```

### Optimizaciones de Performance
- **Connection Pooling**: Configurado en Prisma
- **Query Optimization**: Uso de índices apropiados
- **Batch Operations**: Para operaciones masivas
- **Caching**: Implementar según necesidades

## Seguridad

### Configuraciones de Seguridad
- **SSL/TLS**: Conexiones encriptadas
- **User Permissions**: Permisos mínimos necesarios
- **Connection Limits**: Límites de conexiones concurrentes
- **Audit Logging**: Registro de operaciones críticas

### Variables de Entorno Seguras
```env
DATABASE_URL="postgresql://usuario:password@host:5432/database?sslmode=require"
```

## Escalabilidad

### Estrategias de Escalabilidad
- **Read Replicas**: Para consultas de solo lectura
- **Sharding**: Particionamiento por candidatos
- **Caching**: Redis para datos frecuentemente accedidos
- **CDN**: Para archivos de CV

### Consideraciones de Crecimiento
- **Archiving**: Mover datos antiguos a tablas de archivo
- **Partitioning**: Particionar por fecha o región
- **Compression**: Comprimir datos históricos 