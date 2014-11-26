require 'red_storm'
require "./rabbitmq_bunny_connection"
require "./redstorm_rabbitmq_spout"


class DsdemoTopology < RedStorm::DSL::Topology

  spout RedstormRabbitmqSpout, :parallelism => 1 do
    output_fields :datablock
  end

  configure do |env|
    debug false
    max_task_parallelism 1
    num_workers 2
    max_spout_pending 1000
  end

  on_submit do |env|
    if env == :local
      sleep(15)
      cluster.shutdown
    end
  end
end
