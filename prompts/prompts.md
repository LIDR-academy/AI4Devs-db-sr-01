1.*primero opté por hacer un análisis del proyecto, generando documentación para mí y apoyarme en eso para cuando tuviera que refactorizar.*

** Estoy usando Cursor, modo agente y usando AUTO como LLM **

# Eres experto en base de datos relacionales, prisma, Nodejs y Express

# analiza los dos proyectos (/frontend y /backend) y genera documentación en formato markdown. Guarda en /Documentation

# por ahora, NO tengas en cuenta puntos de mejora o errores en la arquitectura del proyecto

# ten especial atención a @schema.prisma , porque vamos a refactorizar la BD.

2.*continúo en modo ask, y pasé a claude-4-sonnet que siempre me ha dado buenos resultados*

# eres un experto en bases de datos relacionales, SQL y Prisma

# voy a pasarte un diagrama en mermaid: vamos a refactorizar la BD. **de todas las tareas que siguen, quiero que generes un plan, no modifiques nada, sino que me cuentas qué vas a hacer haremos un plan para ir completand, dividido en pasos**
- vamos a mirar cómo está la BD (te apoyas en @/Documentation y @schema.prisma )
- vamos a utilizar el diagrama  que te pase como base, para ver las diferencias
- generarás los sql statements necesarios para llevar a la DB 

# Finalmente, utilizando las mejores prácticas de normalización de las DBs, vamos a tener un segundo plan para normalizar las DB.

# te paso el mermaid:
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

3. guarda todo en plan.md

4. 
ok: vamos con la fase 2 entonces.

# quiero que no se apliquen las migraciones usando Prisma, sino sólamente crear las sentencias sql para hacer la migracion.

5. Aplica esta migracion a la DB ahora.

6. apoyándo en el plan.md, sigue a la fase 3. Crea las migraciones y aplica en la dB

7. me gustaría que me generes un nuevo ERD en formato mermaid de cómo hemos dejado la DB
