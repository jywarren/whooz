class Ping < ActiveRecord::Base
  belongs_to :phone
  acts_as_mappable :latcolumnname => :latitude, :lngcolumnname => :longitude
  # validates_presence_of :phone_id
  has_many :keyvalues
  
  def message
    message = self.read_attribute("message")
    if message.nil?
      message = self.read_attribute("content").gsub("msg ","").gsub("Msg ","").gsub("message ","").gsub("Message ","").gsub("locate ","").gsub("Locate ","").gsub("loc ","").gsub("Loc ","")
      self.write_attribute("message",message)
      self.save!
    end
    self.read_attribute("message")
  end

  def short_address
    self.address.gsub(", USA","").gsub(", United States","")
  end

  def lat
    self.latitude
  end
  
  def lng
    self.longitude
  end

  # def full_address
  #   self.street_number+" "+self.thoroughfare+" "+self.locality+", "+self.state+", "+self.country+" "+self.postalcode
  # end
  # 
  def street_number
    street_number = read_attribute("street_number")
    street_number ||= ""
  end
  # 
  # def thoroughfare
  #   thoroughfare = read_attribute("thoroughfare")
  #   thoroughfare ||= ""
  # end

  def color
    case self.animal_key
    when "rats"
      "rgb(180,0,0)"
    when "pigeons"
      "rgb(0,140,0)"
    when "bats"
      "rgb(0,0,140)"
    when "insects"
      "rgb(80,0,80)"
    end
  end

  def re_geocode
      geo = GeoKit::GeoLoc.geocode(self.address)
      errors.add(:address, "Could not Geocode address") if !geo.success
      # self.lat, self.lng = geo.lat,geo.lng if geo.success
      if geo.success
        self.address = geo.full_address
        self.country = geo.country_code
        self.state = geo.state
        self.locality = geo.city
        self.street_number = geo.street_number unless geo.street_number.nil?
        self.thoroughfare = geo.street_name
        self.postalcode = geo.zip
        self.accuracy = geo.precision

        self.latitude = geo.lat
        self.longitude = geo.lng
        self.ping_type = 0
        self.save!
      end
  end
  
  def diameter
    diam = (100/(Time.now - self.created_at))
    if diam < 0
      0
    else
      diam
    end
  end
  
  def crs_fields
    self.message.split("&")
  end

  def crs_fields_hash
    fields = {}
    for message in self.crs_fields
      pair = message.split("=")
      fields[pair[0]] = pair[1]
    end
    fields
  end
  
  def crs_village
    case self.crs_fields_hash['village'].to_i
    when 0
      "Village A"
    when 1
      "Village B"
    when 2
      "Village C"
    when 3
      "Village D"
    when 4
      "Village E"
    when 5
      "Village F"
    when 6
      "Village G"
    else
      "Unknown village"
    end
  end
  
  def crs_disaster_type
    case self.crs_fields_hash['type%5fof%5fdisaster'].to_i
    when 1
      "Flood"
    when 2
      "Cyclone"
    when 3
      "Earthquake"
    when 4
      "Landslide"
    when 5
      "Industrial/Chemical"
    when 6
      "Tsunami"
    when 7
      "Fire"
    end
  end
  
  def crs_gram_panchayat
    case self.crs_fields_hash['gram%5fpanchayat'].to_i
    when 1
      "Gram Panchayat A"
    when 2
      "Gram Panchayat B"
    when 3
      "Gram Panchayat C"
    when 4
      "Gram Panchayat D"
    when 5
      "Gram Panchayat E"
    when 6
      "Gram Panchayat F"
    else
      "Gram Panchayat G"
    end
  end
  
  def crs_district
    case self.crs_fields_hash['district'].to_i
    when 1
      "District A"
    when 2
      "District B"
    when 3
      "District C"
    when 4
      "District D"
    when 5
      "District E"
    when 6
      "District F"
    else
      "District G"
    end
  end
  
  def crs_num_hh
    self.crs_fields_hash['individuals%5fhh']
  end
  
  def crs_aff_house
    self.crs_fields_hash['aff-house']
  end
  
  def crs_missing
    self.crs_fields_hash['missing']
  end
  
  def crs_deaths
    self.crs_fields_hash['deaths']
  end
  
  def crs_f_under_5
    self.crs_fields_hash['f-under-5']
  end
  
  def crs_f_5_14
    self.crs_fields_hash['f-5-14']
  end
  
  def crs_f_15_59
    self.crs_fields_hash['f-15-59']
  end
  
  def crs_f_60
    self.crs_fields_hash['f-60']
  end
  
  def crs_f_preg
    self.crs_fields_hash['f-preg']
  end
  
  def crs_f_unacc
    self.crs_fields_hash['f-unacc']
  end
  
  def crs_f_chal
    self.crs_fields_hash['f-chal']
  end
  
  def crs_f_hiv
    self.crs_fields_hash['f-hiv']
  end
  
  def crs_f_vul
    self.crs_fields_hash['f-vul']
  end
   
  def crs_m_under_5
    self.crs_fields_hash['m-under-5']
  end
  
  def crs_m_5_14
    self.crs_fields_hash['m-5-14']
  end
  
  def crs_m_15_59
    self.crs_fields_hash['m-15-59']
  end
  
  def crs_m_60
    self.crs_fields_hash['m-60']
  end
  
  def crs_m_preg
    self.crs_fields_hash['m-preg']
  end
  
  def crs_m_unacc
    self.crs_fields_hash['m-unacc']
  end
  
  def crs_m_chal
    self.crs_fields_hash['m-chal']
  end
  
  def crs_m_hiv
    self.crs_fields_hash['m-hiv']
  end
  
  def crs_m_vul
    self.crs_fields_hash['m-vul']
  end  
  
  
  
  
  #   
  # def disaster
  #   self.crs_fields[0]
  # end
  #   
  # def village_name
  # 
  # end
  # 
  # def gram_panchayat
  #   
  # end
  #   
  # def block
  #   
  # end
  # 
  # def district
  #   
  # end
  # 
  # def individuals_hh
  #   
  # end
  # 
  # def total_families
  #   
  # end
  #   
end