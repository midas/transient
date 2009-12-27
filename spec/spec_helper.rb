$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'active_record'
require 'transient'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

ActiveRecord::Base.configurations = YAML::load( IO.read( File.dirname(__FILE__) + '/database.yml' ) )
ActiveRecord::Base.establish_connection( 'test' )

ActiveRecord::Schema.define :version => 1 do
  create_table :users, :force => true do |t|
    t.string   :name,       :limit => 50
    t.datetime :effective_at
    t.datetime :expiring_at
  end

  create_table :contact_numbers, :force => true do |t|
    t.string :number, :limit => 35
    t.string :location, :limit => 20
    t.datetime :effective_at
    t.datetime :expiring_at
  end
  
  create_table :addresses, :force => true do |t|
    t.string :street, :limit => 75
    t.string :location, :limit => 20
    t.datetime :effective_at
    t.datetime :expiring_at
  end
end

class User < ActiveRecord::Base
  acts_as_transient
end

class ContactNumber < ActiveRecord::Base
  acts_as_transient :single_active => %w(location)
end

class Address < ActiveRecord::Base
  acts_as_transient :single_active => %w(location), :check_exists => %w(street location)
end