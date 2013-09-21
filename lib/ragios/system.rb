module Ragios 

#hides the messy details of the scheduler from users 
#provides an easy interface to start monitoring the system by calling Ragios::System start monitoring 
 class System
   
    attr_accessor :ragios
    
    def initialize
    end
    
    def self.start monitoring    
     @ragios = Ragios::Schedulers::RagiosScheduler.new monitoring
     @ragios.init
     @ragios.start 
     #returns a list of active monitors
     @ragios.get_monitors
    end
 end

end

