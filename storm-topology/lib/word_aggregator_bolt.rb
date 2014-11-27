require 'red_storm'
require 'json'
require 'time'


class WordAggregatorBolt < RedStorm::DSL::Bolt
  on_init do
    @word_hash, @user_hash, @tag_hash = Hash.new
    
    @connection = RabbitmqBunnyConnection.new
  end

  on_receive(:emit => false) do |tuple|
    begin
      payload = tuple["datablock"]
      
      if @word_hash.has_key?(word)
        @word_hash[word] += 1
      else
        @word_hash[word] = 1
      end
      
      @word_hash.each do |k, v|
        if k[0] == "#"
          @tag_hash[k] = v
        end
        
        if k[0] == "@"
          @user_hash[k] = v
        end
      end
      
      unless not connection.connected?
        @connection.publish_messages(@tag_hash.to_json, "tag.binding.key")
        @connection.publish_messages(@tag_hash.to_json, "user.binding.key")
      end

      unanchored_emit(i)  

    rescue Exception => e
      # raise e
    end
  end
  
  
  on_close do
    @connection.close
  end
  
  
  def parse_sentence(sentence)
    word_array, filtered_word_array = Array.new
    word_array = sentence.strip.split(" ")
    
    word_array.each do |i|
      filtered_word_array << filter_word(i)
    end
    
    return filtered_word_array
  end
  
  def filter_word(word)
    word = word.gsub(/\,/, '').strip.downcase
    
    return word
  end
  
end
