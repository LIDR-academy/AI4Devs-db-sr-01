# AI4Devs - Sistema de Gestión de Candidatos

## Descripción General

AI4Devs es una aplicación web completa para la gestión de candidatos en procesos de reclutamiento. El sistema está compuesto por un backend en Node.js con Express y Prisma, y un frontend en React con TypeScript.

## Arquitectura del Sistema

### Estructura General
```
AI4Devs-db-sr-01/
├── backend/           # API REST con Node.js + Express + Prisma
├── frontend/          # Aplicación React + TypeScript
├── Documentation/     # Documentación del proyecto
└── docker-compose.yml # Configuración de servicios
```

### Tecnologías Utilizadas

#### Backend
- **Node.js** - Runtime de JavaScript
- **Express.js** - Framework web
- **TypeScript** - Lenguaje de programación tipado
- **Prisma** - ORM para PostgreSQL
- **PostgreSQL** - Base de datos relacional
- **Jest** - Framework de testing
- **Swagger** - Documentación de API

#### Frontend
- **React** - Biblioteca de interfaz de usuario
- **TypeScript** - Lenguaje de programación tipado
- **React Bootstrap** - Framework de componentes UI
- **React Router** - Enrutamiento de la aplicación
- **React DatePicker** - Componente para selección de fechas

## Configuración del Proyecto

### Requisitos Previos
- Node.js (v16 o superior)
- PostgreSQL
- Docker (opcional)

### Variables de Entorno
El proyecto utiliza las siguientes variables de entorno:

```env
# Base de datos
DATABASE_URL="postgresql://usuario:password@localhost:5432/nombre_db"
DB_PASSWORD=tu_password
DB_USER=tu_usuario
DB_NAME=tu_base_de_datos
DB_PORT=5432
```

### Instalación y Ejecución

1. **Clonar el repositorio**
```bash
git clone <url-del-repositorio>
cd AI4Devs-db-sr-01
```

2. **Configurar la base de datos**
```bash
# Con Docker
docker-compose up -d

# O instalar PostgreSQL localmente
```

3. **Instalar dependencias del backend**
```bash
cd backend
npm install
```

4. **Configurar Prisma**
```bash
npx prisma generate
npx prisma migrate dev
```

5. **Ejecutar el backend**
```bash
npm run dev
```

6. **Instalar dependencias del frontend**
```bash
cd ../frontend
npm install
```

7. **Ejecutar el frontend**
```bash
npm start
```

## Estructura de la Base de Datos

El sistema utiliza PostgreSQL con Prisma como ORM. La estructura de la base de datos incluye:

- **Candidate**: Información principal del candidato
- **Education**: Historial educativo
- **WorkExperience**: Experiencia laboral
- **Resume**: Archivos de CV

## API Endpoints

### Candidatos
- `POST /candidates` - Crear nuevo candidato
- `GET /candidates/:id` - Obtener candidato por ID

### Archivos
- `POST /upload` - Subir archivo CV

## Patrones de Desarrollo

### Backend (Clean Architecture)
- **Domain Layer**: Modelos de negocio
- **Application Layer**: Servicios y lógica de aplicación
- **Presentation Layer**: Controladores y rutas
- **Infrastructure Layer**: Prisma y configuración de BD

### Frontend (Component-Based Architecture)
- **Components**: Componentes reutilizables
- **Services**: Lógica de comunicación con API
- **Assets**: Recursos estáticos

## Testing

### Backend
```bash
cd backend
npm test
```

### Frontend
```bash
cd frontend
npm test
```

## Scripts Disponibles

### Backend
- `npm run dev` - Ejecutar en modo desarrollo
- `npm run build` - Compilar TypeScript
- `npm start` - Ejecutar en producción
- `npm test` - Ejecutar tests
- `npm run prisma:generate` - Generar cliente Prisma
- `npm run prisma:migrate` - Ejecutar migraciones

### Frontend
- `npm start` - Ejecutar en modo desarrollo
- `npm run build` - Construir para producción
- `npm test` - Ejecutar tests

## Documentación Adicional

- [Documentación del Backend](./backend/README.md)
- [Documentación del Frontend](./frontend/README.md)
- [Especificación de la API](./api-specification.md)
- [Guía de Base de Datos](./database/README.md) 