SELECT CASE WHEN log_record_product='professional' THEN 'genre 1'
WHEN log_record_product='monitor' THEN 'genre 2'
WHEN log_record_product='interface' THEN 'genre 4'
WHEN log_record_product='enterprise' THEN 'genre 3'
END genre,
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 'period 1'
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 'period 2'
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 'period 3'
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 'period 4'
END period,
COUNT(*) `downloads`
FROM page_hits
WHERE
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 1
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 2
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 3
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 4
END IS NOT NULL
AND client_id>0
AND LENGTH(page_set)>0
GROUP BY genre,
CASE WHEN log_record_date>=@period_1_start_date AND log_record_date<@period_2_start_date THEN 1
WHEN log_record_date>=@period_2_start_date AND log_record_date<@period_3_start_date THEN 2
WHEN log_record_date>=@period_3_start_date AND log_record_date<@period_4_start_date THEN 3
WHEN log_record_date>=@period_4_start_date AND log_record_date<@period_5_start_date THEN 4
END;