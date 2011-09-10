module MangKeeper
  
  class ConfigManager
  
    def initialize
      @configs = {}
      @required_configs_loaded = false
    end
    
    def [](key)
      @configs[key][:data]
    end
    
    def require(config)
      return false if @configs[config]
      @configs[config] = { :loaded => false }
      load_required if @required_configs_loaded
    end
    
    def load_required
      @configs.each do |config, info|
        next if info[:loaded]
        config_data = load(config, nil)
        if config_data
          info[:data] = config_data
          info[:loaded] = true
        else
          raise "Required config was not found: #{config}"
        end
      end
      @required_configs_loaded = true
    end
    
    def dump(config)
      save(config, self[config])
    end
    
    def load(file, default = nil)
      file = filename_check(file)
      data = MangKeeper.application.storage.load(file, nil)
      if data
        JSON.parse(data)
      else
        default
      end
    end
    
    def save(file, data)
      file = filename_check(file)
      MangKeeper.application.storage.save(file, JSON.pretty_generate(data))
    end
    
    private
    
    def filename_check(filename)
      filename = filename.to_s
      filename = filename + ".json" if File.extname(filename) == ""
      filename
    end
    
  end
  
end