# Especificación de la API - AI4Devs

## Descripción General

La API de AI4Devs es una API REST que proporciona endpoints para la gestión de candidatos en procesos de reclutamiento. Está construida con Node.js, Express y TypeScript, utilizando Prisma como ORM para PostgreSQL.

## Información de la API

- **Título**: AI4Devs Candidate API
- **Versión**: 1.0.0
- **Descripción**: API para gestionar datos de candidatos en el sistema de reclutamiento AI4Devs
- **Base URL**: `http://localhost:3010`

## Endpoints

### 1. Crear Candidato

#### POST /candidates

Crea un nuevo candidato en el sistema.

**Descripción**: Añade un nuevo candidato al sistema y retorna los datos del candidato creado.

**Request Body**:
```json
{
  "firstName": "string",
  "lastName": "string", 
  "email": "string",
  "phone": "string (opcional)",
  "address": "string (opcional)",
  "educations": [
    {
      "institution": "string",
      "title": "string",
      "startDate": "YYYY-MM-DD",
      "endDate": "YYYY-MM-DD (opcional)"
    }
  ],
  "workExperiences": [
    {
      "company": "string",
      "position": "string",
      "description": "string (opcional)",
      "startDate": "YYYY-MM-DD",
      "endDate": "YYYY-MM-DD (opcional)"
    }
  ],
  "cv": {
    "filePath": "string",
    "fileType": "string"
  }
}
```

**Validaciones**:

| Campo | Tipo | Requerido | Validación |
|-------|------|-----------|------------|
| firstName | string | Sí | 2-50 caracteres, solo letras y espacios |
| lastName | string | Sí | 2-50 caracteres, solo letras y espacios |
| email | string | Sí | Formato de email válido |
| phone | string | No | Formato de teléfono internacional |
| address | string | No | Máximo 100 caracteres |
| institution | string | Sí | Máximo 100 caracteres |
| title | string | Sí | Máximo 100 caracteres |
| startDate | string | Sí | Formato YYYY-MM-DD |
| endDate | string | No | Formato YYYY-MM-DD |
| company | string | Sí | Máximo 100 caracteres |
| position | string | Sí | Máximo 100 caracteres |
| description | string | No | Máximo 200 caracteres |

**Respuestas**:

#### 201 - Candidato Creado Exitosamente
```json
{
  "id": "string",
  "firstName": "string",
  "lastName": "string",
  "email": "string",
  "phone": "string",
  "address": "string",
  "educations": [
    {
      "institution": "string",
      "title": "string",
      "startDate": "string",
      "endDate": "string"
    }
  ],
  "workExperiences": [
    {
      "company": "string",
      "position": "string",
      "description": "string",
      "startDate": "string",
      "endDate": "string"
    }
  ],
  "cv": {
    "filePath": "string",
    "fileType": "string"
  }
}
```

#### 400 - Bad Request
```json
{
  "message": "Datos inválidos: [descripción del error]"
}
```

#### 500 - Internal Server Error
```json
{
  "message": "Error interno del servidor"
}
```

### 2. Subir Archivo

#### POST /upload

Sube un archivo al servidor.

**Descripción**: Sube un archivo al servidor. Solo se permiten archivos PDF y DOCX.

**Request Body**:
```
Content-Type: multipart/form-data

{
  "file": "binary"
}
```

**Validaciones**:
- Solo archivos PDF y DOCX están permitidos
- Tamaño máximo de archivo: 10MB

**Respuestas**:

#### 200 - Archivo Subido Exitosamente
```json
{
  "filePath": "string",
  "fileType": "string"
}
```

#### 400 - Tipo de Archivo Inválido
```json
{
  "message": "Solo se permiten archivos PDF y DOCX"
}
```

#### 500 - Error en el Proceso de Subida
```json
{
  "message": "Error durante el proceso de subida de archivo"
}
```

## Códigos de Estado HTTP

| Código | Descripción | Uso |
|--------|-------------|-----|
| 200 | OK | Operación exitosa |
| 201 | Created | Recurso creado exitosamente |
| 400 | Bad Request | Datos de entrada inválidos |
| 404 | Not Found | Recurso no encontrado |
| 500 | Internal Server Error | Error interno del servidor |

## Headers

### Headers de Request
```
Content-Type: application/json
Accept: application/json
```

### Headers de Response
```
Content-Type: application/json
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Credentials: true
```

## Autenticación

Actualmente la API no requiere autenticación. En futuras versiones se implementará:

- JWT (JSON Web Tokens)
- OAuth 2.0
- API Keys

## Rate Limiting

No implementado actualmente. Se recomienda implementar:

- Límite de requests por IP
- Límite de requests por usuario
- Límite de requests por endpoint

## Validaciones

### Validaciones de Campos

#### firstName y lastName
- **Patrón**: `^[a-zA-ZñÑáéíóúÁÉÍÓÚ ]+$`
- **Longitud**: 2-50 caracteres
- **Caracteres permitidos**: Letras, espacios y caracteres acentuados

#### email
- **Patrón**: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
- **Formato**: Email válido con dominio

#### phone
- **Patrón**: `^\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d$`
- **Formato**: Número de teléfono internacional opcional

#### address
- **Longitud máxima**: 100 caracteres
- **Campo opcional**

### Validaciones de Fechas

#### startDate y endDate
- **Formato**: `YYYY-MM-DD`
- **Validación**: endDate debe ser posterior a startDate
- **Opcional**: endDate puede ser null para fechas actuales

