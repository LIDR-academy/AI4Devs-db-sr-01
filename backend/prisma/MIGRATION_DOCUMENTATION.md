# Documentación de Migración del ERD - Sistema de Aplicaciones Laborales

## Resumen

Este documento describe la implementación completa del diagrama ERD para el sistema de aplicaciones laborales, incluyendo todos los modelos, relaciones, índices y funcionalidades.

## Estructura del Proyecto

```
backend/prisma/
├── schema.prisma              # Esquema de Prisma con todos los modelos
├── erd_migration.sql          # Script SQL principal de migración
├── verify_migration.sql       # Script de verificación
├── MIGRATION_DOCUMENTATION.md # Este archivo
└── migrations/                # Migraciones de Prisma
    └── migration_lock.toml
```

## Modelos Implementados

### Modelos Existentes (Sin Modificaciones)
- **Candidate**: Candidatos del sistema
- **Education**: Educación de los candidatos
- **WorkExperience**: Experiencia laboral de los candidatos
- **Resume**: CVs de los candidatos

### Nuevos Modelos del Sistema de Aplicaciones

#### 1. Company
- **Propósito**: Gestión de empresas que publican posiciones
- **Campos principales**: `id`, `name`, `createdAt`, `updatedAt`, `createdBy`, `updatedBy`
- **Relaciones**: Uno-a-muchos con `Employee` y `Position`

#### 2. Employee
- **Propósito**: Empleados que pueden conducir entrevistas
- **Campos principales**: `id`, `companyId`, `name`, `email`, `role`, `isActive`
- **Relaciones**: Muchos-a-uno con `Company`, uno-a-muchos con `Interview`

#### 3. InterviewFlow
- **Propósito**: Flujos de entrevista configurables
- **Campos principales**: `id`, `description`
- **Relaciones**: Uno-a-muchos con `Position` y `InterviewStep`

#### 4. InterviewType
- **Propósito**: Tipos de entrevista disponibles
- **Campos principales**: `id`, `name`, `description`
- **Relaciones**: Uno-a-muchos con `InterviewStep`

#### 5. Position
- **Propósito**: Posiciones laborales con información completa
- **Campos principales**: `title`, `description`, `status`, `location`, `salaryMin`, `salaryMax`, `employmentType`
- **Relaciones**: Muchos-a-uno con `Company` y `InterviewFlow`, uno-a-muchos con `Application`

#### 6. InterviewStep
- **Propósito**: Pasos específicos dentro de un flujo de entrevista
- **Campos principales**: `interviewFlowId`, `interviewTypeId`, `name`, `orderIndex`
- **Relaciones**: Muchos-a-uno con `InterviewFlow` y `InterviewType`, uno-a-muchos con `Interview`

#### 7. Application
- **Propósito**: Aplicaciones de candidatos a posiciones
- **Campos principales**: `positionId`, `candidateId`, `applicationDate`, `status`, `notes`
- **Relaciones**: Muchos-a-uno con `Position` y `Candidate`, uno-a-muchos con `Interview`

#### 8. Interview
- **Propósito**: Entrevistas específicas con resultados
- **Campos principales**: `applicationId`, `interviewStepId`, `employeeId`, `interviewDate`, `result`, `score`
- **Relaciones**: Muchos-a-uno con `Application`, `InterviewStep` y `Employee`

## Enums Implementados

### PositionStatus
- `DRAFT`: Borrador de posición
- `ACTIVE`: Posición activa y visible
- `PAUSED`: Posición pausada temporalmente
- `CLOSED`: Posición cerrada

### EmploymentType
- `FULL_TIME`: Tiempo completo
- `PART_TIME`: Tiempo parcial
- `CONTRACT`: Contrato
- `INTERNSHIP`: Pasantía

### ApplicationStatus
- `APPLIED`: Aplicación enviada
- `REVIEWING`: En revisión
- `INTERVIEWING`: En proceso de entrevistas
- `OFFERED`: Oferta extendida
- `HIRED`: Contratado
- `REJECTED`: Rechazado
- `WITHDRAWN`: Retirado por el candidato

### InterviewResult
- `PENDING`: Pendiente
- `PASSED`: Aprobado
- `FAILED`: No aprobado
- `CANCELLED`: Cancelado

## Optimizaciones de Performance

### Índices Básicos
- `idx_employee_company`: Búsqueda de empleados por empresa
- `idx_employee_email`: Búsqueda por email de empleado
- `idx_position_company`: Búsqueda de posiciones por empresa
- `idx_position_status`: Filtrado por estado de posición
- `idx_position_visible`: Filtrado por visibilidad
- `idx_application_position`: Búsqueda de aplicaciones por posición
- `idx_application_candidate`: Búsqueda de aplicaciones por candidato
- `idx_application_status`: Filtrado por estado de aplicación
- `idx_interview_application`: Búsqueda de entrevistas por aplicación
- `idx_interview_employee`: Búsqueda de entrevistas por empleado
- `idx_interview_date`: Filtrado por fecha de entrevista
- `idx_interview_step_flow`: Búsqueda de pasos por flujo

### Índices de Texto Completo (GIN)
- `idx_position_title_gin`: Búsqueda en títulos de posiciones
- `idx_position_description_gin`: Búsqueda en descripciones
- `idx_position_job_description_gin`: Búsqueda en descripción del trabajo
- `idx_position_requirements_gin`: Búsqueda en requisitos

