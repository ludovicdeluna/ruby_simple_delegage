module Warbuck
  require 'yaml'

  GAME_PATH     = File.expand_path( '..', File.dirname(__FILE__) )
  GAME_SETTINGS = YAML.load_file(File.join GAME_PATH, 'config.yml') rescue nil

  def self.play
    if Warbuck.load
      Game.new
    else puts 'Error : config.yml not found' end
  end

  def self.load
    Dir[ File.join Warbuck::GAME_PATH, 'lib', '**', '*.rb' ]
    .each { |file|
      require file
    } if GAME_SETTINGS
  end

end

