class Message < ActiveRecord::Base
  
  set_table_name "frontline_messages"
  set_inheritance_column :ruby_type
  set_primary_key "tid"
  acts_as_mappable
  belongs_to :ping, :foreign_key => :tid
  
  # def before_save
  #   self.dateTimeP = "now"
  # end
  
  # getter for the "type" column
  def message_type
   self[:type]
  end

  # setter for the "type" column
  def message_type=(s)
   self[:type] = s
  end
  
  # # This correctly creates Unix timestamps
  # def dateTimeP=(i)
  #   self.write_attribute(:dateTimeP,i.to_i)
  # end
  # 
  # def dateTimeP
  #   Time.at(self.read_attribute(:dateTimeP).to_i)
  # end
  
  def location_string
    self.content.gsub("locate ","").gsub("Locate ","").gsub("loc ","").gsub("Loc ","")
  end
  
  def is_location?
    self.content[0,7].downcase == "locate " || self.content[0,4].downcase == "loc "
  end
  
  def is_message?
    self.content[0,8].downcase == "message " || self.content[0,4].downcase == "msg "
  end
  
  def is_move?
    self.content[0,5].downcase == "move "
  end
  
  def is_home?
    self.content[0,5].downcase == "home "
  end
  
  def geocode
    geo = GeoKit::Geocoders::MultiGeocoder.geocode(location_string)
    errors.add(:address, "Could not Geocode address") if !geo.success
    # self.lat, self.lng = geo.lat,geo.lng if geo.success
    if geo.success
      [geo.lat,geo.lng]
    else
      [0,0]
    end
  end
  
  def save_as_ping
    # converts to pings, also sorts 'message', 'locate', 'move', 'home'
    ping = Ping.new
    ping.content = self.content
    
    if self.is_location?
      geo = GeoKit::GeoLoc.geocode(location_string)
      # self.lat, self.lng = geo.lat,geo.lng if geo.success
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
        ping.ping_type = 0
      
        phone = Phone.find_by_number self.omsisdnA
        if phone.nil?
          phone = Phone.new(:number => self.omsisdnA)
          phone.save!
        end
        ping.phone_id = phone.id
		    ping.tid = self.tid
        ping.save!

        phone.home_ping_id ||= ping.id
        phone.save!
        # self.imported = 1
        self.save!
      else
        errors.add(:address, "Could not Geocode address")
        self.status = 5
        self.save!
      end
    elsif self.is_message?
      phone = Phone.find_by_number self.omsisdnA
      # ask to register if they haven't yet
      unless phone.nil?
        prev = Ping.find :last, :conditions => {:phone_id => phone.id}
        ping = prev.dup
        ping.ping_type = 1
		ping.tid = self.tid
        ping.content = self.content
        ping.save!
        # self.imported = 1
        self.save!
      end
    elsif self.is_move?
    
    elsif self.is_home?
    
    end
  end
  
end