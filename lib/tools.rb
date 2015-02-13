module Warbuck
  module Tools

    def self.path_to_constant(path)
      to_camelcase(File.basename path, '.rb').to_sym
    end

    def self.to_underscore(name)
      name.gsub(/([^\^])([A-Z])/,'\1_\2').downcase
    end

    def self.to_camelcase(name)
      name.split("_").map(&:capitalize).join
    end

    def self.root_ns
      self.to_s.split('::').first
    end

    def self.camelcase_to_module(item, path=nil)
      path &&= "::" + path.split('/').map(&:capitalize).join("::")
      Module.const_get("#{Tools.root_ns}#{path}::#{item}") rescue nil
    end

    def self.camelcase_to_method(action)
      Tools.to_underscore(action.to_s).to_sym
    end

  end
end
