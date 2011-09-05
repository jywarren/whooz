class Tweet < ActiveResource::Base
  self.site = "http://twitter.com"
  self.user = "whooz"
 # self.password = "gibledygobledygoo"   
                                                                                                              self.password = "poopies"
  
  # Get the latest 20 public statuses
  # Optionally take in :since_id and get updates since passed id
  # Can't figure out how to get a :from and a :params
  def self.public_timeline(params={})
    find(:all, :from=>:public_timeline)
  end

  # Get 20 most recent statuses from authenticated user and his/her friends in the last 24 hours
  # Optionally take in :since timestamp in format: Tue%2C+27+Mar+2007+22%3A55%3A48+GMT
  # Can't figure out how to get a :from and a :params
  def self.friends_timeline(params={})
    find(:all, :from=>:friends_timeline)
  end

  # Get friends timeline for a specified user
  # Can be user id or username
  # Need to implement the :since param as in friends_timeline
  def self.user_and_friends_timeline(id)
    find(:all, :from=>"/statuses/friends_timeline/#{id.to_s}.xml")
  end

  # Get timeline for a user
  # Need to implement :count (limit 20) and :since timestamp
  def self.user_timeline(id)
    find(:all, :from=>"/statuses/user_timeline/#{id.to_s}.xml")
  end

  # Get a specific status
  # Not really RESTful because the 'show' part is extraneous
  def self.show(id)
    find(:one, :from=>"/statuses/show/#{id.to_s}.xml")
  end
  
  def self.update_status(content)
    connection.post("/statuses/update.xml?status="+CGI.escape(content))
  end

  def self.direct_message(username,content)
    connection.post("/direct_messages/new.xml?user="+username+"&text="+content)    
  end

  def self.send_to_user(username,content)
    connection.post("/statuses/update.xml?status="+CGI.escape("@"+username+" "+content))
    
  end
  
  def words
    self.text.downcase.strip.gsub('@whooz',"").strip.split(" ")
  end
  
  def timestamp
    Time.parse(self.created_at)
  end
  
  def geocode
    geo = GeoKit::Geocoders::MultiGeocoder.geocode(self.text)
    errors.add(:address, "Could not Geocode address") if !geo.success
    # self.lat, self.lng = geo.lat,geo.lng if geo.success
    if geo.success
      [geo.lat,geo.lng]
    else
      [0,0]
    end
  end

  def is_animal?
    self.bats? || self.insects? || self.pigeons? || self.rats?
  end

  def bats?
    self.words.first == "bats"
  end

  def insects?
    self.words.first == "insects"
  end

  def pigeons?
    self.words.first == "pigeons"
  end

  def rats?
    self.words.first == "rats"
  end
  
  def is_location?
    self.text[0,2].downcase == "l:"
  end

  def is_move?
    self.words.first == "move"
  end
  
  def is_undo?
    self.words.first == "undo"
  end  
  
  def is_safari?
    self.words.first == "safari"
  end
  
  def cleantext
    text = self.words
    text.delete_at(0)
    text.join(" ")
  end
  
  def generate_safari(ping,range)
    safaris = Ping.find :all, :conditions => {:ping_type => 6}, :limit => 30, :order => "id DESC"
    safaris = safaris.sort_by_distance_from(ping)
    choices = ""
    safaris[range].each do |safari|
      choices += safari.animal_key.upcase+" "+safari.short_address+", "
    end
    Tweet.send_to_user(self.user.screen_name,choices)
  end
  
  def save_as_ping
    # converts to pings, also sorts 'message', 'locate', 'move', 'home'
    ping = Ping.new
    ping.content = self.text
    if self.is_location? || self.is_animal? || self.is_safari?
      if self.bats?
        ping.animal_key = "bats"
      elsif self.insects?
        ping.animal_key = "insects"
      elsif self.pigeons?
        ping.animal_key = "pigeons"
      elsif self.rats?
        ping.animal_key = "rats"
      end
      begin
        geo = GeoKit::GeoLoc.geocode(self.cleantext)
        if geo.success
          ping.address = geo.full_address
          ping.country = geo.country_code
          ping.state = geo.state
          ping.locality = geo.city
          ping.street_number = geo.street_number unless geo.street_number.nil?
          ping.thoroughfare = geo.street_name
          ping.postalcode = geo.zip
          ping.accuracy = geo.precision

          ping.latitude = geo.lat
          ping.longitude = geo.lng
          
          ping.twitter_username = self.user.screen_name
          ping.created_at = Time.parse(self.created_at)
          
          if self.is_animal?
            ping.ping_type = 6
            ping.save!
            reply = "Confirmed: "+ping.animal_key.upcase+" at "+ping.short_address+". Wrong? Add city, state, or zip code. UNDO deletes your last report."
            Tweet.send_to_user(self.user.screen_name,reply)
          elsif self.is_safari?
            ping.ping_type = 7
            ping.save!
            self.generate_safari(ping,0..2)
          end
        end
        self.save
      rescue GeoKit::Geocoders::GeocodeError
        prev = Ping.find :last, :conditions => {:twitter_username => self.user.screen_name}
        if self.is_safari?
          ping = prev.clone
          ping.save!
          self.generate_safari(ping,3..5)
        else
          if prev.content != self.text
            ping.address = self.cleantext
            ping.ping_type = -1
            ping.twitter_username = self.user.screen_name
            ping.created_at = Time.parse(self.created_at)
            ping.save!
            Tweet.send_to_user(self.user.screen_name,"WHOOZ could not find "+ping.short_address+", please try again! Try with zip code, city, state.")
          end
        end
      end
    elsif self.is_move?
      prev = Ping.find :last, :conditions => {:twitter_username => self.user.screen_name,:ping_type => 0}
      unless prev.nil?
        ping = prev.clone
        if self.is_nextmap?
          ping.ping_type = 3
        else
          ping.ping_type = 1
        end
        ping.content = self.text
        ping.message = self.text
        ping.created_at = Time.parse(self.created_at)

        # parse direction and distance
        # self.text
        # ping.
        
        ping.save!
      end
    elsif self.is_undo?
      prev = Ping.find :last, :conditions => ["twitter_username = ? AND content NOT LIKE '% undo%' AND content NOT LIKE 'undo%'", self.user.screen_name]
      Tweet.send_to_user(self.user.screen_name,"Deleted "+prev.short_address)
      prev.destroy
      ping.twitter_username = self.user.screen_name
      ping.created_at = Time.parse(self.created_at)
      ping.ping_type = -2
      ping.save!
    else #uncategorizable, just a message
      prev = Ping.find :last, :conditions => {:twitter_username => self.user.screen_name,:ping_type => 0}
      unless prev.nil?
        ping = prev.clone
        if self.is_nextmap?
          ping.ping_type = 3
        else
          ping.ping_type = 1
        end
        ping.content = self.text
        ping.message = self.text
        ping.created_at = Time.parse(self.created_at)
        ping.save!
      end
    end
    if !geo.nil? && geo.success
      ping
    else
      false
    end
  end
    
end
