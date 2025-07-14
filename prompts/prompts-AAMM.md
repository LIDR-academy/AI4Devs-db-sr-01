## Usuario ##
Actúa como un experto en bases de datos relacionales y en el uso de Prisma ORM.
Tu tarea es actualizar la base de datos existente para permitir el flujo completo de aplicación para distintas posiciones laborales.
	1.	Toma el diagrama ERD en formato Mermaid que a continuacion te comparto y conviértelo en un script SQL funcional.

## Diagrama Mermaid 
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

	2.	Analiza tanto el código actual de la base de datos @schema.prisma como el script generado y amplía la estructura mediante migraciones de Prisma.
	3.	Asegúrate de aplicar buenas prácticas de diseño de base de datos, como:
	•	Normalización de datos.
	•	Definición adecuada de claves primarias y foráneas.
	•	Creación de índices para mejorar el rendimiento.

El ERD original puede carecer de estas buenas prácticas, así que deberás aplicar criterio técnico para mejorarlo durante la conversión.
Tu entrega final debe incluir el script SQL resultante, las migraciones de Prisma correspondientes y una breve justificación de las mejoras aplicadas.

no crees ni modifiques codigo aun, si tienes dudas primero aclaralas despues avanzaremos paso a paso

## Asistente ##
procede con 5 pregunts para aclarar dudas antes de continuar

## Usuario ##
1.- ¿Quieres mantener estos modelos existentes y solo agregar los nuevos, o prefieres una migración completa que reemplace la estructura actual? mantengamos los modelos actuales pero proporciona sugerencias de buenas paracticas que podemos aplicar para decidir si son necesarias las mejoras

2.-Para salary_min y salary_max: ¿Prefieres usar Decimal (para precisión monetaria) o Int (para valores enteros)? usemos decimal
Para score en entrevistas: ¿Qué rango de puntuación prefieres (ej: 1-10, 1-100, porcentaje)? usemes 1-100 para manejar porcentajes

3.- ¿Quieres agregar timestamps (createdAt, updatedAt) a todos los modelos? si para poder hacer auditorias
¿Necesitas soft delete (campo deletedAt) para alguna entidad? no
¿Quieres agregar campos de auditoría (quién creó/modificó cada registro)? si

4.- ¿Un candidato puede aplicar a múltiples posiciones de la misma empresa? si
¿Las entrevistas deben seguir un orden específico o pueden ser flexibles? pueden ser flexibles
¿Necesitas validar que las fechas de entrevista no se superpongan para un mismo empleado? si

5.- ¿Hay consultas específicas que se ejecutarán frecuentemente (ej: búsqueda de candidatos por empresa, filtrado por estado de aplicación)? si
¿Necesitas índices de texto completo para búsquedas en descripciones de trabajo? si

## Asistente ##
precenta las sugerencias de buenas prácticas que podemos aplicar para decidir si son necesarias las mejoras

## Usuario ##
procede en crear el .sql del ERD incluyendo las sugerencias, la migracion de prisma y la justificacion de las mejoras aplicadas

## Asistente ##
crea todos los archivos necesarios y justifica las mejoras aplicadas

## Usuario ##
ayudame a implementar estos cambios todos los archivos creados estan en @/prisma 
