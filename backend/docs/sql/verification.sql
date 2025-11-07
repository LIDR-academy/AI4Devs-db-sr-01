-- ============================================================================
-- ATS Database Verification Queries
-- Use these queries to verify the database structure and data integrity
-- ============================================================================

-- ============================================================================
-- 1. List visible positions by company with salary range and application count
-- ============================================================================
SELECT 
    c.name AS company_name,
    p.title AS position_title,
    p.status,
    p.location,
    p.salary_min,
    p.salary_max,
    p.employment_type,
    COUNT(a.id) AS application_count
FROM 
    position p
    INNER JOIN company c ON p.company_id = c.id
    LEFT JOIN application a ON p.id = a.position_id
WHERE 
    p.is_visible = true
    AND p.status = 'open'
GROUP BY 
    c.id, c.name, p.id, p.title, p.status, p.location, p.salary_min, p.salary_max, p.employment_type
ORDER BY 
    c.name, p.title;

-- ============================================================================
-- 2. Get interview flow for a position with ordered steps
-- ============================================================================
SELECT 
    p.title AS position_title,
    p.id AS position_id,
    if.description AS flow_description,
    ist.name AS step_name,
    ist.order_index,
    it.name AS interview_type,
    it.description AS type_description
FROM 
    position p
    INNER JOIN interview_flow if ON p.interview_flow_id = if.id
    INNER JOIN interview_step ist ON if.id = ist.interview_flow_id
    INNER JOIN interview_type it ON ist.interview_type_id = it.id
WHERE 
    p.id = 1  -- Replace with actual position_id
ORDER BY 
    ist.order_index;

-- ============================================================================
-- 3. Get applications for a candidate with status and dates
-- ============================================================================
SELECT 
    c.first_name || ' ' || c.last_name AS candidate_name,
    c.email AS candidate_email,
    a.id AS application_id,
    a.application_date,
    a.status AS application_status,
    a.notes AS application_notes,
    p.title AS position_title,
    co.name AS company_name,
    p.location,
    p.status AS position_status
FROM 
    application a
    INNER JOIN candidate c ON a.candidate_id = c.id
    INNER JOIN position p ON a.position_id = p.id
    INNER JOIN company co ON p.company_id = co.id
WHERE 
    c.id = 1  -- Replace with actual candidate_id
ORDER BY 
    a.application_date DESC;

-- ============================================================================
-- 4. Get interviews conducted by an employee with step and score
-- ============================================================================
SELECT 
    e.name AS employee_name,
    e.email AS employee_email,
    e.role,
    i.id AS interview_id,
    i.interview_date,
    i.result,
    i.score,
    i.notes,
    ist.name AS step_name,
    ist.order_index,
    it.name AS interview_type,
    c.first_name || ' ' || c.last_name AS candidate_name,
    p.title AS position_title,
    a.status AS application_status
FROM 
    interview i
    INNER JOIN employee e ON i.employee_id = e.id
    INNER JOIN interview_step ist ON i.interview_step_id = ist.id
    INNER JOIN interview_type it ON ist.interview_type_id = it.id
    INNER JOIN application a ON i.application_id = a.id
    INNER JOIN candidate c ON a.candidate_id = c.id
    INNER JOIN position p ON a.position_id = p.id
WHERE 
    e.id = 1  -- Replace with actual employee_id
ORDER BY 
    i.interview_date DESC, ist.order_index;

-- ============================================================================
-- 5. Get complete application pipeline for a position
-- ============================================================================
SELECT 
    p.title AS position_title,
    co.name AS company_name,
    c.first_name || ' ' || c.last_name AS candidate_name,
    c.email AS candidate_email,
    a.id AS application_id,
    a.application_date,
    a.status AS application_status,
    COUNT(DISTINCT i.id) AS interviews_completed,
    COUNT(DISTINCT ist.id) AS total_steps,
    MAX(i.score) AS highest_score,
    MAX(i.interview_date) AS last_interview_date
FROM 
    position p
    INNER JOIN company co ON p.company_id = co.id
    INNER JOIN application a ON p.id = a.position_id
    INNER JOIN candidate c ON a.candidate_id = c.id
    LEFT JOIN interview i ON a.id = i.application_id
    LEFT JOIN interview_flow if ON p.interview_flow_id = if.id
    LEFT JOIN interview_step ist ON if.id = ist.interview_flow_id
WHERE 
    p.id = 1  -- Replace with actual position_id
GROUP BY 
    p.id, p.title, co.name, c.id, c.first_name, c.last_name, c.email, a.id, a.application_date, a.status
ORDER BY 
    a.application_date DESC;

