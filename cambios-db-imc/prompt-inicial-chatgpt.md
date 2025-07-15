
# Prompt para ChatGPT 3o – Diseño de un buen prompt para utilizar con Cursor

Eres un experto especializado en Node.js, Prisma y diseño de bases de datos relacionales.

Estoy desarrollando una aplicación full-stack de gestión de talento (seguimiento de candidatos) con las siguientes características:

* Frontend: React (Create React App), componentes funcionales en JS/TS, React-Bootstrap para UI, fetch/axios para consumir la API.
* Backend: Node + Express escrito en TypeScript, arquitectura en capas (routes → controllers → services → domain models), Prisma ORM para acceder a una base de datos PostgreSQL.
* Infraestructura: Docker Compose levanta PostgreSQL; variables en .env; Jest para tests; construcción y hot-reload con ts-node-dev.

Necesito actualizar la base de datos con las nuevas entidades que nos permitan operar el flujo completo de aplicación para diversas posiciones. Me proporcionan un modelo ERD en formato Mermaid. Hay que convertir el ERD en formato mermaid a un script SQL. Para ello, hay que analizar la base de datos del código actual y el script SQL y expandir la estructura de datos usando las migraciones de Prisma.

Recuerda aplicar buenas practicas, como la definición de Indices y la normalización de la base datos, ya que el ERD proporcionado no cuenta con ello.

El modelo ERD se adjunta a continuación:

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
 

Con todas estas especificaciones, diseña un prompt completo para que pueda ser utilizado directamente en Cursor en modo agente, de forma que se puedan realizar todas las tareas, paso a paso, teniendo en cuenta los siguientes detalles:

* No hay que tocar el código fuente del proyecto, solo hay que actualizar la base de datos.
* Aparte del fichero scheme.prisma, no se debería tocar ningún fichero existente de los fuentes (salvo que sea extrictamente necesario para llevar a cabo la migración de la base de datos)
* Hay que crear un nuevo directorio llamado "cambios-db-imc" en el que se incluirán los siguientes documentos:
    ** una copia del nuevo scheme.prisma resultante, con los cambios aplicados.
    ** un documento en el que se indique de forma detallada todo lo que se hace en cada paso del proceso, de forma que después se pueda auditar cada decisión y cada acción realizada, formateado con markdown, que se llame "documentacion-migracion.rd".
    ** una copia del script sql generado para la migración, en un fichero que se llame "sentencias-migracion-desde-erd.sql".
    ** hay que diseñar y generar un fichero SQL que se llame "verificacion-migracion.sql" que contenga consultas al information_schema para verificar que la migración fue exitosa y que se han creado todas las tablas, indices, etc requeridos. 
* El agente debe explicar cada paso a realizar y pedir confirmación, además de ir documentando todo de forma detallada en el documento "documentacion-migracion.rd", cada decisión tomada, cada acción realizada,...

Genera el prompt en formato markdown en fichero descargable y explica el prompt diseñado. Si tienes alguna duda, pregunta antes.


---------------------------------------------------------------------------------------------------------------

# Respuesta del agente

He generado el prompt en un archivo descargable, listo para que lo pegues en Cursor y empieces a trabajar:

Descargar el prompt en Markdown

¿Qué incluye el prompt?
Objetivo y contexto claros de la migración para que el agente comprenda el alcance.

Lista de entregables y la estructura del nuevo directorio cambios-db-imc, para garantizar trazabilidad.

Flujo paso a paso con paradas de confirmación (👉 ¿Procedo…?) en cada punto crítico.

Directrices de buenas prácticas (atomicidad, reversibilidad, índices, normalización…).

Formato de interacción detallado para que el agente documente en tiempo real todo lo que hace en documentacion-migracion.rd.

Ejemplo de mensaje ilustrativo que sirve de referencia.

Límites explícitos para evitar cambios fuera de alcance.

El objetivo es que pegues este prompt en Cursor, ejecutes al agente y vayas respondiendo sí/no según confirme cada paso. De esa forma tendrás una migración reproducible, auditada y fácil de revisar.

Si quieres ajustar algún detalle o añadir requisitos extra, avísame antes de empezar. 