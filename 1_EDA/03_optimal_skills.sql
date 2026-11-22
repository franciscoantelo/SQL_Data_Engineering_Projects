SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING COUNT(jpf.*) > 100
ORDER BY median_salary DESC
limit 25;

-- Using natural log to balance the weight between median_salary and demand_count

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    (MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*))) / 1_000_000 AS optimal_score
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY 
    optimal_score DESC
limit 25;

/*
┌────────────┬───────────────┬──────────────┬─────────────────┬────────────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │   optimal_score    │
│  varchar   │    double     │    int64     │     double      │       double       │
├────────────┼───────────────┼──────────────┼─────────────────┼────────────────────┤
│ terraform  │      184000.0 │          193 │             5.3 │ 0.9683349947584989 │
│ python     │      135000.0 │         1133 │             7.0 │ 0.9494042752387809 │
│ aws        │      137320.0 │          783 │             6.7 │ 0.9149834640424246 │
│ sql        │      130000.0 │         1128 │             7.0 │ 0.9136661861675406 │
│ airflow    │      150000.0 │          386 │             6.0 │ 0.8933756054197246 │
│ spark      │      140000.0 │          503 │             6.2 │ 0.8708826238139635 │
│ snowflake  │      135500.0 │          438 │             6.1 │ 0.8241406623560085 │
│ kafka      │      145000.0 │          292 │             5.7 │ 0.8231293013289008 │
│ azure      │      128000.0 │          475 │             6.2 │ 0.7889042949164341 │
│ java       │      135000.0 │          303 │             5.7 │ 0.7713539287437647 │
│ scala      │      137290.0 │          247 │             5.5 │ 0.7563865933456305 │
│ kubernetes │      150500.0 │          147 │             5.0 │ 0.7510601043101998 │
│ git        │      140000.0 │          208 │             5.3 │ 0.7472553311581844 │
│ databricks │      132750.0 │          266 │             5.6 │ 0.7412091349907706 │
│ redshift   │      130000.0 │          274 │             5.6 │ 0.7297066538304492 │
│ gcp        │      136000.0 │          196 │             5.3 │ 0.7178235936553503 │
│ hadoop     │      135000.0 │          198 │             5.3 │ 0.7139160491437622 │
│ nosql      │      134415.0 │          193 │             5.3 │ 0.7073845017416501 │
│ pyspark    │      140000.0 │          152 │             5.0 │ 0.7033432729184788 │
│ docker     │      135000.0 │          144 │             5.0 │ 0.6709247954427601 │
│ mongodb    │      135750.0 │          136 │             4.9 │ 0.6668929007386691 │
│ go         │      140000.0 │          113 │             4.7 │ 0.6618342946197278 │
│ r          │      134775.0 │          133 │             4.9 │ 0.6590968037560868 │
│ github     │      135000.0 │          127 │             4.8 │ 0.6539652566719099 │
│ bigquery   │      135000.0 │          123 │             4.8 │ 0.6496448879752763 │
└────────────┴───────────────┴──────────────┴─────────────────┴────────────────────┘
  25 rows                                                                5 columns
*/