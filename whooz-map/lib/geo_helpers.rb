Mime::Type.register "text/kml", :kml

module GeoHelpers
  
  # returns bearing in radians based on a string description of direction, i.e. "North", "SW", "SSE"
  def bearing_from_string(string)
    case string.downcase.strip
    when "n"
      degrees = 0
    when "north"
      degrees = 0
    when "e"
      degrees = 90
    when "east"
      degrees = 90
    when "s"
      degrees = 180
    when "south"
      degrees = 180
    when "w"
      degrees = 270
    when "west"
      degrees = 270
    when "ne"
      degrees = 45
    when "northeast"
      degrees = 45
    when "se"
      degrees = 135
    when "southeast"
      degrees = 135
    when "sw"
      degrees = 225
    when "southwest"
      degrees = 225
    when "nw"
      degrees = 315
    when "northwest"
      degrees = 315
    end
    #return radians
    (PI*degrees)/180
  end
  
  # finds a distance in meters from a string, i.e. "402.33600" from "1/4 mile"
  def meters_from_string(string)
    # recog "3/4", "half", "quarter"

    case string.downcase
    when string.match(\([\d]+)inches\)
      return 39.3700787
    when string.match("in") #0-9
      return 39.3700787
    when string.match("meters")
      return 1
    when string.match("m")
      return 1
    when string.match("yards")
      return 1.0936133
    when string.match("yd")
      return 1.0936133
    when string.match("yds")
      return 1.0936133
    when string.match("ft") #0-9
      return 3.2808399
    when string.match("feet")
      return 3.2808399
    when string.match("kilometers")
      return 0.001
    when string.match("km") #0-9
      return 0.001
    when string.match("miles")
      return 0.000621371192
    end
  end
  
  # given a lat/lon, a bearing, and distance, returns a new lat/lon
  def lat_lon_from_bearing_and_distance(lat1,lon1,brng,d)
    lat2 = Math.asin( Math.sin(lat1)*Math.cos(d/R) + Math.cos(lat1)*Math.sin(d/R)*Math.cos(brng) );
    lon2 = lon1 + Math.atan2(Math.sin(brng)*Math.sin(d/R)*Math.cos(lat1), Math.cos(d/R)-Math.sin(lat1)*Math.sin(lat2));
    [lat2,lon2]
  end

end