# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'd0a4b4c93f809f9a7aa3b8e6545c27db'
    
  # before_filter :process_messages

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def process_messages
    
    #     # From Frontline:
    #     last_ping = Ping.find :last
    # new_messages = Message.find_by_sql "SELECT frontline_messages.tid FROM frontline_messages LEFT JOIN pings ON frontline_messages.tid=pings.tid WHERE frontline_messages.tid IS NOT NULL AND type = 1 AND status = 1 AND pings.tid IS NULL AND frontline_messages.tid <> 0 AND dateTimeP > "+last_ping.updated_at.strftime("'%m-%d-%Y %H:%M:%S'")
    #     new_messages = Message.find new_messages
    #     new_messages.each do |message|
    #       begin
    #         message.save_as_ping
    #       rescue
    #         message.status = 5
    #         message.save!
    #         flash[:notice] = "'"+message.content+"' could not be saved."
    #       end
    #     end
    
    # From Twitter:
    
    begin
      last_ping = Ping.find :last, :conditions => ["twitter_username <> ''"]
      since = (last_ping.created_at+1.second).strftime("%a%%2C+%d+%b+%Y+%H%%3A%M%%3A%S+GMT")
      new_tweets = Tweet.find(:all, :from=>"/statuses/friends_timeline/whooz.xml?since="+since)

      @failed_to_geocode = ""
      new_tweets.reverse.each do |tweet|
      ping = tweet.save_as_ping
      end      
    rescue
      flash.now[:notice] = "dropped connection from Twitter"
    end
    
  end

end

Mime::Type.register "text/kml", :kml

## THIS WAS A FIX FOR SQLITE, shockingly:

# module ActiveRecord
#   module ConnectionAdapters # :nodoc:
# 
#     module Quoting
#       
#       def quoted_true
#         "'true'"
#       end
# 
#       def quoted_false
#         "'false'"
#       end
# 
#     end
#   end
# end    