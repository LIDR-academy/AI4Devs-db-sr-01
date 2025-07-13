# Patrones de Desarrollo - AI4Devs

## Descripción

Este documento describe los patrones de desarrollo identificados en el proyecto AI4Devs, tanto en el backend como en el frontend. Estos patrones representan las mejores prácticas implementadas y pueden servir como estándares para futuras funcionalidades.

## Patrones de Backend

### 1. Clean Architecture

#### Descripción
El backend sigue los principios de Clean Architecture, separando las responsabilidades en capas bien definidas.

#### Estructura
```
src/
├── domain/           # Entidades y reglas de negocio
├── application/      # Casos de uso y servicios
├── presentation/     # Controladores y manejo HTTP
└── infrastructure/  # Base de datos y servicios externos
```

#### Implementación
- **Domain Layer**: Modelos de dominio con lógica de negocio
- **Application Layer**: Servicios que orquestan operaciones
- **Presentation Layer**: Controladores que manejan requests HTTP
- **Infrastructure Layer**: Prisma para persistencia

#### Ejemplo
```typescript
// Domain Layer
export class Candidate {
    async save() { /* lógica de persistencia */ }
    static async findOne(id: number) { /* lógica de consulta */ }
}

// Application Layer
export const addCandidate = async (candidateData: any) => {
    // Validación
    // Creación de entidades
    // Persistencia
};

// Presentation Layer
export const addCandidateController = async (req: Request, res: Response) => {
    // Manejo de request/response
};
```

### 2. Repository Pattern

#### Descripción
Los modelos implementan el patrón Repository para abstraer la persistencia de datos.

#### Características
- Abstracción de la capa de datos
- Métodos estáticos para consultas
- Manejo de errores centralizado
- Transacciones automáticas

#### Implementación
```typescript
export class Candidate {
    async save() {
        if (this.id) {
            return await prisma.candidate.update({
                where: { id: this.id },
                data: candidateData
            });
        } else {
            return await prisma.candidate.create({
                data: candidateData
            });
        }
    }

    static async findOne(id: number): Promise<Candidate | null> {
        const data = await prisma.candidate.findUnique({
            where: { id: id }
        });
        return data ? new Candidate(data) : null;
    }
}
```

### 3. Service Layer Pattern

#### Descripción
Los servicios encapsulan la lógica de negocio y orquestan operaciones complejas.

#### Características
- Lógica de negocio centralizada
- Validación de datos
- Manejo de transacciones
- Gestión de errores

#### Implementación
```typescript
export const addCandidate = async (candidateData: any) => {
    try {
        // 1. Validación
        validateCandidateData(candidateData);
        
        // 2. Creación de entidades
        const candidate = new Candidate(candidateData);
        
        // 3. Persistencia
        const savedCandidate = await candidate.save();
        
        // 4. Relaciones
        if (candidateData.educations) {
            for (const education of candidateData.educations) {
                const educationModel = new Education(education);
                educationModel.candidateId = savedCandidate.id;
                await educationModel.save();
            }
        }
        
        return savedCandidate;
    } catch (error) {
        // Manejo de errores específicos
        if (error.code === 'P2002') {
            throw new Error('The email already exists in the database');
        }
        throw error;
    }
};
```

### 4. Controller Pattern

#### Descripción
Los controladores manejan las peticiones HTTP y delegan la lógica a los servicios.

#### Características
- Extracción de datos de request
- Validación de entrada
- Llamada a servicios
- Formateo de respuesta
- Manejo de errores HTTP

#### Implementación
```typescript
export const addCandidateController = async (req: Request, res: Response) => {
    try {
        const candidateData = req.body;
        const candidate = await addCandidate(candidateData);
        res.status(201).json({ 
            message: 'Candidate added successfully', 
            data: candidate 
        });
    } catch (error: unknown) {
        if (error instanceof Error) {
            res.status(400).json({ 
                message: 'Error adding candidate', 
                error: error.message 
            });
        } else {
            res.status(400).json({ 
                message: 'Error adding candidate', 
                error: 'Unknown error' 
            });
        }
    }
};
```

### 5. Middleware Pattern

#### Descripción
Uso de middleware para funcionalidades transversales.

#### Implementaciones
```typescript
// CORS Middleware
app.use(cors({
    origin: 'http://localhost:3000',
    credentials: true
}));

// Prisma Client Injection
app.use((req, res, next) => {
    req.prisma = prisma;
    next();
});

// Logging Middleware
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Error Handling Middleware
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});
```

## Patrones de Frontend

### 1. Component-Based Architecture

#### Descripción
Arquitectura basada en componentes reutilizables y modulares.

#### Estructura
```
src/
├── components/       # Componentes reutilizables
├── services/         # Lógica de comunicación con API
├── assets/          # Recursos estáticos
└── App.tsx          # Componente raíz
```

#### Implementación
```javascript
// Componente principal
const AddCandidateForm = () => {
    const [candidate, setCandidate] = useState(initialState);
    const [error, setError] = useState('');
    const [successMessage, setSuccessMessage] = useState('');

    const handleSubmit = async (e) => {
        // Lógica de envío
    };

    return (
        <Container className="mt-5">
            <Form onSubmit={handleSubmit}>
                {/* Campos del formulario */}
            </Form>
        </Container>
    );
};
```

