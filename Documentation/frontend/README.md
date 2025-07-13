# Frontend - AI4Devs

## Descripción

El frontend de AI4Devs es una aplicación React construida con TypeScript que proporciona una interfaz de usuario para la gestión de candidatos. Utiliza React Bootstrap para el diseño y React Router para la navegación.

## Arquitectura

### Component-Based Architecture

El frontend sigue una arquitectura basada en componentes:

```
src/
├── components/       # Componentes reutilizables
├── services/         # Servicios de comunicación con API
├── assets/          # Recursos estáticos
├── App.tsx          # Componente principal
└── index.tsx        # Punto de entrada
```

### Estructura de Componentes

#### Componentes Principales

1. **AddCandidateForm.js**: Formulario para agregar candidatos
2. **RecruiterDashboard.js**: Dashboard principal del reclutador
3. **FileUploader.js**: Componente para subida de archivos

## Estructura de Archivos

```
frontend/
├── src/
│   ├── components/
│   │   ├── AddCandidateForm.js
│   │   ├── FileUploader.js
│   │   └── RecruiterDashboard.js
│   ├── services/
│   │   └── candidateService.js
│   ├── assets/
│   │   └── lti-logo.png
│   ├── App.tsx
│   ├── App.css
│   └── index.tsx
├── public/
│   ├── index.html
│   └── favicon.ico
├── package.json
└── tsconfig.json
```

## Componentes Detallados

### AddCandidateForm.js

Componente principal para la creación de candidatos.

#### Funcionalidades
- Formulario completo de datos personales
- Gestión dinámica de educación
- Gestión dinámica de experiencia laboral
- Subida de archivos CV
- Validación de datos
- Manejo de errores

#### Estado del Componente
```javascript
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
```

#### Métodos Principales
- `handleInputChange()`: Manejo de cambios en campos de texto
- `handleDateChange()`: Manejo de cambios en fechas
- `handleAddSection()`: Agregar nueva educación o experiencia
- `handleRemoveSection()`: Eliminar educación o experiencia
- `handleCVUpload()`: Manejo de subida de CV
- `handleSubmit()`: Envío del formulario

### RecruiterDashboard.js

Dashboard principal que sirve como punto de entrada.

#### Funcionalidades
- Navegación a formulario de candidatos
- Logo de la empresa
- Interfaz limpia y profesional

### FileUploader.js

Componente especializado para la subida de archivos.

#### Funcionalidades
- Validación de tipos de archivo
- Preview de archivo seleccionado
- Manejo de errores de subida
- Interfaz drag-and-drop

## Servicios

### candidateService.js

Servicio para comunicación con la API del backend.

#### Métodos
- `addCandidate(candidateData)`: Enviar datos de candidato al backend
- `uploadFile(file)`: Subir archivo CV
- `getCandidate(id)`: Obtener candidato por ID

#### Ejemplo de Uso
```javascript
import { addCandidate } from '../services/candidateService';

const handleSubmit = async (candidateData) => {
    try {
        const result = await addCandidate(candidateData);
        // Manejar éxito
    } catch (error) {
        // Manejar error
    }
};
```

## Tecnologías Utilizadas

### Core
- **React 18.3.1**: Biblioteca de interfaz de usuario
- **TypeScript 4.9.5**: Lenguaje de programación tipado
- **React Router DOM 6.23.1**: Enrutamiento de la aplicación

### UI/UX
- **Bootstrap 5.3.3**: Framework CSS
- **React Bootstrap 2.10.2**: Componentes Bootstrap para React
- **React Bootstrap Icons 1.11.4**: Iconos
- **React DatePicker 6.9.0**: Selector de fechas

### Desarrollo
- **React Scripts 5.0.1**: Scripts de desarrollo
- **Jest**: Framework de testing
- **Web Vitals 2.1.4**: Métricas de performance

## Configuración

### Variables de Entorno
```env
REACT_APP_API_URL=http://localhost:3010
```

### Scripts Disponibles
```json
{
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "jest --config jest.config.js",
    "eject": "react-scripts eject"
}
```

## Flujo de Datos

### 1. Entrada de Datos
1. Usuario llena formulario en `AddCandidateForm`
2. Validación en tiempo real
3. Formateo de datos (fechas, etc.)

### 2. Envío de Datos
1. Llamada a `candidateService.addCandidate()`
2. Request HTTP a backend
3. Manejo de respuesta/error

### 3. Feedback al Usuario
1. Mensajes de éxito/error
2. Redirección o limpieza de formulario

## Validación de Datos

### Validaciones Implementadas
- **Campos requeridos**: firstName, lastName, email
- **Formato de email**: Validación de patrón
- **Fechas**: Formato YYYY-MM-DD
- **Archivos**: Tipos permitidos (PDF, DOCX)

