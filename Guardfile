#!/usr/bin/env ruby

guard 'rspec', :version => 2, :all_on_start => true, :all_after_pass => true, :cli => '--debugger --color --format doc' do
  watch( %r{^spec/.+_spec\.rb$} )
  watch( %r{^lib/(.+)\.rb$} )     { |m| "spec/#{m[1]}_spec.rb" }
  watch( 'spec/spec_helper.rb' )  { "spec" }
end
