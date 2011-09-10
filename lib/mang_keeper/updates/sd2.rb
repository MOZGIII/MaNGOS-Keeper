module MangKeeper
  class Sd2UpdateFile < AbstractUpdateFile
    APPLY_PRIORITY = 1
    
    def self.build filename
      update = File.basename(filename, '.sql').split('_')
      self.new :filename => filename, :database => update[1], :sd2_revision => update[0].to_i!
    end
    
    attr_reader :sd2_revision
    def initialize options = {}
      super
      @sd2_revision = options[:sd2_revision]
      raise "SD2 revision must be supplied as :sd2_revision!" unless @sd2_revision      
    end

    def sort_data
      [sd2_revision, APPLY_PRIORITY]
    end
    
    def info
      "Rev#{sd2_revision} #{super}"
    end
  end
  
end