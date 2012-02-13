$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'date_time_extensions'
# require 'transient/active_record_extensions'

module Transient

  autoload :ActiveRecordExtensions, 'transient/active_record_extensions'
  autoload :Version,                'transient/version'

end

ActiveRecord::Base.send( :include, Transient::ActiveRecordExtensions ) if defined?( ActiveRecord::Base )
