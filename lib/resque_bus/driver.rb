module ResqueBus
  # fans out an event to multiple queues
  class Driver
    
    def self.queue_matches(event_type)
      out = []
      Application.all.each do |app|
        app.event_matches(event_type).each do |match, queue_name|
          out << [match, queue_name]
        end
      end
      out
    end
    
    def self.perform(event_type, attributes = {})
      raise "No event type passed" if event_type == nil || event_type == ""
      attributes ||= {}
      
      queue_matches(event_type).each do |tuple|
        match, queue_name = tuple
        ResqueBus.enqueue_to(queue_name, Rider, match, attributes.merge(:bus_event_type => event_type))
      end
    end

  end
end