SELECT log_record_product,
CASE WHEN log_record_date>='2009-04-01' AND log_record_date<'2009-04-08' THEN 1
WHEN log_record_date>='2009-04-08' AND log_record_date<'2009-04-15' THEN 2
WHEN log_record_date>='2009-04-15' AND log_record_date<'2009-04-22' THEN 3
WHEN log_record_date>='2009-04-22' AND log_record_date<'2009-04-29' THEN 4
END weeks,
COUNT(*) hits
FROM page_hits
WHERE
CASE WHEN log_record_date>='2009-04-01' AND log_record_date<'2009-04-08' THEN 1
WHEN log_record_date>='2009-04-08' AND log_record_date<'2009-04-15' THEN 2
WHEN log_record_date>='2009-04-15' AND log_record_date<'2009-04-22' THEN 3
WHEN log_record_date>='2009-04-22' AND log_record_date<'2009-04-29' THEN 4
END IS NOT NULL
GROUP BY log_record_product,
CASE WHEN log_record_date>='2009-04-01' AND log_record_date<'2009-04-08' THEN 1
WHEN log_record_date>='2009-04-08' AND log_record_date<'2009-04-15' THEN 2
WHEN log_record_date>='2009-04-15' AND log_record_date<'2009-04-22' THEN 3
WHEN log_record_date>='2009-04-22' AND log_record_date<'2009-04-29' THEN 4
END;