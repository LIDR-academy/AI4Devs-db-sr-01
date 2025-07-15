## Initial Prompt

## Meta Prompt: Database Engineer (SQL, PostgreSQL, Prisma)

You are a senior database engineer with deep expertise in **SQL**, **PostgreSQL**, and **Prisma**. Your task consists of the following steps:

### ✅ Input:
- You will receive an **Entity Relationship Diagram (ERD)** written in **Mermaid format**.

### 🔧 Task Workflow:

1. **ERD to SQL Conversion**:
   - Parse the Mermaid ERD and convert it into a normalized SQL schema compatible with **PostgreSQL**.
   - Ensure the schema follows relational database best practices.

2. **Best Practices Review**:
   - Verify the schema meets the following criteria:
     - ✅ **Normalized**: Apply normal forms (ideally up to 3NF) to reduce redundancy and maintain data integrity.
     - ✅ **Scalable**: Able to handle increased data volume and query complexity without performance degradation.
     - ✅ **Maintainable**: Easy to read, modify, and extend as business requirements evolve.
   - Add **indexes** only where needed to optimize read/query performance.

3. **Prisma Migration Strategy**:
   - Compare the generated SQL schema with the existing Prisma schema (i.e., the current state of the database).
   - Generate **Prisma migration files** to evolve the current schema to the improved version.
   - Ensure all migrations:
     - Are **clean** and **idempotent**.
     - Align with **Prisma’s best practices** for database schema evolution.
     - Reflect all structural improvements introduced during normalization and review.

### 📤 Output:
- ✅ SQL script representing the final, reviewed schema.
- ✅ Prisma migration steps (`schema.prisma` diff + migration SQL).
- ✅ Short written rationale highlighting major changes:
  - Normalization decisions.
  - Index additions.
  - Entity or field renaming.
  - Justifications for any deviations from the input ERD.

### ⚠️ Constraints:
- Do **not** overengineer the schema: avoid unnecessary abstractions or premature optimizations.
- Stay fully compatible with PostgreSQL’s native features and datatypes.
- Any intentional changes from the original ERD must be **explicitly justified**.


## Prompt 2

Add an extra step into @MIGRATION_INSTRUCTIONS.md about how to use PGAdmin to check the current migration

## Prompt 3

> With the generated information, we will go step by step to verify that all the generated steps have been successful.  
> We can use the terminal to connect to PostgreSQL via Docker in order to test the created migrations,  
> as well as run some queries using the data that we will populate through the seed script.

## Prompt 4

# 🎯 SQL Query Generator Prompt - LTI Recruitment System

## 📋 System Context

You are an expert in PostgreSQL and database design. Your task is to generate optimized SQL queries for the **LTI Recruitment System**, a complete management system for candidates, companies, job positions, interview processes, and applications.

## 🏗️ Complete Database Structure

### 📊 Tables Schema and Relationships

