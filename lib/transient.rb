require 'date_time_extensions'

module Transient

  autoload :ActiveRecordExtensions, 'transient/active_record_extensions'
  autoload :Version,                'transient/version'

end

begin
  require 'transient/railtie' if /3\.\d+\.\d+/.match( Rails.version )
rescue
  ActiveRecord::Base.send( :include, Transient::ActiveRecordExtensions ) if defined?( ActiveRecord::Base )
end