### Validaciones de Archivos

#### Tipos Permitidos
- PDF (`application/pdf`)
- DOCX (`application/vnd.openxmlformats-officedocument.wordprocessingml.document`)

#### Tamaño Máximo
- 10MB por archivo

## Ejemplos de Uso

### Ejemplo 1: Crear Candidato Básico

**Request**:
```bash
curl -X POST http://localhost:3010/candidates \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Juan",
    "lastName": "Pérez",
    "email": "juan.perez@example.com",
    "phone": "+34 123 456 789"
  }'
```

**Response**:
```json
{
  "id": 1,
  "firstName": "Juan",
  "lastName": "Pérez",
  "email": "juan.perez@example.com",
  "phone": "+34 123 456 789",
  "address": null,
  "educations": [],
  "workExperiences": [],
  "resumes": []
}
```

### Ejemplo 2: Crear Candidato Completo

**Request**:
```bash
curl -X POST http://localhost:3010/candidates \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "María",
    "lastName": "García",
    "email": "maria.garcia@example.com",
    "phone": "+34 987 654 321",
    "address": "Calle Mayor 123, Madrid",
    "educations": [
      {
        "institution": "Universidad Complutense de Madrid",
        "title": "Ingeniero Informático",
        "startDate": "2018-09-01",
        "endDate": "2022-06-30"
      }
    ],
    "workExperiences": [
      {
        "company": "TechCorp",
        "position": "Desarrollador Full Stack",
        "description": "Desarrollo de aplicaciones web con React y Node.js",
        "startDate": "2022-07-01",
        "endDate": null
      }
    ],
    "cv": {
      "filePath": "/uploads/cv_maria_garcia.pdf",
      "fileType": "application/pdf"
    }
  }'
```

### Ejemplo 3: Subir Archivo

**Request**:
```bash
curl -X POST http://localhost:3010/upload \
  -F "file=@/path/to/cv.pdf"
```

**Response**:
```json
{
  "filePath": "/uploads/cv_123456.pdf",
  "fileType": "application/pdf"
}
```

## Manejo de Errores

### Estructura de Error
```json
{
  "message": "Descripción del error",
  "error": "Detalles técnicos del error (opcional)"
}
```

### Tipos de Errores Comunes

#### 400 - Validation Error
```json
{
  "message": "Datos inválidos: El email ya existe en la base de datos"
}
```

#### 400 - File Upload Error
```json
{
  "message": "Solo se permiten archivos PDF y DOCX"
}
```

#### 500 - Database Error
```json
{
  "message": "Error interno del servidor"
}
```

## Logging

La API implementa logging para:

- **Requests HTTP**: Método, ruta, timestamp
- **Errores**: Stack trace completo
- **Operaciones de BD**: Queries y resultados
- **Performance**: Tiempo de respuesta

### Formato de Log
```
2024-01-15T10:30:45.123Z - POST /candidates - 201 - 150ms
2024-01-15T10:30:46.456Z - ERROR - Database connection failed
```

## Performance

### Métricas de Performance
- **Response Time**: < 200ms para operaciones simples
- **Throughput**: 1000+ requests/minuto
- **Concurrent Users**: 100+ usuarios simultáneos

### Optimizaciones
- **Connection Pooling**: Configurado en Prisma
- **Query Optimization**: Uso de índices apropiados
- **Caching**: Implementar según necesidades
- **Compression**: Gzip para responses

## Seguridad

### Medidas Implementadas
- **CORS**: Configurado para permitir solo requests desde el frontend
- **Input Validation**: Validación estricta de datos de entrada
- **SQL Injection Prevention**: Uso de Prisma ORM
- **XSS Prevention**: Sanitización de datos

### Medidas Futuras
- **HTTPS**: Certificados SSL/TLS
- **Rate Limiting**: Límites de requests
- **Authentication**: JWT tokens
- **Authorization**: Roles y permisos

## Versionado

### Estrategia de Versionado
- **Semantic Versioning**: MAJOR.MINOR.PATCH
- **API Versioning**: `/api/v1/` en futuras versiones
- **Backward Compatibility**: Mantener compatibilidad cuando sea posible

### Cambios Breaking
- Cambios en estructura de respuesta
- Eliminación de endpoints
- Cambios en validaciones

## Testing

### Tipos de Tests
- **Unit Tests**: Tests de funciones individuales
- **Integration Tests**: Tests de endpoints
- **E2E Tests**: Tests de flujo completo

### Ejecutar Tests
```bash
npm test
```

## Documentación Interactiva

### Swagger UI
- **URL**: `http://localhost:3010/api-docs`
- **Descripción**: Documentación interactiva de la API
- **Funcionalidades**: Probar endpoints directamente

### OpenAPI Specification
- **Archivo**: `api-spec.yaml`
- **Formato**: OpenAPI 3.0.0
- **Uso**: Generar documentación automática

## Deployment

### Variables de Entorno
```env
NODE_ENV=production
PORT=3010
DATABASE_URL=postgresql://user:password@host:port/database
CORS_ORIGIN=https://frontend.aidevs.com
```

### Health Check
```bash
curl http://localhost:3010/health
```

### Monitoring
- **Health Checks**: Endpoint `/health`
- **Metrics**: Prometheus metrics (futuro)
- **Logging**: Structured logging
- **Alerting**: Error notifications 