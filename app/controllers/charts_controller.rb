class ChartsController < ApplicationController

  def index

    @main_chart = 1.ch
    #load standard beginning charts
    headers["content-type"]="text/html"
    
  end

  def get_child
    if request.xhr?
      #check if xml is already loaded for this chart
        ch_args = {:series_name=>self.params[:series_name],
          :category_name=>self.params[:category_name]}
        ch_args[:rank] = self.params[:rank].to_i if self.params[:rank]
        #take the parent chart, series name, and category name and use them to render appropriate xml files
        ch = self.params[:id].to_i.ch.children.find_by_params(ch_args).first
      unless ch.file_path
        #load sql, generate xml, and refresh the charts on the page
        #if chart has no datapoints
        unless ch.data_points.length>0
          #load new changes,create xml file
          ch.load_from_sql
        end
        ch.reload;ch.to_fcxml
      end
      render :nothing => true
    end
  end
end
