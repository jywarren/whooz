gem "httparty"
require "httparty"

class Openstreetmap
  include HTTParty
  base_uri 'openstreetmap.org'
  
  def features(left,bottom,right,top)
    options = { :query => { :bbox => left.to_s+","+bottom.to_s+","+right.to_s+","+top.to_s } }
    self.class.get('/api/0.5/map', options)
  end
  
end