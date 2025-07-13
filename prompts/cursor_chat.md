# Modificar esquema de base de datos
_Exported on 14/07/2025 at 1:33:24 CEST from Cursor (1.2.1)_

---

**User**

Actua como un Architecto de Sistemas y DBA experto en el diseño de sistemas escalables usando DDD, dado el siguiente esquema en @schema.prisma necesitamos modificarlo para adaptar la bbdd con el siguiente esquema mermaid

erDiagram
     COMPANY {
         int id PK
         string name
     }
     EMPLOYEE {
         int id PK
         int company_id FK
         string name
         string email
         string role
         boolean is_active
     }
     POSITION {
         int id PK
         int company_id FK
         int interview_flow_id FK
         string title
         text description
         string status
         boolean is_visible
         string location
         text job_description
         text requirements
         text responsibilities
         numeric salary_min
         numeric salary_max
         string employment_type
         text benefits
         text company_description
         date application_deadline
         string contact_info
     }
     INTERVIEW_FLOW {
         int id PK
         string description
     }
     INTERVIEW_STEP {
         int id PK
         int interview_flow_id FK
         int interview_type_id FK
         string name
         int order_index
     }
     INTERVIEW_TYPE {
         int id PK
         string name
         text description
     }
     CANDIDATE {
         int id PK
         string firstName
         string lastName
         string email
         string phone
         string address
     }
     APPLICATION {
         int id PK
         int position_id FK
         int candidate_id FK
         date application_date
         string status
         text notes
     }
     INTERVIEW {
         int id PK
         int application_id FK
         int interview_step_id FK
         int employee_id FK
         date interview_date
         string result
         int score
         text notes
     }

     COMPANY ||--o{ EMPLOYEE : employs
     COMPANY ||--o{ POSITION : offers
     POSITION ||--|| INTERVIEW_FLOW : assigns
     INTERVIEW_FLOW ||--o{ INTERVIEW_STEP : contains
     INTERVIEW_STEP ||--|| INTERVIEW_TYPE : uses
     POSITION ||--o{ APPLICATION : receives
     CANDIDATE ||--o{ APPLICATION : submits
     APPLICATION ||--o{ INTERVIEW : has
     INTERVIEW ||--|| INTERVIEW_STEP : consists_of
     EMPLOYEE ||--o{ INTERVIEW : conducts

ten en cuenta que es posible que existan duplicidades. Si tienes dudas, preguntame

---

**Cursor**

¡Perfecto! Como arquitecto de sistemas y DBA, te detallo cómo adaptar el archivo `schema.prisma` para reflejar el modelo relacional que describes en el diagrama Mermaid, siguiendo buenas prácticas de DDD y evitando duplicidades.

### Consideraciones previas

- **Evitar duplicidades:** Algunos modelos ya existen (por ejemplo, `Candidate`). Se deben ajustar o renombrar según el nuevo contexto.
- **Nombres:** Usaré nombres en inglés para consistencia con el estándar de Prisma y el código existente.
- **Relaciones:** Se implementarán las relaciones y claves foráneas según el diagrama.
- **Tipos:** Prisma usa `String`, `Int`, `Boolean`, `DateTime`, y para `numeric` se recomienda `Decimal`.
- **Textos largos:** Para campos tipo `text`, se puede usar `String` sin límite o, si el proveedor lo permite, especificar el tipo.

---

### Nuevo esquema propuesto para `schema.prisma`

#### 1. Nuevos modelos a agregar:
- Company
- Employee
- Position
- InterviewFlow
- InterviewStep
- InterviewType
- Application
- Interview

#### 2. Ajustes a modelos existentes:
- Candidate: Elimina relaciones que ya no correspondan (por ejemplo, `educations`, `workExperiences`, `resumes` si no se usan en el nuevo modelo).

---

¿Quieres que mantenga los modelos de educación, experiencia y CVs, o los elimino para centrarme solo en el nuevo dominio de reclutamiento?

¿Prefieres los nombres de los modelos y campos en inglés o español?

¿Quieres que los campos `text` sean `String` sin límite o que usemos algún tipo especial si el proveedor lo permite?

Por favor, responde estas tres preguntas para asegurarme de que el modelo final se ajuste exactamente a tus necesidades antes de proceder con la edición del archivo.

---

**User**

respondo a tus preguntas:

- hay que mantener los modelos ya definidos en el fichero @schema.prisma 
- todo en inglés
- decidelo tu basandote en el tipo de bbdd usado (en este caso postgreeSQL) y que los campos text deben recoger textos grandes


---

**Cursor**

¡Perfecto! Gracias por tus respuestas. Resumo las decisiones y el plan de acción:

---

### Decisiones

- **Se mantienen los modelos existentes** (`Candidate`, `Education`, `WorkExperience`, `Resume`).
- **Todo en inglés** (nombres de modelos y campos).
- **Campos `text`**: En PostgreSQL, para textos grandes, se usa `String` sin límite de longitud (Prisma lo mapea a `text` en PostgreSQL).

---

### Plan de acción

1. **Agregar los nuevos modelos**:  
   - `Company`
   - `Employee`
   - `Position`
   - `InterviewFlow`
   - `InterviewStep`
   - `InterviewType`
   - `Application`
   - `Interview`

2. **Definir relaciones y claves foráneas** según el diagrama Mermaid.

3. **Asegurar que los campos `text` sean `String` sin límite** (Prisma los mapea a `text` en PostgreSQL).

4. **No modificar ni eliminar los modelos existentes**.

---

### Siguiente paso

Voy a editar el archivo `schema.prisma` para agregar los nuevos modelos y relaciones, asegurando compatibilidad y consistencia con los modelos existentes.

¿Quieres que añada comentarios en el esquema para facilitar la comprensión de las relaciones, o prefieres el archivo limpio?

---

**User**

ok añade comentarios

---

**Cursor**

```plaintext
// ... existing code ...

// =========================
// Recruitment Domain Models
// =========================

/// Company entity. A company can employ many employees and offer many positions.
model Company {
  id        Int        @id @default(autoincrement())
  name      String     @db.VarChar(255)
  employees Employee[]
  positions Position[]
}

/// Employee entity. Belongs to a company and can conduct interviews.
model Employee {
  id         Int        @id @default(autoincrement())
  companyId  Int
  name       String     @db.VarChar(100)
  email      String     @db.VarChar(255)
  role       String     @db.VarChar(100)
  isActive   Boolean    @default(true)
  company    Company    @relation(fields: [companyId], references: [id])
  interviews Interview[]
}

/// Position entity. Offered by a company, linked to an interview flow, and receives applications.
model Position {
  id                  Int             @id @default(autoincrement())
  companyId           Int
  interviewFlowId     Int
  title               String          @db.VarChar(100)
  description         String          // text (large)
  status              String          @db.VarChar(50)
  isVisible           Boolean         @default(true)
  location            String          @db.VarChar(100)
  jobDescription      String          // text (large)
  requirements        String          // text (large)
  responsibilities    String          // text (large)
  salaryMin           Decimal?
  salaryMax           Decimal?
  employmentType      String          @db.VarChar(50)
  benefits            String          // text (large)
  companyDescription  String          // text (large)
  applicationDeadline DateTime?
  contactInfo         String          @db.VarChar(255)
  company             Company         @relation(fields: [companyId], references: [id])
  interviewFlow       InterviewFlow   @relation(fields: [interviewFlowId], references: [id])
  applications        Application[]
}

/// InterviewFlow entity. Defines the flow of interviews for a position.
model InterviewFlow {
  id           Int             @id @default(autoincrement())
  description  String          // text (large)
  positions    Position[]
  steps        InterviewStep[]
}

/// InterviewStep entity. Part of an interview flow, uses an interview type.
model InterviewStep {
  id               Int             @id @default(autoincrement())
  interviewFlowId  Int
  interviewTypeId  Int
  name             String          @db.VarChar(100)
  orderIndex       Int
  interviewFlow    InterviewFlow   @relation(fields: [interviewFlowId], references: [id])
  interviewType    InterviewType   @relation(fields: [interviewTypeId], references: [id])
  interviews       Interview[]
}

/// InterviewType entity. Defines the type of an interview step.
model InterviewType {
  id          Int             @id @default(autoincrement())
  name        String          @db.VarChar(100)
  description String          // text (large)
  steps       InterviewStep[]
}

/// Application entity. Links a candidate to a position.
model Application {
  id               Int           @id @default(autoincrement())
  positionId       Int
  candidateId      Int
  applicationDate  DateTime
  status           String        @db.VarChar(50)
  notes            String        // text (large)
  position         Position      @relation(fields: [positionId], references: [id])
  candidate        Candidate     @relation(fields: [candidateId], references: [id])
  interviews       Interview[]
}

/// Interview entity. Represents an interview for an application and step, conducted by an employee.
model Interview {
  id               Int             @id @default(autoincrement())
  applicationId    Int
  interviewStepId  Int
  employeeId       Int
  interviewDate    DateTime
  result           String          @db.VarChar(50)
  score            Int?
  notes            String          // text (large)
  application      Application     @relation(fields: [applicationId], references: [id])
  interviewStep    InterviewStep   @relation(fields: [interviewStepId], references: [id])
  employee         Employee        @relation(fields: [employeeId], references: [id])
}

```

Listo. He añadido los nuevos modelos al final de tu archivo `schema.prisma`, siguiendo el diagrama Mermaid y las mejores prácticas para PostgreSQL y Prisma. Cada modelo incluye comentarios explicativos sobre su función y relaciones, y los campos de tipo `text` están definidos como `String` sin límite, lo que Prisma mapea a `text` en PostgreSQL.

Puedes revisar y, si todo está correcto, ejecutar la migración con Prisma para actualizar la base de datos:

```bash
npx prisma migrate dev --name add-recruitment-domain
```

¿Te gustaría que te ayude con la generación de la migración o con algún ejemplo de consulta o relación entre estos modelos?

```shellscript
npx prisma migrate dev --name add-recruitment-domain
```

---

**User**

valida el esquema propuesto ya que esta dando error

---

**Cursor**

El comando no está mostrando errores específicos del esquema, sino una advertencia de incompatibilidad de versión de Node.js para Prisma:

- **Prisma requiere Node >=18.18**
- **Tu versión actual es v18.15.0**

Esto puede estar impidiendo que Prisma valide correctamente el archivo y muestre los errores reales del esquema.

### Pasos recomendados

1. **Actualiza Node.js** a una versión igual o superior a 18.18.
2. Vuelve a ejecutar `npx prisma validate` para ver los errores reales del esquema.

¿Quieres que te guíe para actualizar Node.js o prefieres que revise el archivo `schema.prisma` en busca de posibles errores comunes de forma manual?

---

**User**

toms como carpeta base @/backend para validar el esquema @schema.prisma y ejecutar comandos en el terminal

---

**Cursor**

El error principal es:

> Error validating field `candidate` in model `Application`: The relation field `candidate` on model `Application` is missing an opposite relation field on the model `Candidate`.

Esto significa que en el modelo `Application` tienes la relación:

```prisma
candidate Candidate @relation(fields: [candidateId], references: [id])
```

Pero en el modelo `Candidate` no existe el campo inverso (por ejemplo, `applications Application[]`).

---

### Solución

Debes agregar en el modelo `Candidate` la relación inversa, así:

```prisma
model Candidate {
  // ...otros campos...
  applications Application[]
  // ...otros campos...
}
```

Esto permitirá que Prisma entienda la relación bidireccional entre `Candidate` y `Application`.

---

¿Quieres que realice este ajuste automáticamente en tu archivo `schema.prisma`?

```plaintext
candidate Candidate @relation(fields: [candidateId], references: [id])
```

```plaintext
model Candidate {
  // ...otros campos...
  applications Application[]
  // ...otros campos...
}
```

---

**User**

ahora ejecutemos el esquema para probarlo

---

**Cursor**

El error actual es:

> Environment variable not found: DATABASE_URL.

Esto significa que falta la variable de entorno `DATABASE_URL`, que Prisma necesita para conectarse a tu base de datos PostgreSQL.

---

### Solución

1. Crea un archivo `.env` en la carpeta `backend` (si no existe).
2. Añade la línea:
   ```
   DATABASE_URL="postgresql://usuario:contraseña@host:puerto/nombre_db"
   ```
   Sustituye `usuario`, `contraseña`, `host`, `puerto` y `nombre_db` por los valores reales de tu base de datos.

¿Quieres que te ayude a crear el archivo `.env` o ya tienes la cadena de conexión lista? Si quieres, dime los datos (puedes poner datos ficticios si es solo para pruebas).

```plaintext
   DATABASE_URL="postgresql://usuario:contraseña@host:puerto/nombre_db"
```

---

**User**

toma como carpeta base la carpeta del proyecto @/AI4Devs-db-sr-01 para ejecutar comandos en el terminal

---

**Cursor**

¡Entendido! A partir de ahora, tomaré como carpeta base la raíz del proyecto (`/AI4Devs-db-sr-01`) para ejecutar los comandos en el terminal.

Para continuar, ¿quieres que cree el archivo `.env` con una cadena de conexión de ejemplo para PostgreSQL, o ya tienes una cadena real que deseas usar? Si tienes la cadena, por favor indícamela (puedes ocultar la contraseña si lo prefieres). 

Si prefieres que use una de ejemplo, avísame y la creo para que puedas probar la migración.

---

**User**

ahora entonces intenta probar este esquema

---

**Cursor**

¡Éxito! El esquema Prisma se ha validado y migrado correctamente. La base de datos está en sincronía con el nuevo modelo, y el cliente Prisma se ha generado sin errores.

Ya puedes comenzar a trabajar con los nuevos modelos y relaciones desde tu backend.  
¿Te gustaría que te ayude con ejemplos de consultas, seeds, o integración con el backend? ¿O necesitas alguna validación adicional sobre el modelo?

---

**User**

ahora necesito que revises el esquema de bbdd analizando si se necesitaran indices o se pudiera normalizar el esquema

---

**Cursor**

¡Perfecto! Aquí tienes un análisis profesional sobre índices y normalización para tu esquema, siguiendo buenas prácticas de bases de datos relacionales y DDD:

---

## 1. Índices

**Prisma** crea automáticamente índices para todas las claves primarias (`@id`) y únicas (`@unique`). Sin embargo, para optimizar consultas frecuentes, especialmente en relaciones y búsquedas, es recomendable añadir índices adicionales en los siguientes casos:

### a) Claves foráneas
Agregar índices explícitos en campos que son claves foráneas mejora el rendimiento de joins y búsquedas por relación.

**Recomendación:**  
Añadir `@@index([campo])` en los siguientes modelos/campos:

- `Employee.companyId`
- `Position.companyId`
- `Position.interviewFlowId`
- `InterviewStep.interviewFlowId`
- `InterviewStep.interviewTypeId`
- `Application.positionId`
- `Application.candidateId`
- `Interview.applicationId`
- `Interview.interviewStepId`
- `Interview.employeeId`

### b) Búsquedas frecuentes
Si vas a buscar mucho por email (por ejemplo, en `Candidate` o `Employee`), ya tienes `@unique` en `Candidate.email`, pero podrías considerar lo mismo en `Employee.email` si no lo tienes.

---

## 2. Normalización

Tu esquema está **altamente normalizado** y sigue buenas prácticas de modelado relacional:

- No hay datos redundantes.
- Las relaciones están bien definidas.
- Los textos largos están en campos separados.
- No hay campos multivaluados ni listas de valores en un solo campo.

**No se requiere mayor normalización**. El modelo es flexible y escalable.

---

## 3. Sugerencias adicionales

- Si tienes consultas que filtran por varios campos a la vez (por ejemplo, `positionId` y `candidateId` en `Application`), podrías considerar índices compuestos:  
  `@@index([positionId, candidateId])`
- Si tienes búsquedas por fechas (por ejemplo, `applicationDate`), podrías añadir índices en esos campos si el volumen de datos es alto.

---

## 4. Ejemplo de cómo añadir índices en Prisma

```prisma
model Application {
  id               Int           @id @default(autoincrement())
  positionId       Int
  candidateId      Int
  applicationDate  DateTime
  status           String        @db.VarChar(50)
  notes            String
  position         Position      @relation(fields: [positionId], references: [id])
  candidate        Candidate     @relation(fields: [candidateId], references: [id])
  interviews       Interview[]

  @@index([positionId])
  @@index([candidateId])
  // @@index([positionId, candidateId]) // Si consultas mucho por ambos
}
```

---

¿Quieres que aplique estos índices recomendados directamente en tu archivo `schema.prisma`? ¿O prefieres que te indique solo en qué modelos/campos hacerlo para que lo revises tú?

```plaintext
model Application {
  id               Int           @id @default(autoincrement())
  positionId       Int
  candidateId      Int
  applicationDate  DateTime
  status           String        @db.VarChar(50)
  notes            String
  position         Position      @relation(fields: [positionId], references: [id])
  candidate        Candidate     @relation(fields: [candidateId], references: [id])
  interviews       Interview[]

  @@index([positionId])
  @@index([candidateId])
  // @@index([positionId, candidateId]) // Si consultas mucho por ambos
}
```

---

**User**

aplica el punto 1 completo nada más

---

**Cursor**

```plaintext
// ... existing code ...
model Employee {
  id         Int        @id @default(autoincrement())
  companyId  Int
  name       String     @db.VarChar(100)
  email      String     @db.VarChar(255)
  role       String     @db.VarChar(100)
  isActive   Boolean    @default(true)
  company    Company    @relation(fields: [companyId], references: [id])
  interviews Interview[]

  @@index([companyId])
}
// ... existing code ...
model Position {
  id                  Int             @id @default(autoincrement())
  companyId           Int
  interviewFlowId     Int
  title               String          @db.VarChar(100)
  description         String          // text (large)
  status              String          @db.VarChar(50)
  isVisible           Boolean         @default(true)
  location            String          @db.VarChar(100)
  jobDescription      String          // text (large)
  requirements        String          // text (large)
  responsibilities    String          // text (large)
  salaryMin           Decimal?
  salaryMax           Decimal?
  employmentType      String          @db.VarChar(50)
  benefits            String          // text (large)
  companyDescription  String          // text (large)
  applicationDeadline DateTime?
  contactInfo         String          @db.VarChar(255)
  company             Company         @relation(fields: [companyId], references: [id])
  interviewFlow       InterviewFlow   @relation(fields: [interviewFlowId], references: [id])
  applications        Application[]

  @@index([companyId])
  @@index([interviewFlowId])
}
// ... existing code ...
model InterviewStep {
  id               Int             @id @default(autoincrement())
  interviewFlowId  Int
  interviewTypeId  Int
  name             String          @db.VarChar(100)
  orderIndex       Int
  interviewFlow    InterviewFlow   @relation(fields: [interviewFlowId], references: [id])
  interviewType    InterviewType   @relation(fields: [interviewTypeId], references: [id])
  interviews       Interview[]

  @@index([interviewFlowId])
  @@index([interviewTypeId])
}
// ... existing code ...
model Application {
  id               Int           @id @default(autoincrement())
  positionId       Int
  candidateId      Int
  applicationDate  DateTime
  status           String        @db.VarChar(50)
  notes            String        // text (large)
  position         Position      @relation(fields: [positionId], references: [id])
  candidate        Candidate     @relation(fields: [candidateId], references: [id])
  interviews       Interview[]

  @@index([positionId])
  @@index([candidateId])
}
// ... existing code ...
model Interview {
  id               Int             @id @default(autoincrement())
  applicationId    Int
  interviewStepId  Int
  employeeId       Int
  interviewDate    DateTime
  result           String          @db.VarChar(50)
  score            Int?
  notes            String          // text (large)
  application      Application     @relation(fields: [applicationId], references: [id])
  interviewStep    InterviewStep   @relation(fields: [interviewStepId], references: [id])
  employee         Employee        @relation(fields: [employeeId], references: [id])

  @@index([applicationId])
  @@index([interviewStepId])
  @@index([employeeId])
}
// ... existing code ...
```

Listo. He añadido índices (`@@index`) en todos los campos que son claves foráneas en los modelos Employee, Position, InterviewStep, Application e Interview, optimizando así el rendimiento de las relaciones y búsquedas frecuentes.

Puedes aplicar estos cambios en la base de datos ejecutando:

```bash
npx --prefix backend prisma migrate dev --name add-foreign-keys-indexes
```

¿Te gustaría que ejecute la migración por ti o necesitas alguna otra optimización?

```shellscript
npx --prefix backend prisma migrate dev --name add-foreign-keys-indexes
```

---

**User**

ahora genera algunas consultas como:

- posiciones abiertas de un candidato
- posiciones con salario minimo de 30k y nombre de la compañia

---

**Cursor**

¡Por supuesto! Aquí tienes ejemplos de consultas Prisma para los casos que mencionas:

---

### 1. Posiciones abiertas de un candidato

**Suposición:**  
- “Abiertas” significa que el campo `status` de la posición es, por ejemplo, `"open"`.
- Se buscan las posiciones a las que el candidato ha aplicado.

```typescript
// Obtener posiciones abiertas a las que un candidato ha aplicado
const candidateId = 1; // ID del candidato

const openPositions = await prisma.position.findMany({
  where: {
    status: "open",
    applications: {
      some: {
        candidateId: candidateId
      }
    }
  }
});
```

---

### 2. Posiciones con salario mínimo de 30k y nombre de la compañía

```typescript
// Obtener posiciones con salario mínimo >= 30000 e incluir el nombre de la compañía
const positions = await prisma.position.findMany({
  where: {
    salaryMin: {
      gte: 30000
    }
  },
  include: {
    company: {
      select: {
        name: true
      }
    }
  }
});
```

---

¿Te gustaría que te ayude a integrarlas en un servicio o controlador, o necesitas ejemplos de la respuesta que devuelve Prisma?

```typescript
// Obtener posiciones abiertas a las que un candidato ha aplicado
const candidateId = 1; // ID del candidato

const openPositions = await prisma.position.findMany({
  where: {
    status: "open",
    applications: {
      some: {
        candidateId: candidateId
      }
    }
  }
});
```

```typescript
// Obtener posiciones con salario mínimo >= 30000 e incluir el nombre de la compañía
const positions = await prisma.position.findMany({
  where: {
    salaryMin: {
      gte: 30000
    }
  },
  include: {
    company: {
      select: {
        name: true
      }
    }
  }
});
```

---

**User**

necesito que las generes para ejecutarlas en SQL 

---

**Cursor**

¡Por supuesto! Aquí tienes las consultas SQL equivalentes para PostgreSQL, basadas en tu modelo:

---

### 1. Posiciones abiertas de un candidato

**Descripción:**  
Devuelve todas las posiciones con `status = 'open'` a las que un candidato (por su `candidate_id`) ha aplicado.

```sql
SELECT p.*
FROM "Position" p
JOIN "Application" a ON a."positionId" = p.id
WHERE a."candidateId" = $1
  AND p.status = 'open';
```
> Reemplaza `$1` por el ID del candidato que te interese.

---

### 2. Posiciones con salario mínimo de 30k y nombre de la compañía

**Descripción:**  
Devuelve todas las posiciones cuyo salario mínimo es mayor o igual a 30,000, junto con el nombre de la compañía.

```sql
SELECT p.*, c.name AS company_name
FROM "Position" p
JOIN "Company" c ON p."companyId" = c.id
WHERE p."salaryMin" >= 30000;
```

---

¿Necesitas que adapte alguna consulta para otros filtros, o que te ayude a probarlas directamente en tu base de datos?

```sql
SELECT p.*
FROM "Position" p
JOIN "Application" a ON a."positionId" = p.id
WHERE a."candidateId" = $1
  AND p.status = 'open';
```

```sql
SELECT p.*, c.name AS company_name
FROM "Position" p
JOIN "Company" c ON p."companyId" = c.id
WHERE p."salaryMin" >= 30000;
```

---

**User**

ahora genera datos aleatorios en la bbdd para poder probar todo el esquema de datos

---

**Cursor**

¡Perfecto! Aquí tienes un script SQL para poblar tu base de datos con datos aleatorios y coherentes para todos los modelos principales del esquema. Así podrás probar relaciones y consultas.

---

### Script SQL de ejemplo para poblar la base de datos

```sql
-- Insertar compañías
INSERT INTO "Company" (name) VALUES
  ('Tech Solutions'),
  ('InnovateX'),
  ('GlobalSoft');

-- Insertar empleados
INSERT INTO "Employee" (companyId, name, email, role, "isActive") VALUES
  (1, 'Alice Smith', 'alice@techsolutions.com', 'HR', true),
  (1, 'Bob Johnson', 'bob@techsolutions.com', 'Interviewer', true),
  (2, 'Carol White', 'carol@innovatex.com', 'HR', true);

-- Insertar tipos de entrevista
INSERT INTO "InterviewType" (name, description) VALUES
  ('Phone Screen', 'Initial phone screening'),
  ('Technical', 'Technical interview'),
  ('HR', 'HR interview');

-- Insertar flujos de entrevista
INSERT INTO "InterviewFlow" (description) VALUES
  ('Standard Developer Flow'),
  ('Manager Flow');

-- Insertar pasos de entrevista
INSERT INTO "InterviewStep" (interviewFlowId, interviewTypeId, name, "orderIndex") VALUES
  (1, 1, 'Phone Screen', 1),
  (1, 2, 'Technical Interview', 2),
  (1, 3, 'HR Interview', 3),
  (2, 1, 'Phone Screen', 1),
  (2, 3, 'HR Interview', 2);

-- Insertar posiciones
INSERT INTO "Position" (
  "companyId", "interviewFlowId", title, description, status, "isVisible", location,
  "jobDescription", requirements, responsibilities, "salaryMin", "salaryMax",
  "employmentType", benefits, "companyDescription", "applicationDeadline", "contactInfo"
) VALUES
  (1, 1, 'Backend Developer', 'Desarrollador backend', 'open', true, 'Madrid',
   'Node.js, PostgreSQL', 'Experiencia en Node.js', 'Desarrollar APIs', 32000, 40000,
   'Full-time', 'Seguro médico', 'Empresa tecnológica', '2024-12-31', 'hr@techsolutions.com'),
  (2, 2, 'Project Manager', 'Gestor de proyectos', 'open', true, 'Barcelona',
   'Gestión de equipos', 'Experiencia en gestión', 'Liderar proyectos', 35000, 50000,
   'Full-time', 'Ticket restaurante', 'Empresa innovadora', '2024-11-30', 'hr@innovatex.com');

-- Insertar candidatos
INSERT INTO "Candidate" (firstName, lastName, email, phone, address) VALUES
  ('David', 'Martínez', 'david.martinez@email.com', '600123456', 'Calle Falsa 123'),
  ('Elena', 'García', 'elena.garcia@email.com', '600654321', 'Avenida Real 456');

-- Insertar aplicaciones
INSERT INTO "Application" (positionId, candidateId, "applicationDate", status, notes) VALUES
  (1, 1, '2024-07-13', 'pending', 'Interesado en la posición'),
  (2, 2, '2024-07-12', 'pending', 'Buena experiencia previa');

-- Insertar entrevistas
INSERT INTO "Interview" (applicationId, interviewStepId, employeeId, "interviewDate", result, score, notes) VALUES
  (1, 1, 2, '2024-07-14', 'passed', 8, 'Buen desempeño en phone screen'),
  (1, 2, 2, '2024-07-15', 'pending', NULL, ''),
  (2, 4, 3, '2024-07-13', 'passed', 7, 'Correcto en phone screen');

-- Insertar educación y experiencia laboral para los candidatos (opcional)
INSERT INTO "Education" (institution, title, "startDate", "endDate", candidateId) VALUES
  ('Universidad Complutense', 'Ingeniería Informática', '2015-09-01', '2019-06-30', 1),
  ('UPM', 'Máster en Gestión', '2018-09-01', '2020-06-30', 2);

INSERT INTO "WorkExperience" (company, position, description, "startDate", "endDate", candidateId) VALUES
  ('Empresa A', 'Desarrollador', 'Backend developer', '2019-07-01', '2022-06-30', 1),
  ('Empresa B', 'Gestora', 'Project manager', '2020-07-01', NULL, 2);

-- Insertar CVs (resumes)
INSERT INTO "Resume" (filePath, fileType, "uploadDate", candidateId) VALUES
  ('/resumes/david.pdf', 'pdf', '2024-07-10', 1),
  ('/resumes/elena.pdf', 'pdf', '2024-07-11', 2);
```

---

¿Quieres que te ayude a ejecutar este script directamente en tu base de datos PostgreSQL, o prefieres que te explique cómo hacerlo? Si necesitas más datos o variaciones, ¡dímelo!

```sql
-- Insertar compañías
INSERT INTO "Company" (name) VALUES
  ('Tech Solutions'),
  ('InnovateX'),
  ('GlobalSoft');

-- Insertar empleados
INSERT INTO "Employee" (companyId, name, email, role, "isActive") VALUES
  (1, 'Alice Smith', 'alice@techsolutions.com', 'HR', true),
  (1, 'Bob Johnson', 'bob@techsolutions.com', 'Interviewer', true),
  (2, 'Carol White', 'carol@innovatex.com', 'HR', true);

-- Insertar tipos de entrevista
INSERT INTO "InterviewType" (name, description) VALUES
  ('Phone Screen', 'Initial phone screening'),
  ('Technical', 'Technical interview'),
  ('HR', 'HR interview');

-- Insertar flujos de entrevista
INSERT INTO "InterviewFlow" (description) VALUES
  ('Standard Developer Flow'),
  ('Manager Flow');

-- Insertar pasos de entrevista
INSERT INTO "InterviewStep" (interviewFlowId, interviewTypeId, name, "orderIndex") VALUES
  (1, 1, 'Phone Screen', 1),
  (1, 2, 'Technical Interview', 2),
  (1, 3, 'HR Interview', 3),
  (2, 1, 'Phone Screen', 1),
  (2, 3, 'HR Interview', 2);

-- Insertar posiciones
INSERT INTO "Position" (
  "companyId", "interviewFlowId", title, description, status, "isVisible", location,
  "jobDescription", requirements, responsibilities, "salaryMin", "salaryMax",
  "employmentType", benefits, "companyDescription", "applicationDeadline", "contactInfo"
) VALUES
  (1, 1, 'Backend Developer', 'Desarrollador backend', 'open', true, 'Madrid',
   'Node.js, PostgreSQL', 'Experiencia en Node.js', 'Desarrollar APIs', 32000, 40000,
   'Full-time', 'Seguro médico', 'Empresa tecnológica', '2024-12-31', 'hr@techsolutions.com'),
  (2, 2, 'Project Manager', 'Gestor de proyectos', 'open', true, 'Barcelona',
   'Gestión de equipos', 'Experiencia en gestión', 'Liderar proyectos', 35000, 50000,
   'Full-time', 'Ticket restaurante', 'Empresa innovadora', '2024-11-30', 'hr@innovatex.com');

-- Insertar candidatos
INSERT INTO "Candidate" (firstName, lastName, email, phone, address) VALUES
  ('David', 'Martínez', 'david.martinez@email.com', '600123456', 'Calle Falsa 123'),
  ('Elena', 'García', 'elena.garcia@email.com', '600654321', 'Avenida Real 456');

-- Insertar aplicaciones
INSERT INTO "Application" (positionId, candidateId, "applicationDate", status, notes) VALUES
  (1, 1, '2024-07-13', 'pending', 'Interesado en la posición'),
  (2, 2, '2024-07-12', 'pending', 'Buena experiencia previa');

-- Insertar entrevistas
INSERT INTO "Interview" (applicationId, interviewStepId, employeeId, "interviewDate", result, score, notes) VALUES
  (1, 1, 2, '2024-07-14', 'passed', 8, 'Buen desempeño en phone screen'),
  (1, 2, 2, '2024-07-15', 'pending', NULL, ''),
  (2, 4, 3, '2024-07-13', 'passed', 7, 'Correcto en phone screen');

-- Insertar educación y experiencia laboral para los candidatos (opcional)
INSERT INTO "Education" (institution, title, "startDate", "endDate", candidateId) VALUES
  ('Universidad Complutense', 'Ingeniería Informática', '2015-09-01', '2019-06-30', 1),
  ('UPM', 'Máster en Gestión', '2018-09-01', '2020-06-30', 2);

INSERT INTO "WorkExperience" (company, position, description, "startDate", "endDate", candidateId) VALUES
  ('Empresa A', 'Desarrollador', 'Backend developer', '2019-07-01', '2022-06-30', 1),
  ('Empresa B', 'Gestora', 'Project manager', '2020-07-01', NULL, 2);

-- Insertar CVs (resumes)
INSERT INTO "Resume" (filePath, fileType, "uploadDate", candidateId) VALUES
  ('/resumes/david.pdf', 'pdf', '2024-07-10', 1),
  ('/resumes/elena.pdf', 'pdf', '2024-07-11', 2);
```

