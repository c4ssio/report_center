class ChartsController < ApplicationController

  def index
    
    @charts = Array.new
    #load charts for use in xml builder
    ['product_page_hits_by_period'].each do |n|
      new_chart = Chart.find(:first,
        :conditions=>{:name=>n},
        :order=>'updated_at DESC')
      @charts << new_chart if new_chart
    end

    headers["content-type"]="text/html"
  end

end
