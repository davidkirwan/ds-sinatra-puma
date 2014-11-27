require 'red_storm'
require 'json'
require 'time'

class SentenceParserBolt < RedStorm::DSL::Bolt
  on_init do
  end

  on_receive(:emit => false) do |tuple|
    begin
      payload = tuple["datablock"]
      
      unless payload == ""
        word_array = parse_sentence(payload)
        
        word_array.each do |i|
          unanchored_emit(i)
        end
      end

    rescue Exception => e
      # raise e
    end
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
    word = word.gsub(/\w\,/, '').gsub(/:$/, '').strip.downcase    
    return word
  end
  
end
