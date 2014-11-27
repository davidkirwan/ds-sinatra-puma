$stdout.sync = true
####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan/ds-sinatra-puma
# @description  Ruby Sinatra/Puma app
#
# @date         2014-10-05
####################################################################################################
##### Require statements
require 'sinatra/base'
require 'puma'
require 'logger'
require './lib/rabbitmq_bunny_connection'


module Server
class App < Sinatra::Base


  ##### Variables
  enable :static, :sessions, :logging
  set :environment, :production
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, '/public')
  set :views, File.join(root, '/views')
  set :server, :puma

  # Create the logger instance
  set :log, Logger.new(STDOUT)
  set :level, Logger::DEBUG
  #set :level, Logger::INFO
  #set :level, Logger::WARN

  # Options hash
  set :options, {:log => settings.log, :level => settings.level}
  
  set :messagebus, RabbitmqBunnyConnection.new
  settings.messagebus.configure_outgoing_channel()

  # 404 Controller
  not_found do
    [404, {"Content-Type" => "text/plain"},["404 Page Not Found"]]
  end

  get '/' do
    erb :index
  end
  
  post '/ds/demo' do
    unless params[:key].nil? or params[:message].nil?
      key = params[:key]
      message = params[:message]
      settings.messagebus.publish_messages(message, key)
      [200, {"Content-Type" => "text/plain"},["Publishing[#{key}]: #{message}"]]
    else
      [400, {"Content-Type" => "text/plain"},["400 Bad Request"]]
    end
  end


end # End of the App class
end # End of the Server module
