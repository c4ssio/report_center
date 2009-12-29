DROP TABLE IF EXISTS result;
DROP TABLE IF EXISTS pages_top_5_1;
DROP TABLE IF EXISTS pages_top_5_2;
DROP TABLE IF EXISTS pages_top_5_3;
DROP TABLE IF EXISTS pages_top_5_4;
DROP TABLE IF EXISTS pages_top_5_5;
#gather top 5 pages for the week, create 6 temp tables from it
CREATE TEMPORARY TABLE pages_top_5_1
SELECT CONCAT(page_section,'/',page_set) page_name
FROM page_hits
WHERE
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 'period 1'
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 'period 2'
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 'period 3'
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 'period 4'
END = @category_name
AND
CASE WHEN log_record_product='professional' THEN 'product 1'
WHEN log_record_product='monitor' THEN 'product 2'
WHEN log_record_product='interface' THEN 'product 3'
WHEN log_record_product='enterprise' THEN 'product 4'
END = @series_name
AND LENGTH(page_set)>0
GROUP BY log_record_product,page_name
ORDER BY COUNT(*) DESC
LIMIT 5;
CREATE TEMPORARY TABLE pages_top_5_2 SELECT * FROM pages_top_5_1;
CREATE TEMPORARY TABLE pages_top_5_3 SELECT * FROM pages_top_5_1;
CREATE TEMPORARY TABLE pages_top_5_4 SELECT * FROM pages_top_5_1;
CREATE TEMPORARY TABLE pages_top_5_5 SELECT * FROM pages_top_5_1;
#one table for each since mysql doesn't allow same temp table multiple access
#one table to hold them all
CREATE TEMPORARY TABLE result
SELECT CONCAT('c',LEFT(client_id,5)) CLIENT,CONCAT('page ',@rank) page_name,COUNT(*) page_hits
FROM page_hits ph
JOIN
(SELECT
CASE
WHEN @rank=1 THEN (SELECT * FROM pages_top_5_1 LIMIT 0,1)
WHEN @rank=2 THEN (SELECT * FROM pages_top_5_2 LIMIT 1,1)
WHEN @rank=3 THEN (SELECT * FROM pages_top_5_3 LIMIT 2,1)
WHEN @rank=4 THEN (SELECT * FROM pages_top_5_4 LIMIT 3,1)
WHEN @rank=5 THEN (SELECT * FROM pages_top_5_5 LIMIT 4,1)
END page_name
FROM DUAL) pg ON pg.page_name = CONCAT(ph.page_section,'/',ph.page_set)
WHERE client_id>0
AND
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 'period 1'
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 'period 2'
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 'period 3'
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 'period 4'
END = @category_name
AND
CASE WHEN log_record_product='professional' THEN 'product 1'
WHEN log_record_product='monitor' THEN 'product 2'
WHEN log_record_product='interface' THEN 'product 3'
WHEN log_record_product='enterprise' THEN 'product 4'
END = @series_name
GROUP BY client_id, pg.page_name
ORDER BY COUNT(*) DESC
LIMIT 5;
INSERT INTO result
SELECT IFNULL(CLIENT,"") CLIENT,IFNULL(page_name,"") page_name,
IFNULL(SUM(page_hits),0) page_hits FROM (
SELECT "other" CLIENT,CONCAT('page ',@rank) page_name,COUNT(*) page_hits
FROM page_hits ph
JOIN
(SELECT
CASE
WHEN @rank=1 THEN (SELECT * FROM pages_top_5_1 LIMIT 0,1)
WHEN @rank=2 THEN (SELECT * FROM pages_top_5_2 LIMIT 1,1)
WHEN @rank=3 THEN (SELECT * FROM pages_top_5_3 LIMIT 2,1)
WHEN @rank=4 THEN (SELECT * FROM pages_top_5_4 LIMIT 3,1)
WHEN @rank=5 THEN (SELECT * FROM pages_top_5_5 LIMIT 4,1)
END page_name
FROM DUAL) pg ON pg.page_name = CONCAT(ph.page_section,'/',ph.page_set)
WHERE client_id>0
AND
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 'period 1'
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 'period 2'
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 'period 3'
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 'period 4'
END = @category_name
AND
CASE WHEN log_record_product='professional' THEN 'product 1'
WHEN log_record_product='monitor' THEN 'product 2'
WHEN log_record_product='interface' THEN 'product 3'
WHEN log_record_product='enterprise' THEN 'product 4'
END = @series_name
GROUP BY client_id, pg.page_name
ORDER BY COUNT(*) DESC
LIMIT 6,999999999) tp;
SELECT * FROM result ORDER BY page_name ASC, page_hits desc