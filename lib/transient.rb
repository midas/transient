$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'date_time_extensions'
require 'transient/active_record_extensions'

module Transient
  VERSION = '1.0.0'
end

ActiveRecord::Base.send( :include, Transient::ActiveRecordExtensions ) if defined?( ActiveRecord::Base )