class InitScenario < MangKeeper::Scenario::Base
  skip_init_check!

  def work
    MangKeeper.application.initializer.run
    puts <<-MSG.gsub(/^ */, "")
      Initialized MangKeeper in #{storage.directory}

      Now you should visit #{storage.directory} and do some configuration...
    MSG
  end

end