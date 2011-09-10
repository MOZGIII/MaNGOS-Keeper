module MangKeeper
  
  module ConfigHelpers
    
    module ClassMethods
      def require_config(*args)
        args.each { |conf| MangKeeper.application.config.require(conf) }         
      end
    end
    
  end
  
end