-- ============================================================================
-- 6. Get interview statistics by type
-- ============================================================================
SELECT 
    it.name AS interview_type,
    COUNT(i.id) AS total_interviews,
    COUNT(CASE WHEN i.result = 'passed' THEN 1 END) AS passed_count,
    COUNT(CASE WHEN i.result = 'failed' THEN 1 END) AS failed_count,
    COUNT(CASE WHEN i.result = 'pending' THEN 1 END) AS pending_count,
    ROUND(AVG(i.score), 2) AS average_score,
    MAX(i.score) AS max_score,
    MIN(i.score) AS min_score
FROM 
    interview_type it
    LEFT JOIN interview_step ist ON it.id = ist.interview_type_id
    LEFT JOIN interview i ON ist.id = i.interview_step_id
GROUP BY 
    it.id, it.name
ORDER BY 
    total_interviews DESC;

-- ============================================================================
-- 7. Get candidates with multiple applications
-- ============================================================================
SELECT 
    c.id AS candidate_id,
    c.first_name || ' ' || c.last_name AS candidate_name,
    c.email,
    COUNT(a.id) AS application_count,
    COUNT(CASE WHEN a.status = 'offered' THEN 1 END) AS offers_received,
    COUNT(CASE WHEN a.status = 'interviewing' THEN 1 END) AS active_interviews,
    MAX(a.application_date) AS last_application_date
FROM 
    candidate c
    INNER JOIN application a ON c.id = a.candidate_id
GROUP BY 
    c.id, c.first_name, c.last_name, c.email
HAVING 
    COUNT(a.id) > 1
ORDER BY 
    application_count DESC;

-- ============================================================================
-- 8. Verify data integrity: Check for orphaned records
-- ============================================================================
-- Check for applications without valid position
SELECT 'Applications with invalid position_id' AS check_type, COUNT(*) AS count
FROM application a
LEFT JOIN position p ON a.position_id = p.id
WHERE p.id IS NULL

UNION ALL

-- Check for applications without valid candidate
SELECT 'Applications with invalid candidate_id' AS check_type, COUNT(*) AS count
FROM application a
LEFT JOIN candidate c ON a.candidate_id = c.id
WHERE c.id IS NULL

UNION ALL

-- Check for interviews without valid application
SELECT 'Interviews with invalid application_id' AS check_type, COUNT(*) AS count
FROM interview i
LEFT JOIN application a ON i.application_id = a.id
WHERE a.id IS NULL

UNION ALL

-- Check for interviews without valid employee
SELECT 'Interviews with invalid employee_id' AS check_type, COUNT(*) AS count
FROM interview i
LEFT JOIN employee e ON i.employee_id = e.id
WHERE e.id IS NULL

UNION ALL

-- Check for positions without valid company
SELECT 'Positions with invalid company_id' AS check_type, COUNT(*) AS count
FROM position p
LEFT JOIN company c ON p.company_id = c.id
WHERE c.id IS NULL;

-- ============================================================================
-- 9. Get employee workload (interviews scheduled)
-- ============================================================================
SELECT 
    e.name AS employee_name,
    e.email,
    e.role,
    co.name AS company_name,
    COUNT(i.id) AS total_interviews,
    COUNT(CASE WHEN i.interview_date >= CURRENT_DATE THEN 1 END) AS upcoming_interviews,
    COUNT(CASE WHEN i.interview_date < CURRENT_DATE AND i.result IS NULL THEN 1 END) AS pending_results,
    ROUND(AVG(i.score), 2) AS average_score_given
FROM 
    employee e
    INNER JOIN company co ON e.company_id = co.id
    LEFT JOIN interview i ON e.id = i.employee_id
WHERE 
    e.is_active = true
GROUP BY 
    e.id, e.name, e.email, e.role, co.name
ORDER BY 
    total_interviews DESC;

-- ============================================================================
-- 10. Get position application funnel
-- ============================================================================
SELECT 
    p.title AS position_title,
    co.name AS company_name,
    COUNT(DISTINCT a.id) AS total_applications,
    COUNT(DISTINCT CASE WHEN a.status = 'pending' THEN a.id END) AS pending,
    COUNT(DISTINCT CASE WHEN a.status = 'reviewing' THEN a.id END) AS reviewing,
    COUNT(DISTINCT CASE WHEN a.status = 'interviewing' THEN a.id END) AS interviewing,
    COUNT(DISTINCT CASE WHEN a.status = 'offered' THEN a.id END) AS offered,
    COUNT(DISTINCT CASE WHEN a.status = 'rejected' THEN a.id END) AS rejected,
    ROUND(
        COUNT(DISTINCT CASE WHEN a.status = 'offered' THEN a.id END)::NUMERIC / 
        NULLIF(COUNT(DISTINCT a.id), 0) * 100, 
        2
    ) AS offer_rate_percent
FROM 
    position p
    INNER JOIN company co ON p.company_id = co.id
    LEFT JOIN application a ON p.id = a.position_id
WHERE 
    p.is_visible = true
GROUP BY 
    p.id, p.title, co.name
ORDER BY 
    total_applications DESC;

