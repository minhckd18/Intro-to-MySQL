-- 1/ The PADS
SELECT CONCAT(Name, '(', SUBSTR(Occupation,1,1), ')') FROM OCCUPATIONS
ORDER BY Name;
SELECT CONCAT('There are a total of ', COUNT(Occupation), ' ', LOWER(Occupation), 's.') 
FROM OCCUPATIONS 
GROUP BY Occupation 
ORDER BY COUNT(Occupation), Occupation ASC;

-- 2/ New companies
SELECT  c.company_code, 
        c.founder, 
        COUNT(DISTINCT lm.lead_manager_code), 
        COUNT(DISTINCT sm.senior_manager_code), 
        COUNT(DISTINCT m.manager_code), 
        COUNT(DISTINCT e.employee_code) 
FROM Company c, Lead_Manager lm, Senior_Manager sm, Manager m, Employee e
WHERE c.company_code = lm.company_code 
AND lm.lead_manager_code = sm.lead_manager_code 
AND sm.senior_manager_code = m.senior_manager_code 
AND m.manager_code = e.manager_code 
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;

-- 3/ Weather observation 18
SELECT ROUND(
    ABS(MIN(LAT_N) - MAX(LAT_N)) + 
    ABS(MIN(LONG_W) - MAX(LONG_W))
    , 4)
FROM STATION;

-- 4/ Weather observation 19
SELECT ROUND(
    SQRT(
        POWER(MIN(LAT_N) - MAX(LAT_N), 2) + 
        POWER(MIN(LONG_W) - MAX(LONG_W),2))
    , 4)
FROM STATION;

-- 5/ Top competitors
SELECT H.hacker_id, H.name FROM hackers H
JOIN submissions S
ON H.hacker_id = S.hacker_id
JOIN challenges C
ON S.challenge_id = C.challenge_id
JOIN difficulty D
ON C.difficulty_level = D.difficulty_level
AND S.score = D.score
GROUP BY H.hacker_id, H.name
HAVING COUNT(H.hacker_id) > 1
ORDER BY COUNT(H.hacker_id) DESC, H.hacker_id;

-- 6/ Ollivander's inventory
SELECT W.id, P.age, W.coins_needed, W.power FROM wands W
JOIN wands_property P
ON W.code = P.code
WHERE P.is_evil = 0
AND W.coins_needed = 
    (
        SELECT MIN(a.coins_needed) 
        FROM wands a
        JOIN wands_property b
        ON a.code = b.code
        WHERE b.age = P.age AND a.power = W.power
    )
ORDER BY W.power DESC, P.age DESC;

-- 7/ Challenges
SELECT h.hacker_id, h.name, COUNT(c.challenge_id) AS count FROM hackers h
JOIN challenges c
ON h.hacker_id = c.hacker_id
GROUP BY h.hacker_id, h.name
HAVING count = 
    (
        SELECT MAX(c1.count_c1) FROM 
			(
				SELECT COUNT(challenge_id) AS count_c1 FROM challenges GROUP BY hacker_id
			) c1
    )
OR count IN
    (
        SELECT count_c2 FROM
        (
            SELECT COUNT(challenge_id) as count_c2
            FROM challenges c2
            GROUP BY c2.hacker_id
        ) counts
        GROUP BY count_c2
        HAVING COUNT(count_c2) = 1
    )
ORDER BY count DESC, h.hacker_id;

-- 8/ Contest leaderboard
select h.hacker_id, h.name, sum(score_max)
from hackers h 
join
    (
        select s.hacker_id, max(score) as score_max 
        from submissions s 
        group by s.hacker_id, s.challenge_id
    ) st
on h.hacker_id = st.hacker_id
group by h.hacker_id, h.name
having sum(score_max) > 0
order by sum(score_max) desc, h.hacker_id;

-- 9/ SQL project planning
SELECT START_DATE, END_DATE
FROM (
	SELECT	START_DATE, ROW_NUMBER() OVER (ORDER BY START_DATE) AS row_num
	FROM PROJECTS
	WHERE START_DATE NOT IN
	(SELECT END_DATE FROM PROJECTS)
    ) t1
	JOIN (
	SELECT	END_DATE, ROW_NUMBER() OVER (ORDER BY END_DATE) AS row_num
	FROM PROJECTS
    WHERE END_DATE NOT IN
    (SELECT START_DATE FROM PROJECTS)
	) t2 
    ON t1.row_num = t2.row_num
ORDER BY DATEDIFF(END_DATE, START_DATE), START_DATE;

-- 10/ Placements
SELECT temp1.sn
FROM 
(
    SELECT S.ID si,S.Name sn,P.Salary ps 
    FROM Students S 
    JOIN Packages P 
    ON S.ID = P.ID
) temp1 
JOIN 
(
    SELECT FF.ID fi,FF.Friend_ID fd,PP.Salary pps 
    FROM Friends FF 
    JOIN Packages PP 
    ON FF.Friend_ID = pp.ID
) temp2 
ON temp1.si = temp2.fi AND temp1.ps < temp2.pps
ORDER BY temp2.pps;