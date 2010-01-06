#add color schemes
dbg_cs = ColorScheme.find_or_create_by_name('blue_green_yellow_purple')
['0080C0','008040','FFFF00','800080','EB59CB'].each do |h|
  dbg_cs.items.find_or_create_by_hex_code(h)
end

top_5_gradient = ColorSchemeGroup.find_or_create_by_name('top_5_gradient')

{
  'blue_gradient_5'=>['06266F','2A4480','1240AB','4671D5','6C8CD5'],
  'teal_gradient_5'=>['00665E','1D766F','009D91','33CEC3','5DCEC6'],
  'green_gradient_5'=>['008110','259433','00C618','39E24D','6EE275'],
  'orange_gradient_5'=>['A63600','BF5E30','FF5300','FF7E40','FFA073'],
  'purple_gradient_5'=>['6C006C','7C1F7C','A600A6','D235D2','D25FD2']
}.each do |n,ha|
  cs=top_5_gradient.color_schemes.find_or_create_by_name(n)
  ha.each do |h|
    cs.items.find_or_create_by_hex_code(h)
  end
end

#Product Page Hits By Period
#generate query and parameters
dbg_sql=SqlQuery.find_or_create_by_name('genre_downloads_by_period')

dbg_chart = dbg_sql.charts.find_or_create_by_name('genre_downloads_by_period')

{
  :period_1_start_date=>'2009-04-01',
  :period_2_start_date=>'2009-04-08',
  :period_3_start_date=>'2009-04-15',
  :period_4_start_date=>'2009-04-22',
  :period_5_start_date=>'2009-04-29'
}.each do |n,v|
  dbg_chart.sql_params.find_or_create_by_name_and_text_value(
    n.to_s,v)
end

dbg_chart.color_scheme_id=dbg_cs.id
dbg_chart.save!

#load data from sql file
dbg_chart.load_from_sql

{:showAlternateHGridColor=>"1", :bgcolor=>"F3f3f3",
  :caption=>"Downloads by Genre, Period 1 - Period 4", :xAxisName=>"Period",
  :alternateHGridColor=>"f8f8f8", :bgAlpha=>"70", :yAxisName=>"Downloads",
  :alternateHGridAlpha=>"60", :showColumnShadow=>"1", :showValues=>"0",
  :divlinecolor=>"c5c5c5", :numberPrefix=>"", :divLineAlpha=>"60",
  :decimalPrecision=>"0"}.each do |n,v|
  dbg_chart.options.find_or_create_by_name_and_value(n.to_s,v)
end


dbg_chart.series.sort_by(&:order).each do |s|
  s.data_points.each do |dp|
    dp.options.find_or_create_by_name_and_value('alpha','100')
  end
end

#Client Page Hits by Page Name
#(generates 5 charts for each cat/series of dbg)

dbst5g_sql=SqlQuery.find_or_create_by_name(
'segment_downloads_top_5_games')


#generate one chart for each possible combination
cs_i=0
dbg_chart.series.each do |s|
  dbg_chart.categories.each do |c|
    (1..5).each do |rank_i|
      dbst5g_chart=
        dbst5g_sql.charts.find_or_create_by_name_and_parent_id(
        "#{dbst5g_sql.name}_#{s.name.funderscore
        }_#{c.name.funderscore}_#{rank_i.to_s}",dbg_chart.id)
      #add parent parameters as well as series, category as text
      {
        :period_1_start_date=>'2009-04-01',
        :period_2_start_date=>'2009-04-08',
        :period_3_start_date=>'2009-04-15',
        :period_4_start_date=>'2009-04-22',
        :period_5_start_date=>'2009-04-29',
        :series_name=>s.name,
        :category_name=>c.name,
        :rank=>rank_i.to_s
      }.each do |n,v|
        dbst5g_chart.sql_params.find_or_create_by_name_and_text_value(
          n.to_s,v)
      end
      #add color scheme
      dbst5g_chart.color_scheme_id=top_5_gradient.color_schemes[cs_i].id
      dbst5g_chart.save!
      #reset counter if at end of color scheme
      cs_i+=1
      cs_i=0 if cs_i==top_5_gradient.color_schemes.length
    end
  end
end

#load first 5 from sql, apply color schemes, load to fcxml
dbst5g_sql.charts[0..4].each do |ch|
#apply color scheme
  ch.load_from_sql
  ch.reload;ch.to_fcxml
  cs_i+=1
end

#load dbg_chart w new child link xml from child charts
dbg_chart.reload;dbg_chart.to_fcxml