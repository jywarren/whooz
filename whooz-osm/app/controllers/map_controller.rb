class MapController < ApplicationController

  def index
    osm = Openstreetmap.new
    render :xml => osm.features(11.54,48.14,11.543,48.145)
  end

end