### Ejemplo de Validación
```javascript
const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
};
```

## Manejo de Estados

### Estados Locales
- **Formulario**: Datos del candidato
- **Educación**: Lista dinámica de educación
- **Experiencia**: Lista dinámica de experiencia laboral
- **Archivos**: CV seleccionado
- **UI**: Loading, errores, mensajes

### Estados Globales
- **Context API**: Para datos compartidos (si se implementa)
- **Local Storage**: Para persistencia temporal

## Manejo de Errores

### Tipos de Errores
- **Errores de validación**: Datos inválidos
- **Errores de red**: Problemas de conexión
- **Errores del servidor**: Respuestas de error del backend
- **Errores de archivo**: Problemas con subida de archivos

### Estrategia de Manejo
```javascript
try {
    const result = await addCandidate(candidateData);
    setSuccessMessage('Candidato añadido con éxito');
    setError('');
} catch (error) {
    setError('Error al añadir candidato: ' + error.message);
    setSuccessMessage('');
}
```

## Performance

### Optimizaciones Implementadas
- **React.memo()**: Para componentes que no cambian frecuentemente
- **useCallback()**: Para funciones que se pasan como props
- **useMemo()**: Para cálculos costosos
- **Lazy Loading**: Para componentes grandes

### Bundle Optimization
- **Code Splitting**: División automática del bundle
- **Tree Shaking**: Eliminación de código no usado
- **Minificación**: Reducción del tamaño del bundle

## Testing

### Configuración
- **Jest**: Framework de testing
- **React Testing Library**: Para testing de componentes
- **User Event**: Para simulación de interacciones

### Ejecutar Tests
```bash
npm test
```

## Responsive Design

### Breakpoints
- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

### Implementación
- **Bootstrap Grid System**: Para layouts responsivos
- **Media Queries**: Para estilos específicos
- **Flexible Components**: Componentes que se adaptan

## Accesibilidad

### Implementaciones
- **ARIA Labels**: Para elementos interactivos
- **Keyboard Navigation**: Navegación por teclado
- **Screen Reader Support**: Compatibilidad con lectores de pantalla
- **Color Contrast**: Contraste adecuado de colores

## Seguridad

### Medidas Implementadas
- **Input Sanitization**: Limpieza de datos de entrada
- **XSS Prevention**: Prevención de ataques XSS
- **CSRF Protection**: Protección CSRF (si se implementa)
- **Content Security Policy**: Políticas de seguridad

## Deployment

### Build de Producción
```bash
npm run build
```

### Optimizaciones de Build
- **Minificación**: Código y CSS minificados
- **Compresión**: Archivos comprimidos
- **Cache Busting**: Nombres de archivo con hash
- **Source Maps**: Para debugging en producción

### Variables de Entorno de Producción
```env
REACT_APP_API_URL=https://api.aidevs.com
NODE_ENV=production
```

## Patrones de Desarrollo

### 1. Container/Presentational Pattern
Separación entre lógica de negocio y presentación:

```javascript
// Container Component
const AddCandidateContainer = () => {
    // Lógica de estado y efectos
    return <AddCandidateForm {...props} />;
};

// Presentational Component
const AddCandidateForm = ({ onSubmit, data }) => {
    // Solo presentación
};
```

### 2. Custom Hooks Pattern
Reutilización de lógica de estado:

```javascript
const useCandidateForm = () => {
    const [candidate, setCandidate] = useState(initialState);
    const [errors, setErrors] = useState({});
    
    const validate = () => { /* ... */ };
    const submit = () => { /* ... */ };
    
    return { candidate, errors, validate, submit };
};
```

### 3. Compound Components Pattern
Para componentes complejos:

```javascript
const Form = ({ children }) => { /* ... */ };
Form.Field = ({ children }) => { /* ... */ };
Form.Submit = ({ children }) => { /* ... */ };
```

## Integración con Backend

### Configuración de API
```javascript
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:3010';

const apiClient = {
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json',
    },
};
```

### Manejo de CORS
El backend está configurado para permitir requests desde `http://localhost:3000`.

### Formato de Datos
- **Envío**: JSON con estructura específica
- **Recepción**: JSON con datos del candidato
- **Fechas**: Formato ISO 8601 (YYYY-MM-DD)

## Estructura de Datos

### Candidate Object
```javascript
{
    firstName: string,
    lastName: string,
    email: string,
    phone?: string,
    address?: string,
    educations: Education[],
    workExperiences: WorkExperience[],
    cv?: FileData
}
```

### Education Object
```javascript
{
    institution: string,
    title: string,
    startDate: Date,
    endDate?: Date
}
```

### WorkExperience Object
```javascript
{
    company: string,
    position: string,
    description?: string,
    startDate: Date,
    endDate?: Date
}
``` 