class ChartsController < ApplicationController

  def index
    
    if request.xhr?
      #user is requesting a specific chart or set of charts to be displayed
      render :nothing => true
    else
    #load standard beginning charts
    headers["content-type"]="text/html"
    end
  end

end
