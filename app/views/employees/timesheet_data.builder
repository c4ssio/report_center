xml = Builder::XmlMarkup.new(:indent=>0)
options = {
 :caption=>'Time Tracker Chart',
 :subcaption=>'For Employee '+ @employee_details_with_timesheets.name   ,
 :yAxisName=>'Hours Spent',
 :xAxisName=>'Day',
 :showValues=>'1',
 :formatNumberScale=>'0',
 :numberSuffix=>' hrs.'
}
xml.graph(options) do
  for timesheet in @employee_details_with_timesheets.timesheets do
     log_day = timesheet.log_date.strftime('%a')
     xml.set(:name=>log_day,:value=>timesheet.hours_spent,:color=>''+get_FC_color)
  end
end