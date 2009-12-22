xml = Builder::XmlMarkup.new(:indent=>0)

options = {
  :caption=>'Business Results 2005 v 2006',
  :xAxisName=>'Month',
  :yAxisName=>'Revenue',
  :showValues=>'0',
  :numberPrefix=>'$',
  :decimalPrecision=>'0',
  :bgcolor=>'F3f3f3',
  :bgAlpha=>'70',
  :showColumnShadow=>'1',
  :divlinecolor=>'c5c5c5',
  :divLineAlpha=>'60',
  :showAlternateHGridColor=>'1',
  :alternateHGridColor=>'f8f8f8',
  :alternateHGridAlpha=>'60'
}

data = {
  :'2006' => ['27400','29800','25800','26800','29600'],
  :'2005' => ['10000','11500','12500','15000','11000']
}

categories = ['Jan','Feb','Mar','Apr','May']

xml.graph(options) do
  xml.categories(:font => "Arial", :fontSize => "11", :fontColor => "000000") do
  categories.each do |c|
    category_name = c
      xml.category(:name => category_name)
    end
  end

  data.each do |k,v|
    series_name = k.to_s
    xml.dataset(:seriesname => series_name, :color => ''+get_FC_color) do
      v.each do |p|
        xml.set(:value => p)
      end
    end
  end
end