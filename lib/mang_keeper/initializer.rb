module MangKeeper
    
  class Initializer
    INIT_GENERATORS_DIR = File.join(File.dirname(__FILE__), "init_generators")

    class InitContext
      def initialize(filename)
        @filename = filename
      end
      
      def application
        MangKeeper.application
      end
    
      def config
        application.config
      end
      
      def storage
        application.storage
      end
    end
    
    # This is an internal ruby constructor!!
    def initialize
      collect_init_scripts
    end
    
    def run    
      prepare_storage_dir
      run_init_scripts
    end
    
    private
    
    def collect_init_scripts
      @init_scripts = Dir[File.join(INIT_GENERATORS_DIR, "*.rb")]
    end
    
    def run_init_scripts
      @init_scripts.each do |init_script|
        InitContext.new(init_script).instance_eval(File.read(init_script))
      end
    end
    
    def prepare_storage_dir
      Dir.mkdir(MangKeeper.application.storage.directory) unless File.directory?(MangKeeper.application.storage.directory)      
    end

  end

end

