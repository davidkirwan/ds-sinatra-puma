require 'red_storm'
require 'json'
require 'time'

class MessageParserBolt < RedStorm::DSL::Bolt
  on_init do
  end

  on_receive(:emit => false) do |tuple|
    begin
      payload = tuple["datablock"]
      
      sentence_array = parse_paragraph(payload)
      
      sentence_array.each do |i|
        unanchored_emit(i)  
      end

    rescue Exception => e
      # raise e
    end
  end
  
  
  def parse_paragraph(paragraph)
    sentence_array = Array.new
    
    paragraph_array = paragraph.strip.split("\n")
    paragraph_array.map do |i|
      if i == "" then paragraph_array.delete(i); end
    end
    
    paragraph_array.each do |i|
      sentences = i.split(".")
      sentences.map do |j|
        if j == "" then sentences.delete(j); end
      end
      
      sentences.each do |j|
        unless j.strip.nil? then sentence_array << j.strip; end
      end
    end
    
    return sentence_array
  end
  
end
