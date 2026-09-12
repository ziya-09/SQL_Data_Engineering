
use data_jobs;
-- SUBQUERY AND CTE

-- Subquery: A subquery is a query nested inside another query. It can be used in SELECT, FROM, or WHERE clauses to filter or compute values based on the results of another query.

SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
    ) AS market_median_salary
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

--Determine the remote median salary per job
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS remote_jobs
GROUP BY job_title_short
LIMIT 10;


--Median salary is above median salary for remote jobs
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS remote_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
LIMIT 10;



-- CTE: A Common Table Expression (CTE) is a temporary result set that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement. It is defined using the WITH clause and can improve query readability and organization.

WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States' 
    GROUP BY job_title_short, job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary as remote_median_salary, 
    o.median_salary onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;



SELECT *
FROM job_postings_fact as tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM skills_job_dim as src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;

