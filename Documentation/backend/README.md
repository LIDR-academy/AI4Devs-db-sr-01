# Backend - AI4Devs

## Descripción

El backend de AI4Devs es una API REST construida con Node.js, Express y TypeScript, siguiendo los principios de Clean Architecture. Utiliza Prisma como ORM para interactuar con PostgreSQL.

## Arquitectura

### Clean Architecture

El backend está organizado siguiendo los principios de Clean Architecture:

```
src/
├── domain/           # Capa de dominio (entidades y reglas de negocio)
│   └── models/      # Modelos de dominio
├── application/      # Capa de aplicación (casos de uso)
│   └── services/    # Servicios de aplicación
├── presentation/     # Capa de presentación (controladores)
│   └── controllers/ # Controladores HTTP
└── routes/          # Definición de rutas
```

### Capas de la Arquitectura

#### 1. Domain Layer (`src/domain/`)
Contiene las entidades de negocio y reglas del dominio:

- **Candidate.ts**: Modelo principal del candidato
- **Education.ts**: Modelo de educación
- **WorkExperience.ts**: Modelo de experiencia laboral
- **Resume.ts**: Modelo de archivos de CV

#### 2. Application Layer (`src/application/`)
Contiene la lógica de aplicación y casos de uso:

- **candidateService.ts**: Servicios para gestión de candidatos
- **fileUploadService.ts**: Servicios para subida de archivos
- **validator.ts**: Validación de datos de entrada

#### 3. Presentation Layer (`src/presentation/`)
Maneja la presentación y comunicación HTTP:

- **candidateController.ts**: Controladores para endpoints de candidatos

#### 4. Infrastructure Layer
Configuración de base de datos y herramientas externas:

- **Prisma**: ORM y migraciones
- **Express**: Framework web
- **Middleware**: CORS, logging, etc.

## Estructura de Archivos

```
backend/
├── src/
│   ├── domain/
│   │   └── models/
│   │       ├── Candidate.ts
│   │       ├── Education.ts
│   │       ├── WorkExperience.ts
│   │       └── Resume.ts
│   ├── application/
│   │   ├── services/
│   │   │   ├── candidateService.ts
│   │   │   ├── fileUploadService.ts
│   │   │   └── validator.ts
│   │   └── validator.ts
│   ├── presentation/
│   │   └── controllers/
│   │       └── candidateController.ts
│   ├── routes/
│   │   └── candidateRoutes.ts
│   └── index.ts
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── package.json
├── tsconfig.json
└── jest.config.js
```

## Modelos de Dominio

### Candidate
```typescript
export class Candidate {
    id?: number;
    firstName: string;
    lastName: string;
    email: string;
    phone?: string;
    address?: string;
    education: Education[];
    workExperience: WorkExperience[];
    resumes: Resume[];
}
```

### Education
```typescript
export class Education {
    id?: number;
    institution: string;
    title: string;
    startDate: Date;
    endDate?: Date;
    candidateId: number;
}
```

### WorkExperience
```typescript
export class WorkExperience {
    id?: number;
    company: string;
    position: string;
    description?: string;
    startDate: Date;
    endDate?: Date;
    candidateId: number;
}
```

### Resume
```typescript
export class Resume {
    id?: number;
    filePath: string;
    fileType: string;
    uploadDate: Date;
    candidateId: number;
}
```

## Servicios de Aplicación

### CandidateService
Responsable de la lógica de negocio para candidatos:

- `addCandidate()`: Crear nuevo candidato
- `getCandidateById()`: Obtener candidato por ID

### FileUploadService
Maneja la subida de archivos CV:

- `uploadFile()`: Procesar y guardar archivos
- Validación de tipos de archivo (PDF, DOCX)

### Validator
Validación de datos de entrada:

- `validateCandidateData()`: Validar datos del candidato
- Validación de campos requeridos y formatos

## Controladores

### CandidateController
Maneja las peticiones HTTP relacionadas con candidatos:

