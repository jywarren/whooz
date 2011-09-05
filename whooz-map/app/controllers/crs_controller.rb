class CrsController < ApplicationController
  def index
    @pings = Ping.find :all, :conditions => {:ping_type => 3}, :limit => 30, :order => "id DESC"
    respond_to do |format|
      format.html { render :template => "crs/crs.html.erb", :layout => false }
      format.xml { render :template => "crs/crs.xml.erb", :layout => false }
    end
  end
end