module MangKeeper

  class Storage  
    attr_reader :directory
    
    def initialize(dir)
      @directory = dir
      # warn "Storage directory #{directory} does not exist!" unless File.directory?(directory)      
    end
    
    def save(file, data)
      File.open(File.join(directory, file.to_s), "w") do |f|
        f.write(data)
      end
    end
    
    # Load file with default value on error
    def load(file, default = nil)  
      load!(file)
    rescue Errno::ENOENT
      default
    end
    
    # Load JSON file with exception
    def load!(file)
      File.read(File.join(directory, file.to_s))    
    end
    
    # Is current storage directory initialized with mangkeeper?
    def init?
      File.directory?(directory) 
    end
  end

end