### 2. State Management Pattern

#### Descripción
Gestión de estado local con hooks de React.

#### Características
- Estado local por componente
- Hooks personalizados para lógica reutilizable
- Separación de estado de UI y datos

#### Implementación
```javascript
// Estado del formulario
const [candidate, setCandidate] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    address: '',
    educations: [],
    workExperiences: [],
    cv: null
});

// Estado de UI
const [error, setError] = useState('');
const [successMessage, setSuccessMessage] = useState('');

// Handlers para cambios
const handleInputChange = (e, index, section) => {
    const updatedSection = [...candidate[section]];
    if (updatedSection[index]) {
        updatedSection[index][e.target.name] = e.target.value;
        setCandidate({ ...candidate, [section]: updatedSection });
    }
};
```

### 3. Service Layer Pattern

#### Descripción
Servicios para comunicación con la API del backend.

#### Características
- Abstracción de llamadas HTTP
- Manejo de errores centralizado
- Configuración de headers
- Transformación de datos

#### Implementación
```javascript
// candidateService.js
export const addCandidate = async (candidateData) => {
    try {
        const res = await fetch('http://localhost:3010/candidates', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(candidateData)
        });

        if (res.status === 201) {
            return await res.json();
        } else {
            const errorData = await res.json();
            throw new Error(errorData.message);
        }
    } catch (error) {
        throw new Error('Error al enviar datos del candidato: ' + error.message);
    }
};
```

### 4. Form Handling Pattern

#### Descripción
Patrón para manejo de formularios complejos con validación.

#### Características
- Gestión de estado de formulario
- Validación en tiempo real
- Manejo de campos dinámicos
- Formateo de datos antes del envío

#### Implementación
```javascript
// Manejo de campos dinámicos
const handleAddSection = (section) => {
    const newSection = section === 'educations' 
        ? { institution: '', title: '', startDate: '', endDate: '' }
        : { company: '', position: '', description: '', startDate: '', endDate: '' };
    setCandidate({ ...candidate, [section]: [...candidate[section], newSection] });
};

const handleRemoveSection = (index, section) => {
    const updatedSection = [...candidate[section]];
    updatedSection.splice(index, 1);
    setCandidate({ ...candidate, [section]: updatedSection });
};

// Formateo de datos
const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Formatear fechas
    candidateData.educations = candidateData.educations.map(education => ({
        ...education,
        startDate: education.startDate ? education.startDate.toISOString().slice(0, 10) : '',
        endDate: education.endDate ? education.endDate.toISOString().slice(0, 10) : ''
    }));
    
    // Enviar datos
    const result = await addCandidate(candidateData);
};
```

### 5. Error Handling Pattern

#### Descripción
Patrón para manejo consistente de errores en la aplicación.

#### Características
- Captura de errores en diferentes niveles
- Mensajes de error amigables
- Estados de error en UI
- Logging de errores

#### Implementación
```javascript
// Manejo de errores en componentes
try {
    const result = await addCandidate(candidateData);
    setSuccessMessage('Candidato añadido con éxito');
    setError('');
} catch (error) {
    setError('Error al añadir candidato: ' + error.message);
    setSuccessMessage('');
}

// Manejo de errores en servicios
export const addCandidate = async (candidateData) => {
    try {
        const res = await fetch('http://localhost:3010/candidates', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(candidateData)
        });

        if (res.status === 201) {
            return await res.json();
        } else if (res.status === 400) {
            const errorData = await res.json();
            throw new Error('Datos inválidos: ' + errorData.message);
        } else {
            throw new Error('Error interno del servidor');
        }
    } catch (error) {
        throw new Error('Error al enviar datos del candidato: ' + error.message);
    }
};
```

## Patrones de Base de Datos

### 1. Entity-Relationship Pattern

#### Descripción
Modelado de entidades con relaciones bien definidas.

#### Implementación
```prisma
model Candidate {
    id                Int               @id @default(autoincrement())
    firstName         String            @db.VarChar(100)
    lastName          String            @db.VarChar(100)
    email             String            @unique @db.VarChar(255)
    phone             String?           @db.VarChar(15)
    address           String?           @db.VarChar(100)
    educations        Education[]
    workExperiences   WorkExperience[]
    resumes           Resume[]
}

model Education {
    id            Int       @id @default(autoincrement())
    institution   String    @db.VarChar(100)
    title         String    @db.VarChar(250)
    startDate     DateTime
    endDate       DateTime?
    candidateId   Int
    candidate     Candidate @relation(fields: [candidateId], references: [id])
}
```

### 2. Migration Pattern

#### Descripción
Sistema de versionado de esquema de base de datos.

#### Características
- Migraciones incrementales
- Rollback de cambios
- Versionado de esquema
- Sincronización entre entornos

### 3. Validation Pattern

#### Descripción
Validación de datos a nivel de aplicación y base de datos.

