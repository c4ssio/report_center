SELECT CASE WHEN log_record_product='professional' THEN 'product 1'
WHEN log_record_product='monitor' THEN 'product 2'
WHEN log_record_product='interface' THEN 'product 3'
WHEN log_record_product='enterprise' THEN 'product 4'
END product,
CASE WHEN log_record_date>=@period_1_begin_date AND log_record_date<@period_2_begin_date THEN 'period 1'
WHEN log_record_date>=@period_2_begin_date AND log_record_date<@period_3_begin_date THEN 'period 2'
WHEN log_record_date>=@period_3_begin_date AND log_record_date<@period_4_begin_date THEN 'period 3'
WHEN log_record_date>=@period_4_begin_date AND log_record_date<@period_5_begin_date THEN 'period 4'
END period,
COUNT(*) `page hits`
FROM page_hits
WHERE
CASE WHEN log_record_date>=@period_1_begin_date AND log_record_date<@period_2_begin_date THEN 1
WHEN log_record_date>=@period_2_begin_date AND log_record_date<@period_3_begin_date THEN 2
WHEN log_record_date>=@period_3_begin_date AND log_record_date<@period_4_begin_date THEN 3
WHEN log_record_date>=@period_4_begin_date AND log_record_date<@period_5_begin_date THEN 4
END IS NOT NULL
GROUP BY product,
CASE WHEN log_record_date>=@period_1_begin_date AND log_record_date<@period_2_begin_date THEN 1
WHEN log_record_date>=@period_2_begin_date AND log_record_date<@period_3_begin_date THEN 2
WHEN log_record_date>=@period_3_begin_date AND log_record_date<@period_4_begin_date THEN 3
WHEN log_record_date>=@period_4_begin_date AND log_record_date<@period_5_begin_date THEN 4
END;