- `addCandidateController()`: POST /candidates
- `getCandidateByIdController()`: GET /candidates/:id

## Rutas

### CandidateRoutes
Define los endpoints de candidatos:

```typescript
router.post('/', async (req, res) => {
    // Crear candidato
});

router.get('/:id', async (req, res) => {
    // Obtener candidato por ID
});
```

## Configuración

### Middleware
- **CORS**: Configurado para permitir requests desde `http://localhost:3000`
- **JSON Parser**: Para procesar JSON en requests
- **Prisma Client**: Inyectado en cada request
- **Error Handling**: Middleware global para manejo de errores

### Base de Datos
- **PostgreSQL**: Base de datos principal
- **Prisma**: ORM para TypeScript
- **Migraciones**: Sistema de versionado de esquema

## Testing

### Configuración
- **Jest**: Framework de testing
- **ts-jest**: Para testing de TypeScript
- **Tests unitarios**: Para servicios y controladores

### Ejecutar Tests
```bash
npm test
```

## Scripts Disponibles

```json
{
    "dev": "ts-node-dev --respawn --transpile-only src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "prisma:generate": "npx prisma generate",
    "prisma:migrate": "npx prisma migrate dev"
}
```

## Dependencias Principales

### Producción
- `express`: Framework web
- `@prisma/client`: Cliente de Prisma
- `cors`: Middleware CORS
- `multer`: Manejo de archivos
- `swagger-jsdoc`: Documentación API
- `swagger-ui-express`: UI de Swagger

### Desarrollo
- `typescript`: Compilador TypeScript
- `ts-node-dev`: Desarrollo con hot reload
- `jest`: Framework de testing
- `@types/*`: Tipos TypeScript
- `eslint`: Linter
- `prettier`: Formateador de código

## Patrones de Desarrollo

### 1. Repository Pattern
Los modelos implementan el patrón Repository para abstraer la persistencia:

```typescript
async save() {
    // Lógica de persistencia
}

static async findOne(id: number) {
    // Lógica de consulta
}
```

### 2. Service Layer Pattern
Los servicios encapsulan la lógica de negocio:

```typescript
export const addCandidate = async (candidateData: any) => {
    // Validación
    // Creación de entidades
    // Persistencia
    // Retorno de resultado
};
```

### 3. Controller Pattern
Los controladores manejan las peticiones HTTP:

```typescript
export const addCandidateController = async (req: Request, res: Response) => {
    // Extracción de datos
    // Llamada a servicios
    // Respuesta HTTP
};
```

## Manejo de Errores

### Tipos de Errores
- **ValidationError**: Datos de entrada inválidos
- **DatabaseError**: Errores de conexión a BD
- **FileUploadError**: Errores en subida de archivos
- **PrismaError**: Errores específicos de Prisma

### Middleware de Errores
```typescript
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});
```

## Logging

El sistema implementa logging básico para:
- Requests HTTP
- Errores de aplicación
- Operaciones de base de datos

## Seguridad

### CORS
Configurado para permitir solo requests desde el frontend:
```typescript
app.use(cors({
    origin: 'http://localhost:3000',
    credentials: true
}));
```

### Validación de Entrada
- Validación de tipos de datos
- Sanitización de entrada
- Validación de formatos (email, fechas, etc.)

## Performance

### Optimizaciones
- **Connection Pooling**: Configurado en Prisma
- **Query Optimization**: Uso de índices en BD
- **Error Handling**: Manejo eficiente de errores
- **TypeScript**: Compilación estática para mejor performance

## Deployment

### Producción
1. Compilar TypeScript: `npm run build`
2. Generar cliente Prisma: `npm run prisma:generate`
3. Ejecutar migraciones: `npm run prisma:migrate`
4. Iniciar servidor: `npm start`

### Variables de Entorno
```env
DATABASE_URL="postgresql://user:password@host:port/database"
NODE_ENV="production"
PORT=3010
``` 