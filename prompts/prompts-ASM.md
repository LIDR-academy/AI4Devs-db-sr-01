# prompts-ASM.md

## 🧠 Prompt inicial para el agente AI

Quiero que actúes como un **desarrollador backend experto en bases de datos relacionales y Prisma ORM**. Estás trabajando en un proyecto que necesita actualizar su base de datos PostgreSQL a partir de un nuevo modelo conceptual.

A partir del siguiente **ERD** (diagrama entidad-relación), debes:

1. Identificar las nuevas entidades que hay que crear.
2. Añadir sus definiciones en el archivo `schema.prisma`.
3. Asegurarte de que todas las relaciones están correctamente definidas y sean bidireccionales cuando sea necesario.
4. Aplicar una migración usando Prisma con un nombre descriptivo.
5. Verificar que la nueva estructura permite registrar candidatos correctamente a través del API y la interfaz web.

Este trabajo se realiza en el contexto del proyecto `LTI - Talent Tracking System`, que ya incluye modelos previos como `Candidate`, `Education`, `WorkExperience` y `Resume`.

---

## 🧩 Análisis del ERD

El nuevo ERD define las siguientes entidades y relaciones:

- `Company` tiene muchos `Position`.
- `Position` tiene muchas `Application`.
- `Application` pertenece a un `Candidate` y a un `Position`.
- `Interview` pertenece a una `Application` y está asignada a un `Employee`.
- `Employee` puede tener muchas `Interview`.

---

## 🛠️ Decisiones de modelado

- Se han creado 5 nuevos modelos: `Company`, `Position`, `Employee`, `Application` e `Interview`.
- Las claves foráneas y las relaciones están modeladas usando el sistema de relaciones explícitas de Prisma.
- Los nombres de los campos y entidades siguen el estilo del resto del proyecto (`camelCase`, `@db.VarChar`, etc).
- El campo `resume` se ha mantenido como estaba.
- Se han ejecutado las migraciones para reflejar los cambios en la base de datos real.

---

## 🔧 Fragmento final de schema.prisma añadido

```prisma
model Company {
  id        Int       @id @default(autoincrement())
  name      String    @db.VarChar(100)
  positions Position[]
}

model Position {
  id          Int          @id @default(autoincrement())
  title       String       @db.VarChar(100)
  companyId   Int
  company     Company      @relation(fields: [companyId], references: [id])
  applications Application[]
}

model Employee {
  id         Int         @id @default(autoincrement())
  name       String      @db.VarChar(100)
  email      String      @unique @db.VarChar(100)
  position   String      @db.VarChar(100)
  interviews Interview[]
}

model Application {
  id           Int          @id @default(autoincrement())
  candidateId  Int
  positionId   Int
  candidate    Candidate    @relation(fields: [candidateId], references: [id])
  position     Position     @relation(fields: [positionId], references: [id])
  interviews   Interview[]
}

model Interview {
  id            Int         @id @default(autoincrement())
  date          DateTime
  score         Int?
  applicationId Int
  employeeId    Int
  application   Application @relation(fields: [applicationId], references: [id])
  employee      Employee    @relation(fields: [employeeId], references: [id])
}
