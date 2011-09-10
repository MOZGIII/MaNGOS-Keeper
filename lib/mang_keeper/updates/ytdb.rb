module MangKeeper
  class YTDBUpdateFile < AbstractUpdateFile
    APPLY_PRIORITY = 5
    
    def self.build filename
      update = File.basename(filename, '.sql').split('_')
      return if update[1] == 'corepatch' # skip all corepatches...      
      self.new :filename => filename, :database => update[1], :core_revision => update[3].to_i!
    end
    
    attr_reader :core_revision
    def initialize options = {}
      super
      @core_revision = options[:core_revision]
      raise "Core revision must be supplied as :core_revision!" unless @core_revision
    end

    def sort_data
      [core_revision, APPLY_PRIORITY]
    end
    
    def info
      "Rev#{core_revision} #{super}"
    end
  end
  
end