class MapController < ApplicationController

  def index
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    #@latitude = 40.886
    #@longitude = -74.033
    # @latitude = 40.686
    # @longitude = -73.898
    @latitude = 40.746
    @longitude = -73.898
    @zoom = 12
    respond_to do |format|
      format.html { render :template => "map/whooz", :layout => false }
      format.kml { render :template => "map/map.kml.erb", :layout => false }
      format.xml  { render :xml => @pings }
    end
  end
  
  def test
    # last_ping = Ping.find :last, :conditions => ["twitter_username <> ''"]
    # since = (last_ping.created_at+1.second).strftime("%a%%2C+%d+%b+%Y+%H%%3A%M%%3A%S+GMT")
    # new_tweets = Tweet.find(:all, :from=>"/statuses/friends_timeline/whooz.xml?since="+since)
    # render :text => new_tweets.first.cleantext
  end
  
  def safari_search
    render :template => "map/safari_search", :layout => false
  end
  
  def safari
    @safari = Ping.new(:address => params[:id], :ping_type => 7)
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    @pings = @pings.sort_by_distance_from(@safari)
    # @safari.save
    respond_to do |format|
      format.html { render :xml => @pings }#render :template => "map/safari", :layout => false }
      format.kml { render :template => "map/map.kml.erb", :layout => false }
      format.xml  { render :xml => @pings }
    end
  end
  
  def manhattan
    @city = "manhattan"
    @width = 486
    @height = 954
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    @nw_lat = 40.686
    @nw_lon = -74.033
    @lat_scale = 4800
    @lon_scale = 3600
    render :template => "map/manhattan", :layout => false
  end
  
  def animals_manhattan
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    @nw_lat = 40.686
    @nw_lon = -74.033
    @lat_scale = 4800
    @lon_scale = 3600
    render :template => "map/animals.js.erb", :layout => false
  end
  
  def cambridge
    @width = 779
    @height = 652
    @city = "cambridge"
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    @nw_lat = 42.4079
    @nw_lon = -71.1664
    @lat_scale = 4800
    @lon_scale = 3600
    render :template => "map/manhattan", :layout => false
  end
  
  def animals_cambridge
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    # @nw_lat = 42.4079
    @nw_lat = 42.3407
    @nw_lon = -71.1645
    @lat_scale = 10000
    @lon_scale = 7200
    render :template => "map/animals.js.erb", :layout => false
  end
  
  def bronx
    @width = 486
    @height = 575
    @city = "bronx"
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    @nw_lat = 40.9393
    @nw_lon = -73.9387
    @lat_scale = 4800
    @lon_scale = 3600
    render :template => "map/manhattan", :layout => false
  end
  
  def animals_bronx
    @pings = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    @nw_lat = 40.753
    @nw_lon = -73.945
    @lat_scale = 3550
    @lon_scale = 2700
    render :template => "map/animals.js.erb", :layout => false
  end
  
  def refresh
  end

  def refresh_back
    process_messages
    render :text => "Processed "+Time.now.to_s#+@failed_to_geocode+" "#+flash[:notice]
  end
  
  def twitter
    @pings = Tweet.user_and_friends_timeline(:nextmap)
    respond_to do |format|
      format.html { render :template => "map/index", :layout => false }
      format.kml { render :template => "map/map.kml.erb", :layout => false }
      format.xml  { render :xml => @pings }
    end
  end
  
  def pings
    @pings = Ping.find :all, :conditions => {:ping_type => 1}, :limit => 30, :order => "id DESC"
    respond_to do |format|
      format.html { render :template => "map/index", :layout => false }
      format.kml { render :template => "map/map.kml.erb", :layout => false }
      format.xml  { render :xml => @pings }
    end
  end
  
  def phones
    @phones = Phone.find :all, :limit => 30, :order => "id DESC"
    pings = []
    @phones.each do |phone|
      pings << phone.last_ping
    end
    @pings = Ping.find pings
    respond_to do |format|
      format.html { render :template => "map/index", :layout => false }
      format.kml { render :template => "map/map.kml.erb", :layout => false }
      format.xml  { render :template => "map/current.xml.erb" }
    end
  end
  
  # GET /phones/current.xml
  def current
    @phones = Phone.find :all, :limit => 30, :order => "id DESC"
    pings = []
    @phones.each do |phone|
      pings << phone.last_ping
    end
    @pings = Ping.find pings
    respond_to do |format|
      format.xml  { render :collection => @pings, :template => "current" }
    end
  end
  
  def subscribe
    respond_to do |format|
      format.kml { render :template => "map/subscribe.kml.erb", :layout => false }
    end
  end

  def show_ping
    @ping = Ping.find(params[:ping_id]);
    @keyvalues = @ping.keyvalues;
  end
end
