# LTI Recruitment System Database Migration

## Overview
This migration evolves the current candidate-focused database into a comprehensive recruitment system while preserving all existing data.

## Prerequisites
- Docker and Docker Compose installed
- Node.js and npm installed
- PostgreSQL database running (via Docker)

## Step-by-Step Migration Process

### 1. Backup Current Database (CRITICAL)
```bash
# Create backup of current database
docker exec -t your_postgres_container pg_dump -U postgres -d mydatabase > backup_$(date +%Y%m%d_%H%M%S).sql
```

### 2. Stop Current Application
```bash
# Stop backend server
cd backend
npm run build
# Stop if running
```

### 3. Generate Prisma Client
```bash
cd backend
npx prisma generate
```

### 4. Run Database Migration
```bash
# Apply the migration
npm run prisma:migrate

# If prompted, name the migration: "expand_recruitment_system"
```

### 5. Seed Database with Initial Data
```bash
# Run seeding script
npm run prisma:seed
```

### 6. Verify Migration with PGAdmin (Optional but Recommended)
```bash
# Option 1: Access PGAdmin via Docker (if using Docker setup)
docker run --name pgadmin -p 8080:80 -e PGADMIN_DEFAULT_EMAIL=admin@admin.com -e PGADMIN_DEFAULT_PASSWORD=admin --network=host dpage/pgadmin4

# Option 2: Use local PGAdmin installation
# Open PGAdmin in browser: http://localhost:8080
```

**PGAdmin Verification Steps:**
1. **Connect to Database:**
   - Server: localhost
   - Port: 5432
   - Database: mydatabase
   - Username: postgres
   - Password: (your DB password)

2. **Check Table Structure:**
   - Navigate to: Databases → mydatabase → Schemas → public → Tables
   - Verify all 9 tables exist:
     - `candidates` (renamed from `Candidate`)
     - `educations` (renamed from `Education`)
     - `work_experiences` (renamed from `WorkExperience`)
     - `resumes` (renamed from `Resume`)
     - `companies` (new)
     - `employees` (new)
     - `interview_types` (new)
     - `interview_flows` (new)
     - `interview_steps` (new)
     - `positions` (new)
     - `applications` (new)
     - `interviews` (new)

3. **Verify Data Integrity:**
   - Right-click on each table → View/Edit Data → All Rows
   - Check that existing candidate data is preserved
   - Verify seed data is populated in new tables

4. **Check Constraints and Indexes:**
   - Expand each table → Constraints
   - Verify foreign keys, unique constraints, and check constraints
   - Check Indexes section for performance optimization

### 7. Additional Verification
```bash
# Check database schema with Prisma Studio
npx prisma studio

# Run tests to ensure nothing is broken
npm test
```

### 8. Update Application Code
The existing domain models and services need to be updated to work with the new table names and column mappings.

### 9. Restart Application
```bash
# Build and start
npm run build
npm start
```

## Rollback Instructions (Emergency)
If something goes wrong:

```bash
# Restore from backup
docker exec -i your_postgres_container psql -U postgres -d mydatabase < backup_YYYYMMDD_HHMMSS.sql

# Reset Prisma migration state
npx prisma migrate reset --force

# Restore original schema.prisma from git
git checkout HEAD~1 -- prisma/schema.prisma
```

## Verification Checklist
- [ ] All existing candidates are preserved
- [ ] Education, work experience, and resume data intact
- [ ] New tables created successfully
- [ ] Seed data populated
- [ ] Application starts without errors
- [ ] Existing API endpoints still work
- [ ] Database constraints are enforced

## Common Issues and Solutions

### Issue: "Table already exists"
**Solution**: Run `npx prisma migrate reset` and then `npx prisma migrate dev`

### Issue: "Foreign key constraint violation"
**Solution**: Ensure proper order of operations and check referential integrity

### Issue: "Column does not exist"
**Solution**: Verify migration completed successfully and regenerate Prisma client

## Post-Migration Tasks
1. Update API documentation
2. Create new API endpoints for recruitment features
3. Update frontend components
4. Run comprehensive testing
5. Update monitoring and logging

## Support
For issues during migration, check:
- Prisma documentation: https://www.prisma.io/docs
- PostgreSQL logs: `docker logs your_postgres_container`
- Application logs in console 