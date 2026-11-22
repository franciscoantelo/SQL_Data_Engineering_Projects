SELECT *
FROM job_postings_fact
LIMIT 5;

DESCRIBE job_postings_fact;



SELECT job_id
FROM skills_job_dim
ORDER BY job_id
LIMIT 20;

SELECT job_id
FROM job_postings_fact
ORDER BY job_id
LIMIT 20

-- git test