## Funcionalidades Avanzadas

### Triggers de Auditoría
- **Función**: `update_updated_at_column()`
- **Propósito**: Actualiza automáticamente el campo `updatedAt` en todas las tablas
- **Aplicación**: Se ejecuta antes de cada UPDATE en todas las tablas

### Validación de Superposición de Entrevistas
- **Función**: `check_interview_overlap()`
- **Propósito**: Evita que un empleado tenga múltiples entrevistas en la misma fecha/hora
- **Aplicación**: Se ejecuta antes de INSERT o UPDATE en la tabla `Interview`

## Datos de Ejemplo Predefinidos

### Tipos de Entrevista (6 tipos)
1. Entrevista telefónica
2. Entrevista técnica
3. Entrevista cultural
4. Entrevista final
5. Prueba técnica
6. Entrevista con el equipo

### Flujos de Entrevista (3 flujos)
1. **Flujo estándar**: 4 pasos (telefónica → técnica → cultural → final)
2. **Flujo técnico avanzado**: 5 pasos (telefónica → prueba técnica → técnica profunda → equipo → final)
3. **Flujo ejecutivo**: 3 pasos (telefónica → cultural → final ejecutiva)

## Instrucciones de Implementación

### Paso 1: Ejecutar la Migración SQL
```bash
# Desde la raíz del proyecto
docker exec -i ai4devs-db-sr-01-db-1 psql -U LTIdbUser -d LTIdb < backend/prisma/erd_migration.sql
```

### Paso 2: Verificar la Migración
```bash
# Verificar que todo se aplicó correctamente
docker exec -i ai4devs-db-sr-01-db-1 psql -U LTIdbUser -d LTIdb < backend/prisma/verify_migration.sql
```

### Paso 3: Sincronizar Prisma
```bash
# Desde el directorio backend
cd backend
npx prisma migrate dev --name "erd_implementation"
npx prisma generate
```

## Consultas de Ejemplo

### Búsqueda de Posiciones por Texto
```sql
SELECT * FROM "Position" 
WHERE to_tsvector('english', title) @@ plainto_tsquery('english', 'developer');
```

### Obtener Flujo Completo de Entrevistas
```sql
SELECT 
    p.title as position_title,
    if.description as flow_description,
    ist.name as step_name,
    it.name as interview_type,
    ist.orderIndex
FROM "Position" p
JOIN "InterviewFlow" if ON p."interviewFlowId" = if.id
JOIN "InterviewStep" ist ON if.id = ist."interviewFlowId"
JOIN "InterviewType" it ON ist."interviewTypeId" = it.id
WHERE p.id = 1
ORDER BY ist.orderIndex;
```

### Aplicaciones por Estado
```sql
SELECT 
    c."firstName" || ' ' || c."lastName" as candidate_name,
    p.title as position_title,
    a.status,
    a."applicationDate"
FROM "Application" a
JOIN "Candidate" c ON a."candidateId" = c.id
JOIN "Position" p ON a."positionId" = p.id
WHERE a.status = 'APPLIED'
ORDER BY a."applicationDate" DESC;
```

## Consideraciones de Seguridad

### Validaciones de Negocio
- **Relación única**: Un candidato solo puede aplicar una vez por posición
- **Puntuación válida**: Las puntuaciones de entrevista deben estar entre 0-100
- **Superposición de horarios**: Validación automática de conflictos de entrevistas
- **Integridad referencial**: Cascade deletes apropiados

### Auditoría
- **Timestamps automáticos**: `createdAt` y `updatedAt` se manejan automáticamente
- **Trazabilidad**: Campos `createdBy` y `updatedBy` para auditoría
- **Triggers**: Actualización automática de timestamps

## Próximos Pasos

### Desarrollo de Backend
1. **Crear servicios** para cada modelo en `backend/src/application/services/`
2. **Implementar controladores** para las APIs
3. **Agregar validaciones** de negocio
4. **Crear middlewares** de autenticación y autorización

### Desarrollo de Frontend
1. **Crear componentes** para gestión de empresas
2. **Implementar formularios** de posiciones
3. **Desarrollar dashboard** de aplicaciones
4. **Crear interfaz** de gestión de entrevistas

### Testing
1. **Tests unitarios** para servicios
2. **Tests de integración** para APIs
3. **Tests de base de datos** para triggers y constraints
4. **Tests de performance** para índices

## Mantenimiento

### Monitoreo
- **Performance**: Monitorear consultas lentas
- **Índices**: Revisar uso de índices periódicamente
- **Datos**: Verificar integridad de datos
- **Logs**: Revisar logs de errores de constraints

### Optimización
- **Consultas**: Optimizar consultas frecuentes
- **Índices**: Agregar índices según patrones de uso
- **Particionamiento**: Considerar particionamiento para tablas grandes
- **Archivado**: Implementar estrategia de archivado de datos antiguos

## Soporte

Para problemas o preguntas sobre la implementación:
1. Revisar los logs de la base de datos
2. Ejecutar el script de verificación
3. Consultar la documentación de Prisma
4. Revisar los constraints y triggers implementados 