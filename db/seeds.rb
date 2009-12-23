
pu_chart = Chart.find_or_create_by_name_and_effective_date('Product Usage',Date.today)

pu_chart.options.add(:showAlternateHGridColor=>"1", :bgcolor=>"F3f3f3",
  :caption=>"Product Usage Last 4 Periods", :xAxisName=>"Period",
  :alternateHGridColor=>"f8f8f8", :bgAlpha=>"70", :yAxisName=>"Page Hits",
  :alternateHGridAlpha=>"60", :showColumnShadow=>"1", :showValues=>"0",
  :divlinecolor=>"c5c5c5", :numberPrefix=>"", :divLineAlpha=>"60",
  :decimalPrecision=>"0")

wtp_chart = Chart.find_or_create_by_name_and_effective_date('Weekly Top Pages',Date.today)

wtp_chart.options.add(:xaxisname=>'Months', :yaxisname=>'Page Hits',
  :caption=>'Weekly Top Pages',:lineThickness=>'1', :animation=>'1',
  :showNames=>'1', :alpha=>'100',:showLimits=>'1', :decimalPrecision=>'1',
  :rotateNames=>'1', :numDivLines=>'3',:limitsDecimalPrecision=>'0',
  :showValues=>'0')

['Page 1','Page 2','Page 3','Page 4','Page 5'].each do |c|
  wtp_chart.categories.add(c).options.add(:showname=>'1')
end

[wtp_chart.series.add('Client 1')].each do |s|
  s.options.add(:color=>'0080C0')
  [810,930,1110,1300,1890].each do |n|
    s.data_points.add(n).options.add(:alpha=>'100')
  end
end
[wtp_chart.series.add('Client 2')].each do |s|
  [380,390,420,490,900].each do |n|
    s.data_points.add(n).options.add(:alpha=>'100')
  end
end
[wtp_chart.series.add('Client 3')].each do |s|
[220,240,280,350,580].each do |n|
    s.data_points.add(n).options.add(:alpha=>'100')
  end
end
[wtp_chart.series.add('Client 4')].each do |s|
  [20,50,50,60,60].each do |n|
    s.data_points.add(n).options.add(:alpha=>'100')
  end
end
[wtp_chart.series.add('Client 5')].each do |s|
  [10,10,20,20,20].each do |n|
    s.data_points.add(n).options.add(:alpha=>'100')
  end
end