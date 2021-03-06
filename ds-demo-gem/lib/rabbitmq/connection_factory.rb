####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan/ds-sinatra-puma
# @description  Distributed Systems Demo Gem
#
# @date         2014-11-26
####################################################################################################

require 'json'
require 'bunny'


class RabbitmqBunnyConnection

  attr_accessor :datablocks, :rabbit, :q, :ch, :x

  def initialize()
    @options = {
      :mbhost=>"10.208.0.162",
      :mbport=>5672,
      :mbuser=>'dsdemo',
      :mbpassword=>'dsdemo',
      :topic=>'ds.demo',
      :incomming_queue=>'incomming.queue',
      :incomming_binding_key=>'binding.key',
      :outgoing_queue_1=>'tag.outgoing.queue',
      :outgoing_queue_2=>'user.outgoing.queue',
      :outgoing_queue_3=>'word.outgoing.queue',
      :outgoing_binding_key_1=>'tag.binding.key',
      :outgoing_binding_key_2=>'user.binding.key',
      :outgoing_binding_key_3=>'word.binding.key'
    }
    @datablocks = Array.new

    # Setup the MB connection
    @connection = make_connection(@options)
    @ch = @connection.create_channel
    @x = @ch.topic(@options[:topic], :durable=>true)
    @ch.prefetch(100)
  end


  def configure_incomming_channel()
    @q = @ch.queue(@options[:incomming_queue], :exclusive => true, :durable=>false, :autodelete=>true)
    @q.bind(@x, :routing_key=>@options[:incomming_binding_key])
  end
  
  def configure_outgoing_channel()
    @q_1 = @ch.queue(@options[:outgoing_queue_1], :exclusive => true, :durable=>false, :autodelete=>true)
    @q_1.bind(@x, :routing_key=>@options[:outgoing_binding_key_1])
    
    @q_2 = @ch.queue(@options[:outgoing_queue_2], :exclusive => true, :durable=>false, :autodelete=>true)
    @q_2.bind(@x, :routing_key=>@options[:outgoing_binding_key_2])
    
    @q_3 = @ch.queue(@options[:outgoing_queue_3], :exclusive => true, :durable=>false, :autodelete=>true)
    @q_3.bind(@x, :routing_key=>@options[:outgoing_binding_key_3])
  end


  def close()
    retries = 3
    begin
      @q.delete
      @q_1.delete
      @q_2.delete
      @q_3.delete
    rescue
      retries -= 1
      if retries > 0
        retry
      end
    end
    @connection.close
  end


  def pop_messages()
    unless @q.message_count < 100
      100.times do
        delivery_info, properties, payload = @q.pop(:auto_ack=>true)
        unless payload.nil? then @datablocks.push(payload); end
      end
    else
      0.upto(@q.message_count) do
        delivery_info, properties, payload = @q.pop(:auto_ack=>true)
        unless payload.nil? then @datablocks.push(payload); end
      end
    end
    return @datablocks
  end


  def publish_messages(message, binding_key)
    puts "Message received: #{message} with routing_key: #{binding_key}"
    unless message.nil? or binding_key.nil? then @x.publish(message, :routing_key=>binding_key); end
  end


  def connected?
    if @ch.status == :open then return true; else return false; end
  end


  def make_connection(options)
    unless @rabbit.nil? then return @rabbit; end

    @rabbit = Bunny.new(:host=>options[:mbhost],
                        :port=>options[:mbport],
                        :user=>options[:mbuser],
                        :password=>options[:mbpassword])

    @rabbit.start # Start the connection

    return @rabbit
  end


  private :make_connection

# End of the RabbitmqConnection class
end


=begin
connection = RabbitmqBunnyConnection.new
puts connection.connected?

words = ["the", "quick", "brown", "fox", "jumped", "over", "the", "lazy", "dog"]

0.upto(words.size-1) do |i|
  connection.publish_messages(words[i], "binding.key")
end

puts connection.pop_messages().inspect
connection.close
=end
