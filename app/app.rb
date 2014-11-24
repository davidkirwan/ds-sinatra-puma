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
require "./lib/rabbitmq_bunny_connection"


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

  # 404 Controller
  not_found do
    [404, {"Content-Type" => "text/plain"},["404 Page Not Found"]]
  end

  get '/' do
    erb :index
  end
  
  get '/ds/demo/:key/:message' do |key, message|
    settings.messagebus.publish_messages(message, key)
  end


end # End of the App class
end # End of the Server module
