SELECT ph.client_id `Client`,tp.page_name `Page Name`,COUNT(*) page_hits
FROM page_hits ph
JOIN
(
#gather top 5 pages for the week
SELECT CONCAT(page_section,'/',page_set) page_name
FROM page_hits
WHERE
(log_record_date>=@period_start_date AND log_record_date<@period_end_date)
AND
CASE WHEN log_record_product='professional' THEN 'product 1'
WHEN log_record_product='monitor' THEN 'product 2'
WHEN log_record_product='insight' THEN 'product 3'
WHEN log_record_product='enterprise' THEN 'product 4'
END = @product_name
AND LENGTH(TRIM(page_set))>0
GROUP BY log_record_product,page_name
ORDER BY COUNT(*) DESC
LIMIT 5
) tp ON tp.page_name = CONCAT(ph.page_section,'/',ph.page_set)
GROUP BY client_id,tp.page_name
ORDER BY tp.page_name,page_hits DESC
;