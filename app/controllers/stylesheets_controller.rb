class StylesheetsController < ApplicationController
  caches_page :style
  
  def style
    @color = Hash.new
    @color["green"]="#5B8727"
    @color["purple"]="#732942"
    @color["violet"]="#A6688B"
    @color["darkgreen"]="#253A0B"
    @color["lightgreen"]="#9AD352"
    @color["pageback"]="#DED8B1"

    respond_to do |format|
      format.css do
        render
      end
    end
    
  end
  
end