```sql
-- ============================================
-- MAIN ENTITIES
-- ============================================

-- Candidates (People who apply for jobs)
candidates (
    id SERIAL PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Candidate education (1:N with candidates)
educations (
    id SERIAL PRIMARY KEY,
    institution VARCHAR(100) NOT NULL,
    title VARCHAR(250) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    candidate_id INTEGER REFERENCES candidates(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Candidate work experience (1:N with candidates)
work_experiences (
    id SERIAL PRIMARY KEY,
    company VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    description VARCHAR(200),
    start_date DATE NOT NULL,
    end_date DATE,
    candidate_id INTEGER REFERENCES candidates(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Candidate resumes/CVs (1:N with candidates)
resumes (
    id SERIAL PRIMARY KEY,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    upload_date TIMESTAMP NOT NULL,
    candidate_id INTEGER REFERENCES candidates(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Companies that publish jobs
companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Company employees (1:N with companies)
employees (
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES companies(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(company_id, email)
);

-- Available interview types
interview_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Interview flows (process templates)
interview_flows (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Specific steps in an interview flow (1:N with interview_flows)
interview_steps (
    id SERIAL PRIMARY KEY,
    interview_flow_id INTEGER REFERENCES interview_flows(id) ON DELETE CASCADE,
    interview_type_id INTEGER REFERENCES interview_types(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(interview_flow_id, order_index),
    UNIQUE(interview_flow_id, name)
);

-- Published job positions
positions (
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES companies(id) ON DELETE CASCADE,
    interview_flow_id INTEGER REFERENCES interview_flows(id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'ACTIVE' CHECK (status IN ('DRAFT', 'ACTIVE', 'CLOSED', 'CANCELLED')),
    is_visible BOOLEAN DEFAULT true,
    location VARCHAR(255),
    job_description TEXT,
    requirements TEXT,
    responsibilities TEXT,
    salary_min DECIMAL(12,2),
    salary_max DECIMAL(12,2),
    employment_type VARCHAR(50) CHECK (employment_type IN ('FULL_TIME', 'PART_TIME', 'CONTRACT', 'INTERNSHIP', 'FREELANCE')),
    benefits TEXT,
    company_description TEXT,
    application_deadline DATE,
    contact_info VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Candidate applications to positions (N:M between candidates and positions)
applications (
    id SERIAL PRIMARY KEY,
    position_id INTEGER REFERENCES positions(id) ON DELETE CASCADE,
    candidate_id INTEGER REFERENCES candidates(id) ON DELETE CASCADE,
    application_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(50) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'REVIEWING', 'INTERVIEWING', 'OFFERED', 'ACCEPTED', 'REJECTED', 'WITHDRAWN')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(position_id, candidate_id)
);

-- Individual interviews conducted
interviews (
    id SERIAL PRIMARY KEY,
    application_id INTEGER REFERENCES applications(id) ON DELETE CASCADE,
    interview_step_id INTEGER REFERENCES interview_steps(id) ON DELETE RESTRICT,
    employee_id INTEGER REFERENCES employees(id) ON DELETE RESTRICT,
    interview_date TIMESTAMP NOT NULL,
    result VARCHAR(50) CHECK (result IN ('PENDING', 'PASS', 'FAIL', 'NO_SHOW', 'CANCELLED')),
    score INTEGER CHECK (score >= 1 AND score <= 10),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 📊 Main Indexes for Optimization

```sql
-- Indexes on employees
CREATE INDEX idx_employees_company_id ON employees(company_id);
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_employees_is_active ON employees(is_active);

-- Indexes on positions
CREATE INDEX idx_positions_company_id ON positions(company_id);
CREATE INDEX idx_positions_status ON positions(status);
CREATE INDEX idx_positions_is_visible ON positions(is_visible);
CREATE INDEX idx_positions_deadline ON positions(application_deadline);

