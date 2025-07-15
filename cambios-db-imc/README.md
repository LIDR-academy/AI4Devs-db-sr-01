# Migración de Base de Datos – Gestión de Talento

Este directorio agrupa **todos los artefactos generados** para ampliar el esquema PostgreSQL de la aplicación conforme al ERD de gestión de talento.

## 📜 Resumen de acciones ejecutadas
1. **Preparación**: se creó este directorio y se copió el `schema.prisma` original para trabajar sobre una copia.
2. **Análisis**: se introspectó el esquema existente (`prisma db pull`) y se identificaron las tablas faltantes.
3. **Modelado**: se añadieron 8 modelos nuevos y se ajustaron relaciones, índices y tipos de datos en `schema.prisma`.
4. **Generación de migración**:
   - Se creó la migración Prisma (`init_erd_extension`).
   - Se exportó el SQL completo con `prisma migrate diff`.
5. **Aplicación**: el script SQL se aplicó al contenedor Postgres; se ajustó el script de verificación.
6. **Verificación**: se ejecutó `verificacion-migracion.sql` y se confirmó la existencia de 12 tablas, 13 FKs y 16 índices.

## 📁 Contenido del directorio `cambios-db-imc`
| Fichero | Descripción |
|---------|-------------|
| **`prompt-inicial-chatgpt.md`** | Prompt inicial, en ChatGPT, para diseñar un buen prompt de partida para realizar el trabajo en Cursor. |
| **`prompt-migracion-cursor.md`** | Prompt generado con el prompt anterior, listo para ser utilizado desde Cursor. |
| **`schema.prisma`** | Esquema Prisma actualizado con todos los modelos, relaciones e índices. |
| **`sentencias-migracion-desde-erd.sql`** | Script SQL autogenerado que crea/actualiza todas las tablas, constraints e índices. Útil para aplicar la migración sin depender de Prisma. |
| **`verificacion-migracion.sql`** | Conjunto de consultas a `information_schema` y catálogos de PostgreSQL para comprobar que tablas, columnas, claves e índices existen tras la migración. |
| **`documentacion-migracion.rd`** | Bitácora paso a paso con comandos, decisiones de diseño y resultados de consola. Sirve como auditoría completa del proceso. |
| **`README.md`** | Este archivo: resumen ejecutivo de la migración y descripción de todos los artefactos. |

## 🚀 Cómo aplicar la migración manualmente
1. Asegúrate de que el contenedor de Postgres esté corriendo (`docker compose up -d db`).
2. Ejecuta:
   ```bash
   type cambios-db-imc/sentencias-migracion-desde-erd.sql | docker exec -i <nombre_contenedor> psql -U <usuario> -d <basedatos>
   ```
3. Verifica con:
   ```bash
   type cambios-db-imc/verificacion-migracion.sql | docker exec -i <nombre_contenedor> psql -U <usuario> -d <basedatos>
   ```

## 📌 Notas finales
- No se modificó ningún archivo fuera de `cambios-db-imc/` salvo la copia inicial de `schema.prisma`.
- La migración es **idempotente**: si algunas tablas ya existen, el script continuará (puede emitir avisos "relation already exists").
- El proyecto puede volver a sincronizarse con Prisma ejecutando `npx prisma generate` apuntando al nuevo `schema.prisma`. 