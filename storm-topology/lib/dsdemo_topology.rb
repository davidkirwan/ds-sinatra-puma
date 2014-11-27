require 'red_storm'
require "rabbitmq_bunny_connection"
require "redstorm_rabbitmq_spout"
require "message_parser_bolt"
require "sentence_parser_bolt"
require "word_aggregator_bolt"


class DsdemoTopology < RedStorm::DSL::Topology

  spout RedstormRabbitmqSpout, :parallelism => 1 do
    output_fields :datablock
  end
  
  bolt MessageParserBolt, :parallelism => 1 do
    output_fields :datablock
    source RedstormRabbitmqSpout, :fields => ["datablock"]
  end
  
  bolt SentenceParserBolt, :parallelism => 1 do
    output_fields :datablock
    source MessageParserBolt, :fields => ["datablock"]
  end
  
  bolt WordAggregatorBolt, :parallelism => 1 do
    output_fields :datablock
    source SentenceParserBolt, :fields => ["datablock"]
  end
  
#####################################################################

  configure do |env|
    debug false
    max_task_parallelism 1
    num_workers 4
    max_spout_pending 1000
  end

  on_submit do |env|
    if env == :local
      sleep(15)
      cluster.shutdown
    end
  end
end
