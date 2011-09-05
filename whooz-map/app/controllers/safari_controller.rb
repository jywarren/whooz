class SafariController < ApplicationController

  def safari
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    @pings = @pings.sort_by_distance_from(@pings.first)
    @safari = Ping.new(:address => params[:])
    respond_to do |format|
      format.html { render :xml => @pings }
      format.kml { render :template => "map/map.kml.erb", :layout => false }
      format.xml  { render :xml => @pings }
    end
  end

end