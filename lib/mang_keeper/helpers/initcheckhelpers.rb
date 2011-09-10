module MangKeeper
  
  module InitCheckHelpers
  
    def skip_init_check!
      MangKeeper.application.skip_init_check = true
    end
    
  end

end