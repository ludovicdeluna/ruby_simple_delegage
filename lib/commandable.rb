module Warbuck
  class Commandable

    def can_do?(action)
      self.class::COMMANDS.include? action
    end

    def does(action, options=[])
      return :unknown unless can_do? action
      begin
        self.public_send *( ["do_#{action}"] + options )
      rescue ArgumentError
        learn_this action
      end
    end

    def is_doing(something)
      action, options = understand something
      if (does action, options) == :unknown
        return something
      else
        return nil
      end
    end

    def learn_this(action)
      printf "Woooo... Please, learn to use %s\n", action
    end

    def something
      print "What's now? (do something or list) "
      gets.chomp
    end

    def understand(whatsnow)
      # Reduce multiple space and convert to array (like %w||)
      options = whatsnow.gsub(/\s+/m, ' ').strip.split(" ")
      return [options.slice!(0), options]
    end

    def self.set_commands
      commands = methods_to_commands
      commands = commands + superclass::COMMANDS if parent_has_commands?
      const_set 'COMMANDS', commands if commands
    end

    private

    def self.methods_to_commands
      instance_methods.grep(/^do_/).map(&:to_s).map {|action|
        action.sub(/^do_/, '')
      }
    end

    def self.parent_has_commands?
      defined? superclass::COMMANDS
    end
  end
end
