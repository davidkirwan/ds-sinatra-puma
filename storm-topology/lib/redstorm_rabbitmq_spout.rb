require 'red_storm'
require 'json'
require 'bunny'
require 'ds-demo-gem'


class RedstormRabbitmqSpout < RedStorm::DSL::Spout
  output_fields :datablock
  
  on_send do
    begin
      unless @datablocks.size == 0
        payload = @datablocks.pop
      else
        @datablocks = @connection.pop_messages()
        payload = @datablocks.pop
      end
      
      unless payload == "" or payload.class == NilClass 
        payload
      end
      
    rescue Exception => e
      raise e
      #on_close
    end
  end
  
  
  on_close do
    @connection.close
  end
  

  on_init do
    unless @datablocks.class == Array then @datablocks = Array.new; end
    
    # Setup the MB connection
    @connection = RabbitmqBunnyConnection.new
    @connection.configure_incomming_channel()
  end


# End of the RedstormRabbitmqSpout class
end
