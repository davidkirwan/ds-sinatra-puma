# 0.1.0, 11-07-2011
- initial release

# 0.1.1, 11-10-2011
- issue #1 cannot find redstorm gem when using rbenv

# 0.2.0, 11-16-2011
- issue #2 redstorm examples fails when directory examples already exists
- new *simple* DSL
- examples using simple DSL
- redstorm command usage syntax change
- more doc in README

# 0.2.1, 11-23-2011
- gems support in production cluster

# 0.3.0, 12-08-2011
- Storm 0.6.0

# 0.4.0, 02-08-2012
- Storm 0.6.2
- JRuby 1.6.6

# 0.5.0, 05-28-2012
- issue #16, Bundler support for topology gems
- issue #19, support for multiple dirs in jar
- issue #20, update to Storm 0.7.1
- issue #21, proper support for 1.8/1.9 Ruby compatibility mode
- issue #22, fixed Config class name clash
- JRuby 1.6.7
- DSL Support for per bolt/spout configuration and spout activate/deactivate in Storm 0.7.x
- consistent workflow using the redstorm command in local dev or gem mode

# 0.5.1, 06-05-2012
- better handling of enviroments and paths
- redstorm bundle command to install topology gems
- issue #26, fixed examples/native for 0.5.1 compatibility

# 0.6.0, 06-27-2012
- issue #29, updated to Storm 0.7.3
- issue #30, add redstorm cluster command for remote topology submission
- issue #31, added support for localOrShuffleGrouping
- issue #33, avoid forking or shelling out on redstorm commands
- issue #35, automatically set JRuby 1.8/1.9 mode in remote cluster context
- JRuby 1.6.7.2
- better handling of JRuby 1.8/1.9 mode
- topology gems are now specified using a Bundler group in the project Gemfile
- refactored environment/paths handling for local vs cluster context

# 0.6.1, 07-07-2012
- issue #38, added support for spout reliable emit
- gem path is always in target/gems for both local and cluster context
- temp fix for slf4j dependencies conflict (issue #36)
- Storm 0.7.4

# 0.6.2, 07-10-2012
- issue #39, spout on_receive block will not be evaluated if :emit => false
- issue #40, bolt fail method missing
- integration tests support

# 0.6.3, 10-09-2012
- issue #28, allow specification of output_fields in topology DSL
- issue #41, add support for ShellBolt and ShellSpout
- issue #49, redstorm bundle not picking up default group in Gemfile
- support constructor parameters for Java spout/bolt in topology DSL

# 0.6.4, 10-19-2012
- Storm 0.8.1 and JRuby 1.6.8
- improved and more flexible jar dependencies handling
- issue #36, fix slf4j-api-1.6.3 and slf4j-log4j12-1.5.8 version conflict
- issue #37, fix dependencies xml files naming
- issue #47, Log4j Logger class conflict
- issue #48, add support for external Jars
- issue #50, update RedStorm to target Storm 0.8

# 0.6.5, 05-13-2013
- Storm 0.8.2 and JRuby 1.7.3
- added vagrant/chef configurations for single node Storm cluster test environment
- issue #52 - transactional topologies
- issue #56 - make topology class configure statement optional
- issue #57 - DRPC topologies
- issue #73, external jars dependencies Ivy configurations completely externalized and configurable
- lots of other [bug fixes and improvements](https://github.com/colinsurprenant/redstorm/issues?milestone=9&page=1&state=closed)

# 0.6.6.beta1, 07-02-2013
- Storm 0.9.0-wip16 and JRuby 1.7.4
- [issue #79](https://github.com/colinsurprenant/redstorm/issues/79) - fix example Kafka topology dependency doc
- [issue #82](https://github.com/colinsurprenant/redstorm/issues/82) - configurable javac compilation source/target
- [issue #83](https://github.com/colinsurprenant/redstorm/issues/83) - syntactic sugar on the Tuple class
- [issue #84](https://github.com/colinsurprenant/redstorm/issues/84) - DSL classes naming and namespace
- improved DSL performance by refactoring closures invocation, see [redstorm-benchmark](https://github.com/colinsurprenant/redstorm-benchmark/)
- fixed FFI support
- exposed topology builder for specs
- [issue #11](https://github.com/colinsurprenant/redstorm/issues/11), [#17](https://github.com/colinsurprenant/redstorm/issues/17) -  example specs using the Storm testing API see [redstorm-starter](https://github.com/colinsurprenant/redsto  rm-starter/)

# 0.6.6.beta2, 07-20-2013
- [issue #76](https://github.com/colinsurprenant/redstorm/issues/76) - avoid shelling out to storm jar command for cluster submission

# 0.6.6, 07-25-2013
- updated example Kafka topology for new dependencies for Storm KafkaSpout

# 0.7.0.beta1, 03-2014
- refactored the proxy classes for better performance
- Storm 0.9.1-incubating and JRuby 1.7.11
- added Trident example in `examples/trident/`