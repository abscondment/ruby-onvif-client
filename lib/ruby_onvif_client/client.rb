require "em-http"
require 'log_switch'
require "nokogiri"
require "nori"

module ONVIF
    class Client
        extend LogSwitch
        self.logger.datetime_format = "%Y-%m-%d %H:%M:%S "

        def initialize options
            @options = {
                connect_timeout: 5,
            }.merge(options)
        end

        def send data
            ONVIF::Client.log "send data to #{@options} "
            ONVIF::Client.log data
            http_options = {
                connect_timeout: @options[:connect_timeout]
            }
            request_options = {
                body: data
            }
            http = EventMachine::HttpRequest.new(
                @options[:address],
                http_options
            ).post(request_options)
            http.errback { yield false, {} }
            http.callback do
                ONVIF::Client.log "========================="
                ONVIF::Client.log "receive message =>"
                ONVIF::Client.log http.response
                ONVIF::Client.log "========================="
                if http.response_header.status != 200
                    yield false, {header: http.response_header}
                else
                    #nori = Nori.new(:strip_namespaces => true)
                    yield true, {
                        header: http.response_header,
                        #content: nori.parse(http.response)
                        content: http.response
                    }
                end
            end
        end
    end
end
