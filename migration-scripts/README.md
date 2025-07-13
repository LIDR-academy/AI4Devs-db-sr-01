# Scripts de Migración - Fase 2

## Descripción

Este directorio contiene todos los scripts SQL necesarios para implementar la **Fase 2: Creación de Nuevas Tablas** del plan de refactorización de la base de datos.

## Archivos Incluidos

### 1. `phase2-step1-base-tables.sql`
**Objetivo**: Crear las tablas base del sistema sin dependencias
- `COMPANY` - Empresas que utilizan el sistema
- `INTERVIEW_TYPE` - Tipos de entrevistas disponibles
- `INTERVIEW_FLOW` - Flujos de entrevistas

**Características**:
- Tablas independientes (sin foreign keys)
- Índices para optimizar consultas
- Comentarios de documentación
- Constraints de validación

### 2. `phase2-step2-dependent-tables.sql`
**Objetivo**: Crear tablas que dependen de las tablas base
- `EMPLOYEE` - Empleados de las empresas
- `INTERVIEW_STEP` - Pasos dentro de los flujos de entrevista
- `POSITION` - Posiciones de trabajo ofrecidas

**Características**:
- Foreign keys hacia tablas base
- Índices compuestos para performance
- Constraints de validación (rangos de salario, orden de pasos)
- Comentarios detallados

### 3. `phase2-step3-process-tables.sql`
**Objetivo**: Crear tablas que manejan el proceso de reclutamiento
- `APPLICATION` - Aplicaciones de candidatos a posiciones
- `INTERVIEW` - Entrevistas realizadas

**Características**:
- Conectan candidatos con posiciones y entrevistas
- Constraints para evitar duplicados
- Validación de estados y resultados
- Índices para consultas frecuentes

### 4. `phase2-seed-data.sql`
**Objetivo**: Poblar las nuevas tablas con datos de ejemplo
- 5 empresas de ejemplo
- 8 tipos de entrevista
- 5 flujos de entrevista
- 9 empleados de ejemplo
- 14 pasos de entrevista
- 5 posiciones de trabajo

**Características**:
- Datos realistas y variados
- Relaciones coherentes entre entidades
- Verificación de inserción correcta

### 5. `phase2-rollback.sql`
**Objetivo**: Revertir todos los cambios de la Fase 2
- Elimina todas las nuevas tablas
- Preserva las tablas originales
- Orden correcto de eliminación por dependencias

### 6. `phase2-verification.sql`
**Objetivo**: Verificar que la implementación fue exitosa
- Verifica existencia de todas las tablas
- Valida foreign keys e índices
- Confirma inserción de datos
- Verifica integridad de relaciones

## Orden de Ejecución

### Paso 1: Preparación
```bash
# Hacer backup de la base de datos actual
pg_dump -h localhost -U tu_usuario -d tu_base_de_datos > backup_before_phase2.sql
```

### Paso 2: Ejecutar Scripts en Orden
```bash
# 1. Crear tablas base
psql -h localhost -U tu_usuario -d tu_base_de_datos -f phase2-step1-base-tables.sql

# 2. Crear tablas con dependencias
psql -h localhost -U tu_usuario -d tu_base_de_datos -f phase2-step2-dependent-tables.sql

# 3. Crear tablas de proceso
psql -h localhost -U tu_usuario -d tu_base_de_datos -f phase2-step3-process-tables.sql

# 4. Insertar datos semilla
psql -h localhost -U tu_usuario -d tu_base_de_datos -f phase2-seed-data.sql
```

### Paso 3: Verificación
```bash
# Verificar que todo se creó correctamente
psql -h localhost -U tu_usuario -d tu_base_de_datos -f phase2-verification.sql
```

## Estructura de la Nueva Base de Datos

### Tablas Originales (Sin Cambios)
- `Candidate` - Candidatos
- `Education` - Educación de candidatos
- `WorkExperience` - Experiencia laboral
- `Resume` - Archivos CV

### Nuevas Tablas
```
COMPANY (1) ←→ (N) EMPLOYEE
COMPANY (1) ←→ (N) POSITION
INTERVIEW_FLOW (1) ←→ (N) INTERVIEW_STEP
INTERVIEW_TYPE (1) ←→ (N) INTERVIEW_STEP
POSITION (1) ←→ (N) APPLICATION
Candidate (1) ←→ (N) APPLICATION
APPLICATION (1) ←→ (N) INTERVIEW
INTERVIEW_STEP (1) ←→ (N) INTERVIEW
EMPLOYEE (1) ←→ (N) INTERVIEW
```

## Características Técnicas

### Índices Creados
- Índices en campos de búsqueda frecuente
- Índices en foreign keys para performance
- Índices compuestos para consultas complejas

### Constraints de Validación
- Rangos de salario válidos
- Orden de pasos positivo
- Estados de aplicación válidos
- Resultados de entrevista válidos
- Evitar aplicaciones duplicadas

### Foreign Keys
- CASCADE para eliminación en cascada apropiada
- RESTRICT para prevenir eliminación de datos críticos
- UPDATE CASCADE para mantener integridad

## Datos de Ejemplo Incluidos

### Empresas
- Tech Solutions Inc.
- Digital Innovations Ltd.
- StartUp Dynamics
- Global Tech Corp.
- Innovation Hub

### Tipos de Entrevista
- Technical Interview
- HR Interview
- Cultural Fit
- Final Interview
- Code Review
- Behavioral Interview
- System Design
- Leadership Assessment

### Flujos de Entrevista
- Flujo estándar para junior
- Flujo para posiciones senior
- Flujo para posiciones de liderazgo
- Flujo rápido para urgentes
- Flujo completo para críticas

### Posiciones de Trabajo
- Junior Full Stack Developer
- Senior Backend Developer
- Frontend Lead
- Engineering Manager
- DevOps Engineer

## Troubleshooting

### Error: Foreign Key Constraint
Si hay errores de foreign key, verificar que:
1. Las tablas base se crearon correctamente
2. Los datos semilla se insertaron en el orden correcto
3. Los IDs referenciados existen

### Error: Duplicate Key
Si hay errores de clave duplicada:
1. Verificar que no se ejecutó el script de datos múltiples veces
2. Usar `TRUNCATE` para limpiar datos antes de reinsertar

### Error: Permission Denied
Si hay errores de permisos:
1. Verificar que el usuario tiene permisos de CREATE, INSERT, ALTER
2. Ejecutar como superusuario si es necesario

## Rollback

En caso de problemas, ejecutar:
```bash
psql -h localhost -U tu_usuario -d tu_base_de_datos -f phase2-rollback.sql
```

Esto eliminará todas las nuevas tablas y preservará las originales.

## Próximos Pasos

Después de ejecutar exitosamente la Fase 2:

1. **Actualizar schema.prisma** con los nuevos modelos
2. **Crear modelos de dominio** para las nuevas entidades
3. **Implementar servicios** para la lógica de negocio
4. **Crear controladores** para manejar HTTP requests
5. **Actualizar rutas** para exponer nuevas funcionalidades
6. **Implementar tests** para validar funcionalidad

## Notas Importantes

- ✅ **No destructivo**: Las tablas originales permanecen intactas
- ✅ **Incremental**: Se puede ejecutar sin afectar funcionalidad existente
- ✅ **Reversible**: Script de rollback incluido
- ✅ **Verificable**: Script de verificación incluido
- ✅ **Documentado**: Comentarios y documentación completa 