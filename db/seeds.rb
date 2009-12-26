#Product Page Hits By Period
#generate query and parameters
pphbp_sql=SqlQuery.find_or_create_by_name('product_page_hits_by_period')

pphbp_chart = pphbp_sql.charts.find_or_create_by_name('product_page_hits_by_period')

{
  :period_1_begin_date=>'2009-04-01',
  :period_2_begin_date=>'2009-04-08',
  :period_3_begin_date=>'2009-04-15',
  :period_4_begin_date=>'2009-04-22',
  :period_5_begin_date=>'2009-04-29'
}.each do |n,v|
  pphbp_chart.sql_params.find_or_create_by_name_and_text_value(
    n.to_s,v)
end

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

pphbp_chart_color_scheme = ['0080C0','008040','FFFF00','800080','EB59CB']

c_i = 0
pphbp_chart.series.sort_by(&:order).each do |s|
  s.options.find_or_create_by_name_and_value(
    'color',pphbp_chart_color_scheme[c_i])
  s.data_points.each do |dp|
    dp.options.find_or_create_by_name_and_value('alpha','100')
  end
  c_i+=1
end

#Client Page Hits by Page Name
#cphbpn_sql=SqlQuery.find_or_create_by_name('client_page_hits_by_page_name')

#cphbpn_chart=cphbpn_sql.charts.find_or_create_by_name('period_top_pages')

#{:xaxisname=>'Months', :yaxisname=>'Page Hits',
#  :caption=>'Period Top Pages',:lineThickness=>'1', :animation=>'1',
#  :showNames=>'1', :alpha=>'100',:showLimits=>'1', :decimalPrecision=>'1',
#  :rotateNames=>'1', :numDivLines=>'3',:limitsDecimalPrecision=>'0',
#  :showValues=>'0'}.each do |n,v|
#    cphbpn_chart.options.find_or_create_by_name_and_value(n,v)
#  end

#{
#  :period_begin_date=>'2009-04-01',
#  :period_end_date=>'2009-04-08',
#  :product_name=>'product 1'
#}.each do |n,v|
#  cphbpn_chart.sql_params.find_or_create_by_name_and_text_value(
#    n.to_s,v)
#end

#cphbpn_chart.load_from_sql
#
##anticipating 5 colors, add one each to same series

#['Page 1','Page 2','Page 3','Page 4','Page 5'].each do |c|
#  ptp_chart.categories.add(c).options.add(:showname=>'1')
#end
#
#[ptp_chart.series.add('Client 1')].each do |s|
#  s.options.add(:color=>'0080C0')
#  [810,930,1110,1300,1890].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[ptp_chart.series.add('Client 2')].each do |s|
#  s.options.add(:color=>'008040')
#  [380,390,420,490,900].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[ptp_chart.series.add('Client 3')].each do |s|
#  s.options.add(:color=>'FFFF00')
#  [220,240,280,350,580].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[ptp_chart.series.add('Client 4')].each do |s|
#  s.options.add(:color=>'800080')
#  [20,50,50,60,60].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end
#[ptp_chart.series.add('Client 5')].each do |s|
#  s.options.add(:color=>'EB59CB')
#  [10,10,20,20,20].each do |n|
#    s.data_points.add(n).options.add(:alpha=>'100')
#  end
#end

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
