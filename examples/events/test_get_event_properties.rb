require_relative "../../lib/ruby_onvif_client"

EM.run do 
    get_event_service_address "192.168.16.106", ->(address) {
        puts "address=",address
        event = ONVIF::Event.new(address)
        event.get_event_properties ->(success, result) {
            if success
                puts "ooooooooooooook"
            end
        }     
    }  
end