class ChartsController < ApplicationController

  def index

    @main_chart = 1.ch
    #load standard beginning charts
    headers["content-type"]="text/html"
    
  end

  def get_children
    if request.xhr?
      #take the parent chart, series name, and category name and use them to render appropriate xml files
      children = self.params[:id].to_i.ch.children.find_by_params(
        :series_name=>self.params[:series_name],:category_name=>self.params[:category_name])
      #load sql, apply color schemes, and refresh the charts on the page
      #cycle through 5 color schemes
      color_scheme_array = ['blue_gradient_5','teal_gradient_5','green_gradient_5',
        'orange_gradient_5','purple_gradient_5']
      cs_i=0
      children.each do |ch|
        #if chart has no datapoints
        unless !ch.series.empty? && !ch.series.first.data_points.empty?
        ch.load_from_sql
        ch.add_color_scheme(color_scheme_array[cs_i])
        end
        #load new changes, create xml file
        ch.reload
        ch.to_fcxml
        cs_i+=1
        cs_i=0 if cs_i==color_scheme_array.length
      end
      render :nothing => true
    end
  end
end