#### Implementación
```typescript
// Validación en aplicación
export const validateCandidateData = (data: any) => {
    if (!data.firstName || data.firstName.length < 2) {
        throw new Error('First name is required and must be at least 2 characters');
    }
    if (!data.lastName || data.lastName.length < 2) {
        throw new Error('Last name is required and must be at least 2 characters');
    }
    if (!data.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email)) {
        throw new Error('Valid email is required');
    }
};

// Validación en base de datos
model Candidate {
    email String @unique @db.VarChar(255)
    // Constraints automáticos de Prisma
}
```

## Patrones de Testing

### 1. Unit Testing Pattern

#### Descripción
Tests unitarios para funciones y métodos individuales.

#### Implementación
```typescript
// candidateService.test.ts
describe('addCandidate', () => {
    it('should create a candidate with valid data', async () => {
        const candidateData = {
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@example.com'
        };
        
        const result = await addCandidate(candidateData);
        
        expect(result).toHaveProperty('id');
        expect(result.firstName).toBe('John');
        expect(result.lastName).toBe('Doe');
        expect(result.email).toBe('john@example.com');
    });
    
    it('should throw error for invalid email', async () => {
        const candidateData = {
            firstName: 'John',
            lastName: 'Doe',
            email: 'invalid-email'
        };
        
        await expect(addCandidate(candidateData)).rejects.toThrow('Valid email is required');
    });
});
```

### 2. Integration Testing Pattern

#### Descripción
Tests de integración para endpoints y flujos completos.

#### Implementación
```typescript
// candidateController.test.ts
describe('POST /candidates', () => {
    it('should create candidate via API', async () => {
        const candidateData = {
            firstName: 'Jane',
            lastName: 'Smith',
            email: 'jane@example.com'
        };
        
        const response = await request(app)
            .post('/candidates')
            .send(candidateData)
            .expect(201);
        
        expect(response.body).toHaveProperty('id');
        expect(response.body.firstName).toBe('Jane');
    });
});
```

## Patrones de Configuración

### 1. Environment Configuration Pattern

#### Descripción
Configuración basada en variables de entorno.

#### Implementación
```typescript
// Backend
const port = process.env.PORT || 3010;
const databaseUrl = process.env.DATABASE_URL;

// Frontend
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:3010';
```

### 2. Docker Configuration Pattern

#### Descripción
Configuración de contenedores para desarrollo y producción.

#### Implementación
```yaml
# docker-compose.yml
version: "3.1"
services:
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - ${DB_PORT}:5432
```

## Estándares de Código

### 1. Naming Conventions

#### Backend (TypeScript)
- **Clases**: PascalCase (`Candidate`, `Education`)
- **Funciones**: camelCase (`addCandidate`, `getCandidateById`)
- **Variables**: camelCase (`candidateData`, `firstName`)
- **Constantes**: UPPER_SNAKE_CASE (`DATABASE_URL`)

#### Frontend (JavaScript/TypeScript)
- **Componentes**: PascalCase (`AddCandidateForm`, `RecruiterDashboard`)
- **Funciones**: camelCase (`handleSubmit`, `handleInputChange`)
- **Variables**: camelCase (`candidate`, `error`)
- **CSS Classes**: kebab-case (`form-control`, `btn-primary`)

### 2. File Organization

#### Backend
```
src/
├── domain/models/          # Entidades de dominio
├── application/services/    # Servicios de aplicación
├── presentation/controllers/ # Controladores
├── routes/                 # Definición de rutas
└── index.ts               # Punto de entrada
```

#### Frontend
```
src/
├── components/             # Componentes reutilizables
├── services/              # Servicios de API
├── assets/                # Recursos estáticos
├── App.tsx               # Componente principal
└── index.tsx             # Punto de entrada
```

### 3. Error Handling Standards

#### Backend
- **Validation Errors**: 400 Bad Request
- **Not Found Errors**: 404 Not Found
- **Server Errors**: 500 Internal Server Error
- **Database Errors**: Manejo específico por tipo

#### Frontend
- **User-Friendly Messages**: Mensajes claros para el usuario
- **Technical Logging**: Logs técnicos para debugging
- **Error States**: Estados visuales de error
- **Recovery Options**: Opciones para recuperarse del error

## Recomendaciones para Futuras Implementaciones

### 1. Backend
- Implementar autenticación JWT
- Añadir rate limiting
- Implementar logging estructurado
- Añadir health checks
- Implementar caching con Redis

### 2. Frontend
- Implementar React Context para estado global
- Añadir lazy loading para componentes
- Implementar service workers para caching
- Añadir tests de componentes con React Testing Library
- Implementar error boundaries

### 3. Base de Datos
- Implementar soft deletes
- Añadir auditoría de cambios
- Implementar particionamiento para grandes volúmenes
- Añadir índices optimizados
- Implementar backup automático

### 4. Testing
- Añadir tests de performance
- Implementar tests de seguridad
- Añadir tests de accesibilidad
- Implementar tests de integración E2E
- Añadir coverage reporting

## Conclusión

Estos patrones de desarrollo proporcionan una base sólida para el mantenimiento y escalabilidad del proyecto AI4Devs. Se recomienda seguir estos patrones en futuras implementaciones para mantener la consistencia y calidad del código. 