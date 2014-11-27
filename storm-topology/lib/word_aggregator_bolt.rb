require 'red_storm'
require 'json'
require 'time'
require 'ds-demo-gem'


class WordAggregatorBolt < RedStorm::DSL::Bolt
  on_init do
    @word_hash = Hash.new
    @user_hash = Hash.new
    @tag_hash = Hash.new
    
    @connection = RabbitmqBunnyConnection.new
    
    @now = Time.now.getutc
    @previous_slot = get_previous_timeslot(@now)
    @next_slot = get_timeslot(@now)
    @tick = get_update_slot(@previous_slot, @next_slot, @now) # Topology generates data every 60 seconds
  end

  on_receive(:emit => false) do |tuple|
    begin
      payload = tuple["datablock"]
      
      unless payload == ""
        if @word_hash.has_key?(payload)
          @word_hash[payload] += 1
        else
          @word_hash[payload] = 1
        end
        
        @word_hash.each do |k, v|
          if k[0] == "#"
            @tag_hash[k] = v
          end
          
          if k[0] == "@"
            @user_hash[k] = v
          end
        end
        
        # Prepare for the latest tick
        if Time.now.getutc > @tick
          @now = Time.now.getutc
          @previous_slot = get_previous_timeslot(@now)
          @next_slot = get_timeslot(@now)
          @tick = get_update_slot(@previous_slot, @next_slot, @now)
          
          @connection.publish_messages(@tag_hash.to_json, "tag.binding.key")
          @connection.publish_messages(@user_hash.to_json, "user.binding.key")
        end
  
        #unanchored_emit(i)
      end  

    rescue Exception => e
      raise e
    end
  end
  
  
  on_close do
    @connection.close
  end
  
  
  def get_timeslot(now)
    begin
      slot1 = Time.utc( now.year, now.month, now.day, now.hour, 15, 0 )
      slot2 = Time.utc( now.year, now.month, now.day, now.hour, 30, 0 )
      slot3 = Time.utc( now.year, now.month, now.day, now.hour, 45, 0 )
      slot4 = Time.utc( now.year, now.month, now.day, now.hour, 0, 0 ) + 3600
      if now < slot1
      return slot1
      elsif now < slot2
      return slot2
      elsif now < slot3
      return slot3
      else
      return slot4
      end
    rescue RangeError => e
      return Time.utc( now.year, now.month, now.day + 1, 0, 0, 0)
    end
  end
  
  def get_previous_timeslot(now)
    slot1 = Time.utc( now.year, now.month, now.day, now.hour, 0, 0 )
    slot2 = Time.utc( now.year, now.month, now.day, now.hour, 15, 0 )
    slot3 = Time.utc( now.year, now.month, now.day, now.hour, 30, 0 )
    slot4 = Time.utc( now.year, now.month, now.day, now.hour, 45, 0 )
    if now >= slot4
      return slot4
    elsif now >= slot3
      return slot3
    elsif now >= slot2
      return slot2
    else
      return slot1
    end
  end
  
  def get_update_slot(previous_timeslot, next_timeslot, now)
    offset_time_between_slots = 60
    slot_array = Array.new
    slot = previous_timeslot
    
    while slot < next_timeslot
      slot_array << slot
      slot = slot + offset_time_between_slots
    end
    
    the_update_slot = slot
    
    slot_array.each do |i|
      if now > i
      else
        the_update_slot = i
        break
      end
    end
    
    return the_update_slot
  end
  
end
