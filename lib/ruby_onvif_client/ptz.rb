require_relative 'service'
Dir.chdir __dir__ do
    require_dir 'ptz'
end

module ONVIF
    class Ptz < Service
    end
end