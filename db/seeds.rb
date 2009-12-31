#add color schemes
pphbp_cs = ColorScheme.find_or_create_by_name('blue_green_yellow_purple')
['0080C0','008040','FFFF00','800080','EB59CB'].each do |h|
  pphbp_cs.items.find_or_create_by_hex_code(h)
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
pphbp_sql=SqlQuery.find_or_create_by_name('product_page_hits_by_period')

pphbp_chart = pphbp_sql.charts.find_or_create_by_name('product_page_hits_by_period')

{
  :period_1_start_date=>'2009-04-01',
  :period_2_start_date=>'2009-04-08',
  :period_3_start_date=>'2009-04-15',
  :period_4_start_date=>'2009-04-22',
  :period_5_start_date=>'2009-04-29'
}.each do |n,v|
  pphbp_chart.sql_params.find_or_create_by_name_and_text_value(
    n.to_s,v)
end

pphbp_chart.color_scheme_id=pphbp_cs.id
pphbp_chart.save!

#load data from sql file
pphbp_chart.load_from_sql

{:showAlternateHGridColor=>"1", :bgcolor=>"F3f3f3",
  :caption=>"Page Hits by Product, (Period 1 - Period 4)", :xAxisName=>"Period",
  :alternateHGridColor=>"f8f8f8", :bgAlpha=>"70", :yAxisName=>"Page Hits",
  :alternateHGridAlpha=>"60", :showColumnShadow=>"1", :showValues=>"0",
  :divlinecolor=>"c5c5c5", :numberPrefix=>"", :divLineAlpha=>"60",
  :decimalPrecision=>"0"}.each do |n,v|
  pphbp_chart.options.find_or_create_by_name_and_value(n.to_s,v)
end


pphbp_chart.series.sort_by(&:order).each do |s|
  s.data_points.each do |dp|
    dp.options.find_or_create_by_name_and_value('alpha','100')
  end
end

#Client Page Hits by Page Name
#(generates 5 charts for each cat/series of pphbp)

cphbpn_sql=SqlQuery.find_or_create_by_name(
'client_page_hits_by_page_name')


#generate one chart for each possible combination
cs_i=0
pphbp_chart.series.each do |s|
  pphbp_chart.categories.each do |c|
    (1..5).each do |rank_i|
      cphbpn_chart=
        cphbpn_sql.charts.find_or_create_by_name_and_parent_id(
        "#{cphbpn_sql.name}_#{s.name.funderscore
        }_#{c.name.funderscore}_#{rank_i.to_s}",pphbp_chart.id)
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
        cphbpn_chart.sql_params.find_or_create_by_name_and_text_value(
          n.to_s,v)
      end
      #add color scheme
      cphbpn_chart.color_scheme_id=top_5_gradient.color_schemes[cs_i].id
      cphbpn_chart.save!
      #reset counter if at end of color scheme
      cs_i+=1
      cs_i=0 if cs_i==top_5_gradient.color_schemes.length
    end
  end
end

#load first 5 from sql, apply color schemes, load to fcxml
cphbpn_sql.charts[0..4].each do |ch|
#apply color scheme
  ch.load_from_sql
  ch.reload;ch.to_fcxml
  cs_i+=1
end

#load pphbp_chart w new child link xml from child charts
pphbp_chart.reload;pphbp_chart.to_fcxml

#Client Page Users

#cpgu_chart = Chart.find_or_create_by_name_and_effective_date('client_page_users',Date.today)

#cpgu_chart.options.add(
#  {:xaxisname=>'Months', :yaxisname=>'Page Hits',
#    :caption=>'Client Page Top Users', :lineThickness=>'1',
#    :animation=>'1', :showNames=>'1', :alpha=>'100',
#    :showLimits=>'1', :decimalPrecision=>'1', :rotateNames=>'1',
#    :numDivLines=>'3', :limitsDecimalPrecision=>'0', :showValues=>'0'}
#)
#
#['Client 1'].each do |c|
#  cpgu_chart.categories.add(c).options.add(:showname=>'1')
#end
#
#[cpgu_chart.series.add('User 1')].each do |s|
#  s.options.add(:color=>'0080C0')
#  [810,930,1110,1300,1890].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[cpgu_chart.series.add('User 2')].each do |s|
#  s.options.add(:color=>'008040')
#  [380,390,420,490,900].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[cpgu_chart.series.add('User 3')].each do |s|
#  s.options.add(:color=>'FFFF00')
#  [220,240,280,350,580].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[cpgu_chart.series.add('User 4')].each do |s|
#  s.options.add(:color=>'800080')
#  [20,50,50,60,60].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[cpgu_chart.series.add('User 5')].each do |s|
#  s.options.add(:color=>'EB59CB')
#  [10,10,20,20,20].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
