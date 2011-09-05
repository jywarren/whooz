class Phone < ActiveRecord::Base
  has_many :pings

  def last_ping
    Ping.find_by_phone_id self.id, :order => "id DESC"
  end
  
end