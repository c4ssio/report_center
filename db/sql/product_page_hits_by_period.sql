SELECT CASE WHEN log_record_product='professional' THEN 'product 1'
WHEN log_record_product='monitor' THEN 'product 2'
WHEN log_record_product='interface' THEN 'product 3'
WHEN log_record_product='enterprise' THEN 'product 4'
END product,
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 'period 1'
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 'period 2'
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 'period 3'
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 'period 4'
END period,
COUNT(*) `page hits`
FROM page_hits
WHERE
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 1
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 2
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 3
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 4
END IS NOT NULL
AND client_id>0
AND LENGTH(page_set)>0
GROUP BY product,
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 1
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 2
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 3
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 4
END;