SET @week_number=1;
SET @log_record_product = 'professional';
;
SELECT ph.client_id,tp.page_name,COUNT(*) page_hits
FROM page_hits ph
JOIN
(
#gather top 5 pages for the week
SELECT CONCAT(page_section,'/',page_set) page_name
FROM page_hits
WHERE
CASE WHEN log_record_date>='2009-04-01' AND log_record_date<'2009-04-08' THEN 1
WHEN log_record_date>='2009-04-08' AND log_record_date<'2009-04-15' THEN 2
WHEN log_record_date>='2009-04-15' AND log_record_date<'2009-04-22' THEN 3
WHEN log_record_date>='2009-04-22' AND log_record_date<'2009-04-29' THEN 4
END=@week_number
AND log_record_product=@log_record_product
AND LENGTH(TRIM(page_set))>0
GROUP BY log_record_product,page_name,
CASE WHEN log_record_date>='2009-04-01' AND log_record_date<'2009-04-08' THEN 1
WHEN log_record_date>='2009-04-08' AND log_record_date<'2009-04-15' THEN 2
WHEN log_record_date>='2009-04-15' AND log_record_date<'2009-04-22' THEN 3
WHEN log_record_date>='2009-04-22' AND log_record_date<'2009-04-29' THEN 4
END
ORDER BY COUNT(*) DESC
LIMIT 5
) tp ON tp.page_name = CONCAT(ph.page_section,'/',ph.page_set)
GROUP BY client_id,tp.page_name
ORDER BY tp.page_name,page_hits DESC
;