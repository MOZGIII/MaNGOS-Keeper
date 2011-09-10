module MangKeeper
  class CoreUpdateFile < AbstractUpdateFile
    APPLY_PRIORITY = 1
    
    def self.build filename
      update = File.basename(filename, '.sql').split('_')
      self.new :filename => filename, :database => update[2], :core_revision => update[0].to_i, :num => update[1].to_i
    end
    
    attr_reader :core_revision, :num
    def initialize options = {}
      super
      @core_revision = options[:core_revision]
      @num = options[:num]
      raise "Core revision must be supplied as :core_revision!" unless @core_revision      
    end

    def sort_data
      [core_revision, APPLY_PRIORITY, num]
    end
    
    def info
      "Rev#{core_revision} #{super}"
    end
  end
  
end