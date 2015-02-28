module Ragios
  class Scheduler
    def initialize(ctr)
      @scheduler = Rufus::Scheduler.new
      @controller = ctr
      @work_queue = Ragios::Queue.new
      run_worker
    end
    def unschedule(tag)
      jobs = find(tag)
      jobs.each do |job|
        job.unschedule
      end
    end
    def schedule(args)
      @scheduler.interval args[:time_interval], :first => :now,  :tags => args[:tags] do
        @work_queue.push args[:object]
      end
    end
    def run_worker
      @scheduler.interval '10s' do
        generic_monitor = @work_queue.pop
        if generic_monitor
          puts "Ragios::Scheduler.run_worker - - [#{Time.now}] performing job #{generic_monitor.options.inspect}"
          puts '-' * 80
          controller.perform(generic_monitor)
        end
      end
    end
    def find(tag)
      @scheduler.jobs(tag: tag)
    end
    def all
      @scheduler.jobs
    end
    def controller
      @controller
    end
  end

  class Queue
    def initialize
      @queue = []
    end
    def pop
      return @queue.shift
    end
    def push(item)
      @queue  << item
    end
  end
end
