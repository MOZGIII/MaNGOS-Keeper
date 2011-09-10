module MangKeeper

  module Scenario
  
    class Base
      include DBHelpers
      extend InitCheckHelpers
      extend ConfigHelpers::ClassMethods
      
      def storage
        MangKeeper.application.storage
      end
      
      def config
        MangKeeper.application.config
      end
      
      def work
        raise "Work must be defined for scenario!"
      end
      
    end
  
  end  
  
end