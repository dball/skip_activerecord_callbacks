module SkipActiverecordCallbacks
  class Railtie < Rails::Railtie
    initializer "skip_activerecord_callbacks" do |app|
      ActiveSupport.on_load(:active_record) do
        require 'skip_activerecord_callbacks/model_helpers'
      end
    end
  end
end
