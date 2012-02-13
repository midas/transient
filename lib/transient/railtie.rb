require 'rails'

module Transient

  class Railtie < ::Rails::Railtie

    initializer "transient.insert_into_active_record" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, Transient::ActiveRecordExtensions
      end
    end

  end

end
