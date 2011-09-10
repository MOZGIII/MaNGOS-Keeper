module MangKeeper
  class Sd2MrUpdateFile < AbstractUpdateFile
    APPLY_PRIORITY = 1
    
    def self.build filename
      update = File.basename(filename, '.sql').split('_')
      self.new :filename => filename, :database => update[1], :mr_revision => update[0].to_i!
    end
    
    attr_reader :mr_revision
    def initialize options = {}
      super
      @mr_revision = options[:mr_revision]
      raise "MR revision must be supplied as :mr_revision!" unless @mr_revision      
    end

    def sort_data
      [mr_revision, APPLY_PRIORITY]
    end
    
    def info
      "Rev#{mr_revision} #{super}"
    end
  end
  
end