-- Indexes on applications
CREATE INDEX idx_applications_position_id ON applications(position_id);
CREATE INDEX idx_applications_candidate_id ON applications(candidate_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_date ON applications(application_date);

-- Indexes on interviews
CREATE INDEX idx_interviews_application_id ON interviews(application_id);
CREATE INDEX idx_interviews_date ON interviews(interview_date);
CREATE INDEX idx_interviews_result ON interviews(result);
```

## 🎯 Instructions for Generating Queries

### Complexity Levels

**🟢 BASIC (Level 1):**
- Single table queries
- Simple WHERE filters
- Basic sorting
- Simple aggregations (COUNT, SUM, AVG)

**🟡 INTERMEDIATE (Level 2):**
- JOINs between 2-3 tables
- Simple subqueries
- GROUP BY with HAVING
- Date and string functions
- CASE WHEN for conditional logic

**🔴 ADVANCED (Level 3):**
- Complex JOINs between 4+ tables
- Correlated subqueries
- CTEs (Common Table Expressions)
- Window Functions
- Performance analysis and complex metrics

**🟣 EXPERT (Level 4):**
- Multiple nested CTEs
- Advanced Window Functions
- Cohort analysis
- Optimization and executive reporting queries
- Business intelligence queries

### 📐 Optimization Considerations

1. **Index Usage:** Always consider available indexes
2. **LIMIT and Pagination:** For queries that may return many records
3. **JOIN Efficiency:** Use INNER JOIN when possible, LEFT JOIN only when necessary
4. **WHERE Clauses:** Place most selective conditions first
5. **Avoid SELECT \*:** Specify only necessary columns
6. **Date Ranges:** Use efficient date ranges
7. **Aggregations:** Use HAVING to filter after GROUP BY

### 📝 Required Response Format

```markdown
## 🎯 [Descriptive Query Title]

**Level:** [BASIC/INTERMEDIATE/ADVANCED/EXPERT]  
**Purpose:** [Clear description of the objective]  
**Tables Involved:** [List of tables]

### SQL Query
\`\`\`sql
-- Explanatory comment for the query
[SQL QUERY HERE]
\`\`\`

### 💡 Applied Optimizations
- [List of optimizations used]

### 📊 Expected Result
[Description of the type of data returned]

### 🔍 Use Cases
- [Scenarios where this query would be useful]
```

## 🎯 Examples of Query Types to Generate

### Query Categories

1. **👥 Candidate Management**
   - Candidate search and filtering
   - Educational and work history
   - Experience analysis

2. **🏢 Company Analysis**
   - Performance by company
   - Active/inactive employees
   - Role distribution

3. **💼 Position Management**
   - Active positions by company
   - Salary analysis
   - Positions with most applications

4. **📝 Application Process**
   - Application status
   - Average process time
   - Conversion rate

5. **🎤 Interview Analysis**
   - Results by interview type
   - Interviewer performance
   - Average scores

6. **📊 Metrics and KPIs**
   - Recruitment funnel
   - Time to hire
   - Trend analysis

7. **🔍 Executive Reports**
   - Recruitment dashboard
   - Cohort analysis
   - Predictions and trends

## 🚀 Final Instructions

When generating a query:

1. **Clearly specify the complexity level**
2. **Include explanatory comments in the SQL**
3. **Explain the optimizations used**
4. **Provide real-world usage context**
5. **Ensure the query is executable**
6. **Use exact column and table names from the schema**
7. **Consider edge cases (null data, empty records)**

What type of query would you like me to generate? You can specify:
- **Complexity level** (Basic/Intermediate/Advanced/Expert)
- **Category** (Candidates/Companies/Positions/Applications/Interviews/Metrics/Reports)
- **Specific objective** (e.g., "find candidates with more than 5 years of JavaScript experience") 


## Prompt 5
# 📚 Generated Query Examples - LTI System

## 🎯 Active Candidates with Development Experience

**Level:** BASIC  
**Purpose:** Find candidates who have experience as developers  
**Tables Involved:** candidates, work_experiences

### SQL Query
```sql
-- Get candidates with development experience
SELECT DISTINCT 
    c.id,
    c."firstName" || ' ' || c."lastName" as full_name,
    c.email,
    c.phone,
    c.address
FROM candidates c
INNER JOIN work_experiences we ON c.id = we.candidate_id
WHERE LOWER(we.position) LIKE '%developer%' 
   OR LOWER(we.position) LIKE '%programmer%'
   OR LOWER(we.position) LIKE '%software engineer%'
ORDER BY c."lastName", c."firstName"
LIMIT 50;
```

### 💡 Applied Optimizations
- Use of INNER JOIN to avoid candidates without experience
- DISTINCT to avoid duplicates from multiple experiences
- LIMIT to control result volume
- Index on candidate_id improves JOIN performance

### 📊 Expected Result
List of unique candidates with development experience, showing basic contact information

### 🔍 Use Cases
- Quick search for developers for technical positions
- First phase of filtering in recruitment processes
- Identification of technical talent in the database

---

## 🎯 Recruitment Dashboard by Company

**Level:** INTERMEDIATE  
**Purpose:** Generate key recruitment metrics by company  
**Tables Involved:** companies, positions, applications, candidates

### SQL Query
```sql
-- Recruitment metrics dashboard by company
SELECT 
    c.name as company,
    COUNT(DISTINCT p.id) as total_positions,
    COUNT(DISTINCT CASE WHEN p.status = 'ACTIVE' THEN p.id END) as active_positions,
    COUNT(DISTINCT a.id) as total_applications,
    COUNT(DISTINCT a.candidate_id) as unique_candidates,
    COUNT(DISTINCT CASE WHEN a.status = 'ACCEPTED' THEN a.id END) as hires,
    ROUND(
        COUNT(DISTINCT CASE WHEN a.status = 'ACCEPTED' THEN a.id END) * 100.0 / 
        NULLIF(COUNT(DISTINCT a.id), 0), 2
    ) as hire_rate_pct,
    AVG(CASE WHEN p.salary_min IS NOT NULL AND p.salary_max IS NOT NULL 
            THEN (p.salary_min + p.salary_max) / 2 END) as average_salary
FROM companies c
LEFT JOIN positions p ON c.id = p.company_id
LEFT JOIN applications a ON p.id = a.position_id
WHERE c.created_at >= '2024-01-01'
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT p.id) > 0
ORDER BY total_applications DESC, hire_rate_pct DESC;
```

### 💡 Applied Optimizations
- LEFT JOINs to include companies without positions/applications
- CASE WHEN for conditional aggregations
- NULLIF to avoid division by zero
- Date filter in WHERE to improve performance
- HAVING to filter groups after aggregation

### 📊 Expected Result
Executive summary with key metrics by company: positions, applications, hire rate and salaries

### 🔍 Use Cases
- Monthly/quarterly executive reports
- Client company performance evaluation
- Identification of companies with best hire rates

---

## 🎯 Complete Recruitment Funnel Analysis

**Level:** ADVANCED  
**Purpose:** Analyze the complete funnel from application to hire with temporal metrics  
**Tables Involved:** positions, applications, interviews, interview_steps, interview_types, candidates

### SQL Query
```sql
-- Complete recruitment funnel analysis with temporal metrics
WITH funnel_base AS (
    SELECT 
        p.id as position_id,
        p.title as position,
        a.id as application_id,
        a.status as application_status,
        a.application_date,
        c."firstName" || ' ' || c."lastName" as candidate,
        -- Calculate days since application
        CURRENT_DATE - a.application_date as days_since_application
    FROM positions p
    LEFT JOIN applications a ON p.id = a.position_id
    LEFT JOIN candidates c ON a.candidate_id = c.id
    WHERE p.created_at >= '2024-01-01'
),
interview_metrics AS (
    SELECT 
        a.id as application_id,
        COUNT(i.id) as total_interviews,
        COUNT(CASE WHEN i.result = 'PASS' THEN 1 END) as passed_interviews,
        COUNT(CASE WHEN i.result = 'FAIL' THEN 1 END) as failed_interviews,
        AVG(i.score) as average_score,
        MIN(i.interview_date) as first_interview,
        MAX(i.interview_date) as last_interview,
        -- Total interview process time
        EXTRACT(DAYS FROM MAX(i.interview_date) - MIN(i.interview_date)) as process_duration_days
    FROM applications a
    LEFT JOIN interviews i ON a.id = i.application_id
    GROUP BY a.id
),
position_summary AS (
    SELECT 
        fb.position_id,
        fb.position,
        COUNT(fb.application_id) as total_applications,
        COUNT(CASE WHEN fb.application_status = 'PENDING' THEN 1 END) as pending,
        COUNT(CASE WHEN fb.application_status = 'REVIEWING' THEN 1 END) as reviewing,
        COUNT(CASE WHEN fb.application_status = 'INTERVIEWING' THEN 1 END) as interviewing,
        COUNT(CASE WHEN fb.application_status = 'OFFERED' THEN 1 END) as offers_made,
        COUNT(CASE WHEN fb.application_status = 'ACCEPTED' THEN 1 END) as hires,
        COUNT(CASE WHEN fb.application_status = 'REJECTED' THEN 1 END) as rejected,
        -- Temporal metrics
        AVG(fb.days_since_application) as avg_days_process,
        AVG(im.process_duration_days) as avg_interview_duration,
        AVG(im.average_score) as avg_position_score
    FROM funnel_base fb
    LEFT JOIN interview_metrics im ON fb.application_id = im.application_id
    WHERE fb.application_id IS NOT NULL
    GROUP BY fb.position_id, fb.position
)
SELECT 
    position,
    total_applications,
    pending,
    reviewing,
    interviewing,
    offers_made,
    hires,
    rejected,
    -- Calculate conversion rates
    ROUND(hires * 100.0 / NULLIF(total_applications, 0), 2) as hire_rate_pct,
    ROUND(offers_made * 100.0 / NULLIF(total_applications, 0), 2) as offer_rate_pct,
    ROUND(avg_days_process, 1) as avg_process_days,
    ROUND(avg_interview_duration, 1) as avg_interview_days,
    ROUND(avg_position_score, 2) as avg_score
FROM position_summary
WHERE total_applications >= 5  -- Only positions with sufficient applications
ORDER BY total_applications DESC, hire_rate_pct DESC;
```

### 💡 Applied Optimizations
- CTEs to organize complex logic into manageable steps
- LEFT JOINs to preserve all applications
- Conditional aggregations with CASE WHEN
- Date functions for temporal calculations
- HAVING filters for statistically relevant analysis
- NULLIF to avoid division errors

### 📊 Expected Result
Complete recruitment funnel analysis with conversion rates, process times and quality metrics

### 🔍 Use Cases
- Recruitment process optimization
- Bottleneck identification
- Managerial efficiency reports
- Recruitment ROI analysis

---

## 🎯 Predictive Analysis of Candidate Success

**Level:** EXPERT  
**Purpose:** Identify patterns of successful candidates using cohort analysis and window functions  
**Tables Involved:** All system tables

### SQL Query
```sql
-- Advanced predictive analysis of candidate success
WITH complete_candidates AS (
    SELECT 
        c.id as candidate_id,
        c."firstName" || ' ' || c."lastName" as name,
        c.email,
        -- Educational metrics
        COUNT(DISTINCT e.id) as num_educations,
        MAX(e.end_date) as most_recent_education,
        STRING_AGG(DISTINCT e.institution, ', ' ORDER BY e.end_date DESC) as institutions,
        -- Work metrics
        COUNT(DISTINCT we.id) as num_previous_jobs,
        AVG(EXTRACT(DAYS FROM COALESCE(we.end_date, CURRENT_DATE) - we.start_date) / 365.0) as avg_job_duration_years,
        MAX(we.end_date) as last_job,
        STRING_AGG(DISTINCT we.company, ', ' ORDER BY we.start_date DESC) as previous_companies,
        -- Total experience in years
        SUM(EXTRACT(DAYS FROM COALESCE(we.end_date, CURRENT_DATE) - we.start_date) / 365.0) as total_experience_years
    FROM candidates c
    LEFT JOIN educations e ON c.id = e.candidate_id
    LEFT JOIN work_experiences we ON c.id = we.candidate_id
    GROUP BY c.id, c."firstName", c."lastName", c.email
),
application_metrics AS (
    SELECT 
        cc.candidate_id,
        COUNT(a.id) as total_applications,
        COUNT(CASE WHEN a.status = 'ACCEPTED' THEN 1 END) as successful_applications,
        COUNT(CASE WHEN a.status = 'REJECTED' THEN 1 END) as rejected_applications,
        AVG(CASE WHEN a.status = 'ACCEPTED' 
                 THEN EXTRACT(DAYS FROM a.updated_at - a.application_date) 
                 END) as avg_hire_days,
        -- Window function for ranking
        ROW_NUMBER() OVER (ORDER BY COUNT(CASE WHEN a.status = 'ACCEPTED' THEN 1 END) DESC) as success_ranking
    FROM complete_candidates cc
    LEFT JOIN applications a ON cc.candidate_id = a.candidate_id
    GROUP BY cc.candidate_id
),
interview_performance AS (
    SELECT 
        a.candidate_id,
        COUNT(i.id) as total_interviews,
        AVG(i.score) as avg_interview_score,
        COUNT(CASE WHEN i.result = 'PASS' THEN 1 END) as passed_interviews,
        -- Analysis by interview type
        AVG(CASE WHEN it.name = 'Technical' THEN i.score END) as avg_technical_score,
        AVG(CASE WHEN it.name = 'Behavioral' THEN i.score END) as avg_behavioral_score,
        -- Performance percentile
        PERCENT_RANK() OVER (ORDER BY AVG(i.score)) as performance_percentile
    FROM applications a
    LEFT JOIN interviews i ON a.id = i.application_id
    LEFT JOIN interview_steps ist ON i.interview_step_id = ist.id
    LEFT JOIN interview_types it ON ist.interview_type_id = it.id
    GROUP BY a.candidate_id
),
final_analysis AS (
    SELECT 
        cc.candidate_id,
        cc.name,
        cc.email,
        -- Profile metrics
        cc.num_educations,
        cc.num_previous_jobs,
        ROUND(cc.total_experience_years, 2) as experience_years,
        ROUND(cc.avg_job_duration_years, 2) as job_stability_years,
        -- Performance metrics
        am.total_applications,
        am.successful_applications,
        ROUND(am.successful_applications * 100.0 / NULLIF(am.total_applications, 0), 2) as success_rate_pct,
        ip.total_interviews,
        ROUND(ip.avg_interview_score, 2) as avg_score,
        ROUND(ip.avg_technical_score, 2) as technical_score,
        ROUND(ip.avg_behavioral_score, 2) as behavioral_score,
        ROUND(ip.performance_percentile * 100, 1) as performance_percentile,
        -- Candidate classification
        CASE 
            WHEN am.successful_applications >= 2 AND ip.avg_interview_score >= 8.0 THEN 'TOP_PERFORMER'
            WHEN am.successful_applications >= 1 AND ip.avg_interview_score >= 7.0 THEN 'HIGH_POTENTIAL'
            WHEN am.total_applications >= 3 AND ip.avg_interview_score >= 6.0 THEN 'CONSISTENT'
            WHEN am.total_applications >= 1 THEN 'DEVELOPING'
            ELSE 'NEW_CANDIDATE'
        END as candidate_category,
        -- Composite predictive score
        ROUND(
            (COALESCE(cc.total_experience_years, 0) * 0.3) +
            (COALESCE(ip.avg_interview_score, 5) * 0.4) +
            (COALESCE(am.success_rate_pct, 0) * 0.2) +
            (COALESCE(cc.num_educations, 0) * 0.1), 2
        ) as predictive_score
    FROM complete_candidates cc
    LEFT JOIN application_metrics am ON cc.candidate_id = am.candidate_id
    LEFT JOIN interview_performance ip ON cc.candidate_id = ip.candidate_id
)
SELECT 
    name,
    email,
    candidate_category,
    experience_years,
    job_stability_years,
    total_applications,
    successful_applications,
    success_rate_pct,
    avg_score,
    technical_score,
    behavioral_score,
    performance_percentile,
    predictive_score,
    -- Final ranking
    RANK() OVER (ORDER BY predictive_score DESC) as overall_ranking
FROM final_analysis
WHERE total_applications > 0  -- Only candidates with at least one application
ORDER BY predictive_score DESC, success_rate_pct DESC
LIMIT 100;
```

### 💡 Applied Optimizations
- Multiple CTEs for modular organization
- Window functions (ROW_NUMBER, PERCENT_RANK, RANK) for positional analysis
- Complex conditional aggregations
- STRING_AGG for data consolidation
- CASE WHEN for categorical classification
- Customizable weighted scoring algorithm
- LIMIT to control result volume

### 📊 Expected Result
Candidate rankings with predictive scores, categorical classifications and detailed performance metrics

### 🔍 Use Cases
- Proactive identification of high-potential candidates
- Sourcing strategy optimization
- ROI analysis on different candidate profiles
- Machine learning feature engineering
- C-level talent intelligence reports

---

## 🚀 How to Use the Prompt

1. **Copy the content from the `DATABASE_QUERY_GENERATOR_PROMPT.md` file**
2. **Paste it into ChatGPT, Claude, or your favorite LLM**
3. **Specify your need:** 
   - Level: Basic/Intermediate/Advanced/Expert
   - Category: Candidates/Companies/Positions/etc.
   - Specific objective

### Example Requests:

```
"Generate an INTERMEDIATE level query to analyze positions with highest demand by geographic location"

"I need an ADVANCED query that shows interviewer performance and their impact on hires"

"Create an EXPERT query to predict which candidates are most likely to succeed based on historical patterns"
```

The prompt is designed to generate 100% optimized and executable queries! 🎯 