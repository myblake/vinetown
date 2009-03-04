class StylesheetsController < ApplicationController
  caches_page :style
  
  def style
    @color = Hash.new
    @color["green"]="#5B8727"
    @color["purple"]="#732942"
    @color["violet"]="#A6688B"
    @color["darkgreen"]="#4A6D2C"
    @color["lightgreen"]="#9AD352"
    @color["champagne"]="#DED8B1"
    @color["greentext"]="#253A0B"

    respond_to do |format|
      format.css do
        render
      end
    end
    
  end
  
end
