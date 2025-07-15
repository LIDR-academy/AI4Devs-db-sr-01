Objetivo del Proyecto:

El objetivo es refactorizar y expandir la base de datos actual para permitir operar el flujo completo de aplicación a posiciones laborales. Esto implica traducir un ERD dado a SQL, mejorar el modelo de datos actual siguiendo buenas prácticas, y aplicar las migraciones correspondientes en un proyecto que utiliza Prisma ORM y PostgreSQL como motor de base de datos.

Contexto:

El sistema gestiona procesos de reclutamiento para empresas, permitiendo a candidatos aplicar a posiciones, realizar entrevistas, y a empresas gestionar sus flujos de entrevistas y empleados. Actualmente, el modelo de base de datos está incompleto y no normalizado adecuadamente. Se requiere:

Convertir el diagrama ERD en formato Mermaid proporcionado a un modelo SQL completo.

Expandir y refactorizar el archivo schema.prisma en backend/prisma.

Crear y aplicar una migración SQL correspondiente.

Asegurar la correcta definición de claves foráneas, tipos de datos, índices y relaciones.

Cumplir con buenas prácticas de diseño relacional (1NF, 2NF, 3NF).

Verificar el modelo con herramientas como PgAdmin, cargando datos de prueba y realizando queries básicas.

Tareas a realizar por la IA:

Interpretar el siguiente ERD (en formato Mermaid):

pgsql
Copiar
Editar
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
Requisitos Técnicos:

Traducir este ERD a:

Modelo en schema.prisma

Script SQL equivalente con creación de tablas, claves foráneas e índices

Añadir índices en columnas utilizadas frecuentemente en consultas (email, status, interview_date, etc.)

Aplicar normalización hasta 3NF

Utilizar nombres de tabla y campos en snake_case

Preferir tipos de datos PostgreSQL adecuados (TEXT, VARCHAR, NUMERIC, BOOLEAN, TIMESTAMP)

Agregar restricciones adecuadas (NOT NULL, UNIQUE, DEFAULT, etc.)

Resultado Esperado:

Archivo actualizado schema.prisma bajo backend/prisma/

Archivo de migración SQL generado y nombrado correctamente bajo backend/prisma/migrations

