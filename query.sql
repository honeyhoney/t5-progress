SELECT t.id, t.guild, CONCAT(
	CASE n.n
		WHEN 1 THEN 'Hydross:'
		WHEN 2 THEN 'Lurker:'
		WHEN 3 THEN 'Leotheras:'
		WHEN 4 THEN 'Karathress:'
		WHEN 5 THEN 'Morogrim:'
		WHEN 6 THEN 'Vashj:'
		ELSE 'error'
	END, SUBSTRING_INDEX(SUBSTRING_INDEX(t.data, ' ', n.n), ' ', -1)) AS 'boss'
  FROM (
SELECT
	a.id,
	GROUP_CONCAT(DISTINCT d.name ORDER BY d.name ASC SEPARATOR '+') AS 'guild',
	a.data
FROM instance a
INNER JOIN character_instance b
ON a.id = b.instance
INNER JOIN guild_member c
ON b.guid = c.guid
INNER JOIN guild d
ON c.guildid = d.guildid
WHERE (a.map = 548) AND (d.name <> "Looking4Group Staff")
GROUP BY a.id) t 
   CROSS JOIN 
(
   SELECT a.N + b.N * 10 + 1 n
     FROM 
    (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
   ,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    ORDER BY n
) n
 WHERE n.n <= 1 + (LENGTH(t.data) - LENGTH(REPLACE(t.data, ' ', '')))
 ORDER BY id, guild