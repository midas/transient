require 'date_time_extensions'

module Transient

  autoload :ActiveRecordExtensions, 'transient/active_record_extensions'
  autoload :Version,                'transient/version'

end

ActiveRecord::Base.send( :include, Transient::ActiveRecordExtensions ) if defined?( ActiveRecord::Base )
