module MangKeeper  
  class << self
    def application
      @application ||= Application.new
    end
    
    def scenario
      application.scenario
    end
  end
  
  class Application
  
    DEFAULT_STORAGE_DIR = ".mangkeeper"
    DEFAULT_SCENARIO = "info"
    
    attr_accessor :skip_init_check
    attr_reader :scenario
    
    def initialize
      @skip_init_check = false
    end
    
    def run
      init
      start_scenario
    end
    
    def init
      handle_options
      load_storage
      config
      get_scenario_name
      load_scenario
    end

    
    def options
      @options ||= OpenStruct.new
    end
    
    def storage
      @storage
    end
    
    def config
      @config ||= ConfigManager.new
    end
    
    def initializer
      @initializer = Initializer.new 
    end
    
    def db_readonly?
      !!options.db_readonly
    end
    
    # A list of all the standard options, suitable for
    # passing to OptionParser.
    def standard_options
      [
        ['--db-read-only', '-n', "Do not really execute mysql commands.",
          lambda { |value| options.db_readonly = true }
        ],
        ['--storedir',  '-d', "Specify mangkeeper internal storage directory",
          lambda { |value| options.storagedir = value }
        ],
        ['--version', '-v', "Display the program version.",
          lambda { |value|
            puts "mangkeeper, version #{VERSION}"
            exit
          }
        ],
      ]
    end

    # Read and handle the command line options.
    def handle_options
      OptionParser.new do |opts|
        opts.banner = "mangkeeper scenario {options}"
        opts.separator ""
        opts.separator "Options are ..."

        opts.on_tail("-h", "--help", "-H", "Display this help message.") do
          puts opts
          exit
        end

        standard_options.each { |args| opts.on(*args) }
      end.parse!
    end
    
    private
    
    def load_storage
      storage_dir = options.storagedir || DEFAULT_STORAGE_DIR
      @storage = Storage.new(storage_dir)
    end
    
    def get_scenario_name
      @scenario_name = ARGV[0] || DEFAULT_SCENARIO
    end
    
    def load_scenario
      # Locate scenario
      scenario_classname = "#{@scenario_name}_scenario".classify
      
      checklist = [
        # Search scenario in the storage...
        File.expand_path(File.join(storage.directory, 'scenarios')),
        
        # Search scenario in gem
        'mang_keeper/scenarios',
        
        # In the current directory
        '.',
        './scenarios'      
      ]
      
      # Search
      @scenario_path = nil
      checklist.each do |path|
        file = build_scenario_path(path, scenario_classname.underscore)
        
        load_error = false
        begin
          require file
        rescue LoadError
          load_error = true
        end
        unless load_error
          @scenario_path = file
          break
        end
      end
      raise "Scenario #{@scenario_name} not found!" unless @scenario_path
      
      @scenario = scenario_classname.constantize.new
    end
    
    def build_scenario_path(path, scenario_name, ext = 'rb')
      ext = ".#{ext}" unless ext =~ /^\./
      File.join(path, "#{scenario_name}#{ext}")
    end
    
    def start_scenario
      unless @skip_init_check || MangKeeper.application.storage.init?
        puts("You have to run \"mangkeeper init\" before you can use this command!")
        exit
      end
      config.load_required      
      @scenario.work
    end
  end
  
end

