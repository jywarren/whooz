class PingsController < ApplicationController
  
  # GET /pings
  # GET /pings.xml
  def index
    @pings = Ping.find(:all, :limit => 50, :order => "id DESC")
    
    respond_to do |format|
      format.html # index.html.erb
      format.kml { render :template => "map/map.kml.erb", :layout => false }
      format.xml  { render :xml => @pings }
      format.json  { render :json => @pings }
    end
  end

  # GET /pings/1
  # GET /pings/1.xml
  def show
    @ping = Ping.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ping }
    end
  end

  # GET /pings/new
  # GET /pings/new.xml
  def new
    @ping = Ping.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ping }
    end
  end

  # POST /ping
  # POST /ping.xml
  def create
    @ping = Ping.new(params[:ping])
    @ping.re_geocode
    @ping.ping_type = 1
         
    respond_to do |format|
      if @ping.save
        flash[:notice] = 'Ping was successfully created.'
        format.html { redirect_to('/pings') }
        format.xml  { render :xml => @ping, :status => :created, :location => @ping }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ping.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pings/1
  # DELETE /pings/1.xml
  def destroy
    @ping = Ping.find(params[:id])
    @ping.destroy
    
    respond_to do |format|
      format.html { redirect_to(pings_url) }
      format.xml  { head :ok }
    end
  end
end
