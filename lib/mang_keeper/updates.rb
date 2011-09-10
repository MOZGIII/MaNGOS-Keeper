module MangKeeper

  class UpdatesList
  
    def self.run &block
      self.new.tap{ |list| list.instance_eval(&block) }
    end
  
    def initialize
      @list = []
      @filters = {}
    end
    
    # Allows tobind filter for specific update class
    # Update will only be added if filter value is true
    def filter(class_names, filter_code = nil, &block)
      filter_code = block unless filter_code
      raise ArgumentError, "You must pass a block or a proc as a second argument!" unless filter_code
      class_names = [class_names] unless class_names.kind_of?(Array)
      class_names.each do |class_name|
        @filters[class_name] ||= []
        @filters[class_name] << filter_code
      end
      self
    end
    
    def add(update)
      return false if @filters[update.class].any? { |filter_proc| filter_proc && !filter_proc.call(update) }      
      add!(update)
    end
    
    def add!(update)
      @list << update
    end
    
    def scan_by_glob(glob, updates_type)
      Dir.glob(glob).each do |filename|
        update = updates_type.build filename
        add update if update
      end
      self
    end
    alias_method :[], :scan_by_glob
    
    def apply_all(read_only = false)
      sorted_list.each do |update|
        filename, database = update.upload_info
        if read_only
          puts "Will upload #{filename} to #{database} [#{update.class.name}]"
        else          
          MangKeeper.scenario.upload_file_to_db(filename, database)
        end
        update.applied!
      end
    end
    
    def to_s
      sorted_list.map(&:to_s).join("\n")
    end
    
    private
    
    def sorted_list
      @list.sort! do |a,b|
        a, b = a.sort_data, b.sort_data
        i = 0
        i+=1 while a[i] == b[i] && (a[i+1] || b[i+1])
        if a[i] && b[i]
          a[i] <=> b[i]
        else
          a[i] ? 1 : -1
        end
      end
      @list
    end
  end

  class AbstractUpdateFile
    attr_reader :filename, :database
    
    def self.build(filename)
      self.new :filename => filename
    end
    
    def initialize(options = {})
      @filename = options[:filename]
      @database = options[:database] # silently ignore if its nil and upload to default db
      raise "Full filename must be supplied as :filename!" unless @filename      
    end
    
    def upload_info
      [self.filename, self.database]
    end
    
    def sort_data
      []
    end
    
    def applied?
      @applied
    end
    
    def applied!
      @applied = true
    end
    
    def to_s
      info
    end
    
    def info
      "[#{self.class.name}:#{filename}]"
    end
  end
end
