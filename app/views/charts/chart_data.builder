xml = Builder::XmlMarkup.new(:indent=>0)
graph_options=Hash.new
@chart.options.each{|cho|
  graph_options[cho.name.to_sym] = cho.value.to_s
}
xml.graph(graph_options) do
  category_options=Hash.new
  @chart.categories.each{|c|
    c.options.each do |co|
      category_options[co.name.to_sym]=co.value.to_s
    end
  xml.categories do
    xml.category(category_options)
  end
  }
  
  @chart.series.each do |s|
    dataset_options=Hash.new
    s.options.each{|so|
      dataset_options[so.name.to_sym]=so.value.to_s
    }
    xml.dataset(dataset_options) do
      set_options=Hash.new
      s.data_points.each{|dp|
        dp.options.each do |dpo|
          set_options[dpo.name.to_sym]=dpo.value.to_s
        end
      xml.set(set_options)
      }      
    end
  end
end