# ATS Database Documentation

This document provides comprehensive instructions for managing the ATS (Applicant Tracking System) database, including migrations, seeding, and verification.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Database Setup](#database-setup)
- [Migrations](#migrations)
- [Seeding](#seeding)
- [Verification](#verification)
- [PGAdmin Setup](#pgadmin-setup)
- [Useful Commands](#useful-commands)
- [Database Schema Overview](#database-schema-overview)

## Prerequisites

- PostgreSQL 12+ installed and running
- Node.js 18+ and npm installed
- Environment variable `DATABASE_URL` configured in `.env` file

### Environment Configuration

Create a `.env` file in the `backend/` directory with:

```env
DATABASE_URL="postgresql://username:password@localhost:5432/ats_db?schema=public"
```

Replace `username`, `password`, `localhost`, `5432`, and `ats_db` with your actual PostgreSQL credentials and database name.

## Database Setup

### 1. Create Database

If the database doesn't exist, create it:

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE ats_db;

# Exit psql
\q
```

### 2. Install Dependencies

```bash
cd backend
npm install
```

### 3. Generate Prisma Client

```bash
npm run prisma:generate
```

## Migrations

### Create Initial Migration

To create the initial migration from the Prisma schema:

```bash
npm run db:migrate
```

When prompted for a migration name, enter: `init_ats_schema`

This will:
- Create a new migration in `prisma/migrations/`
- Apply the migration to your database
- Generate the Prisma Client

**Note**: If you have existing tables (Candidate, Education, WorkExperience, Resume), Prisma will detect the changes and create a migration that adds the new ATS tables while preserving existing data.

### Apply Migrations

To apply pending migrations:

```bash
npm run db:migrate
```

### Reset Database

⚠️ **Warning**: This will delete all data and recreate the database schema.

```bash
npm run db:reset
```

This command:
1. Drops the database
2. Recreates it
3. Applies all migrations
4. Runs the seed script

### Migration Status

Check migration status:

```bash
npx prisma migrate status
```

## Seeding

### Run Seed Script

Populate the database with sample data:

```bash
npm run db:seed
```

The seed script creates:
- **2 Companies**: TechCorp Solutions, InnovateHub Inc.
- **4 Employees**: Recruiters and interviewers
- **4 Interview Types**: Phone Screen, Technical Interview, HR Interview, Final Round
- **2 Interview Flows**: Standard Engineering Flow, Executive Position Flow
- **7 Interview Steps**: Steps within the flows
- **4 Positions**: Various job positions with different statuses
- **5 Candidates**: Sample candidates
- **6 Applications**: Applications from candidates to positions
- **10 Interviews**: Interview records with scores and results

### Seed Data Structure

The seed data is designed to demonstrate:
- Multiple companies with employees
- Different interview flows and steps
- Positions in various states (draft, open, closed)
- Candidates with multiple applications
- Interview pipeline progression
- Completed interviews with scores

## Verification

### SQL Verification Queries

Run the verification queries to test the database:

```bash
# Using psql
psql -U postgres -d ats_db -f docs/sql/verification.sql

# Or connect and run manually
psql -U postgres -d ats_db
\i docs/sql/verification.sql
```

### Prisma Client Verification

Create a verification script or use Prisma Studio:

```bash
npm run db:studio
```

This opens Prisma Studio in your browser where you can:
- Browse all tables
- View relationships
- Edit data
- Run queries

### Key Verification Queries

The `verification.sql` file includes:

1. **Visible positions by company** - Lists open positions with application counts
2. **Interview flow for a position** - Shows ordered steps for a position
3. **Applications for a candidate** - All applications with status and dates
4. **Interviews by employee** - Interviews conducted with scores
5. **Application pipeline** - Complete pipeline for a position
6. **Interview statistics** - Statistics by interview type
7. **Candidates with multiple applications** - Active candidates
8. **Data integrity checks** - Orphaned records verification
9. **Employee workload** - Interview scheduling per employee
10. **Position application funnel** - Application status breakdown

## PGAdmin Setup

### 1. Install PGAdmin

Download and install PGAdmin from [https://www.pgadmin.org/download/](https://www.pgadmin.org/download/)

### 2. Create Server Connection

1. Open PGAdmin
2. Right-click on "Servers" → "Register" → "Server"
3. Fill in the **General** tab:
   - **Name**: ATS Database (or any name you prefer)
4. Fill in the **Connection** tab:
   - **Host name/address**: `localhost` (or your PostgreSQL host)
   - **Port**: `5432` (default PostgreSQL port)
   - **Maintenance database**: `postgres`
   - **Username**: Your PostgreSQL username
   - **Password**: Your PostgreSQL password
   - Check "Save password" if desired
5. Click "Save"

### 3. Navigate to Database

1. Expand "Servers" → "ATS Database" → "Databases"
2. Expand your database (e.g., `ats_db`)
3. Expand "Schemas" → "public" → "Tables"

### 4. View Database Structure

#### Tables

You should see the following tables:
- `company`
- `employee`
- `interview_type`
- `interview_flow`
- `interview_step`
- `position`
- `candidate`
- `application`
- `interview`
- `education` (existing)
- `work_experience` (existing)
- `resume` (existing)

#### Indexes

To view indexes:
1. Expand any table
2. Click on "Indexes"
3. You should see indexes like:
   - `idx_employee_email_unique`
   - `idx_candidate_email_unique`
   - `idx_application_position_candidate_unique`
   - And many more for performance optimization

#### Constraints

To view constraints:
1. Expand any table
2. Click on "Constraints"
3. You should see:
   - Primary keys
   - Foreign keys
   - Unique constraints
   - Check constraints (e.g., `chk_salary_range`, `chk_order_index_positive`)

### 5. Execute SQL Queries

1. Right-click on your database → "Query Tool"
2. Open `docs/sql/verification.sql` or paste SQL queries
3. Click "Execute" (F5) or press `Ctrl+Enter`

### 6. View Data

1. Right-click on any table → "View/Edit Data" → "All Rows"
2. Browse the data
3. Use filters and sorting as needed

### 7. Verify Triggers

To verify the `updated_at` triggers:

1. Expand "Schemas" → "public" → "Functions"
2. You should see `update_updated_at_column()`
3. Expand "Triggers" under any table to see the trigger

## Useful Commands

### Prisma Commands

```bash
# Generate Prisma Client
npm run prisma:generate

# Create migration
npm run db:migrate

# Reset database (⚠️ deletes all data)
npm run db:reset

# Run seed
npm run db:seed

# Open Prisma Studio
npm run db:studio

# View migration status
npx prisma migrate status

# Format Prisma schema
npx prisma format

# Validate Prisma schema
npx prisma validate
```

### Database Commands

```bash
# Connect to PostgreSQL
psql -U postgres -d ats_db

# List all tables
\dt

# Describe table structure
\d table_name

# List all indexes
\di

# List all constraints
\d+ table_name

# Execute SQL file
\i path/to/file.sql

# Exit psql
\q
```

### Quick Verification Script

Create a file `verify-db.ts`:

```typescript
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function verify() {
  // 1. List visible positions by company
  const positions = await prisma.position.findMany({
    where: { isVisible: true, status: 'open' },
    include: {
      company: true,
      applications: true,
    },
  });

  console.log('Visible Positions:', positions.length);
  positions.forEach(p => {
    console.log(`  - ${p.company.name}: ${p.title} (${p.applications.length} applications)`);
  });

  // 2. Get interview flow for a position
  const position = await prisma.position.findFirst({
    include: {
      interviewFlow: {
        include: {
          interviewSteps: {
            include: {
              interviewType: true,
            },
            orderBy: { orderIndex: 'asc' },
          },
        },
      },
    },
  });

  if (position) {
    console.log(`\nInterview Flow for "${position.title}":`);
    position.interviewFlow.interviewSteps.forEach(step => {
      console.log(`  ${step.orderIndex}. ${step.name} (${step.interviewType.name})`);
    });
  }

  // 3. Get applications for a candidate
  const candidate = await prisma.candidate.findFirst({
    include: {
      applications: {
        include: {
          position: {
            include: { company: true },
          },
        },
        orderBy: { applicationDate: 'desc' },
      },
    },
  });

  if (candidate) {
    console.log(`\nApplications for ${candidate.firstName} ${candidate.lastName}:`);
    candidate.applications.forEach(app => {
      console.log(`  - ${app.position.title} at ${app.position.company.name} (${app.status})`);
    });
  }

  // 4. Get interviews by employee
  const employee = await prisma.employee.findFirst({
    include: {
      interviews: {
        include: {
          interviewStep: {
            include: { interviewType: true },
          },
          application: {
            include: {
              candidate: true,
              position: true,
            },
          },
        },
        orderBy: { interviewDate: 'desc' },
      },
    },
  });

  if (employee) {
    console.log(`\nInterviews conducted by ${employee.name}:`);
    employee.interviews.forEach(interview => {
      console.log(`  - ${interview.interviewStep.name} for ${interview.application.candidate.firstName} ${interview.application.candidate.lastName} (Score: ${interview.score || 'N/A'})`);
    });
  }
}

verify()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
```

Run with:

```bash
ts-node verify-db.ts
```

## Database Schema Overview

### Core Tables

- **company**: Companies posting positions
- **employee**: Employees conducting interviews
- **position**: Job positions
- **candidate**: Job candidates
- **application**: Applications from candidates to positions
- **interview**: Interview records

### Supporting Tables

- **interview_type**: Catalog of interview types
- **interview_flow**: Interview flows assigned to positions
- **interview_step**: Steps within interview flows

### Existing Tables (Extended)

- **candidate**: Extended with `applications` relationship
- **education**: Candidate education history
- **work_experience**: Candidate work history
- **resume**: Candidate resumes

### Relationships

- Company → Employees (1:N)
- Company → Positions (1:N)
- Position → Interview Flow (N:1)
- Interview Flow → Interview Steps (1:N)
- Interview Step → Interview Type (N:1)
- Position → Applications (1:N)
- Candidate → Applications (1:N)
- Application → Interviews (1:N)
- Interview Step → Interviews (1:N)
- Employee → Interviews (1:N)

### Constraints

- **Unique**: Employee email, Candidate email, Application (position_id, candidate_id)
- **Check**: Salary range (min <= max), Order index > 0, Status values, Employment type values
- **Foreign Keys**: All relationships with appropriate ON DELETE actions

### Indexes

- Unique indexes on email fields
- Composite indexes for common queries
- Indexes on foreign keys for join performance
- Indexes on status and visibility fields for filtering

## Troubleshooting

### Migration Issues

If migrations fail:

```bash
# Check migration status
npx prisma migrate status

# Reset if needed (⚠️ deletes data)
npm run db:reset

# Or manually fix and create new migration
npx prisma migrate dev --create-only
# Edit the migration file, then:
npx prisma migrate dev
```

### Connection Issues

- Verify PostgreSQL is running: `pg_isready`
- Check `DATABASE_URL` in `.env`
- Verify database exists: `psql -U postgres -l`
- Check firewall/network settings

### Seed Issues

- Ensure migrations are applied first
- Check foreign key constraints
- Verify all required data exists
- Check console for specific errors

## Next Steps

1. Review the generated schema in `prisma/schema.prisma`
2. Run migrations: `npm run db:migrate`
3. Seed the database: `npm run db:seed`
4. Verify with queries: `psql -d ats_db -f docs/sql/verification.sql`
5. Explore with PGAdmin or Prisma Studio

## Additional Resources

- [Prisma Documentation](https://www.prisma.io/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PGAdmin Documentation](https://www.pgadmin.org/docs/)

