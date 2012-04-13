module SkipActiveRecordCallbacks
  module ModelHelpers
    def update_without_callbacks
      ModelDecorator.override_run_callbacks_to_skip_save_once(self)
      save
    end
  end

  class ModelDecorator
    def self.override_run_callbacks_to_skip_save_once(model)
      class << model
        alias :run_callbacks_orig :run_callbacks
        def run_callbacks(name, &block)
          if name == :save
            class << self
              undef :run_callbacks
              alias :run_callbacks :run_callbacks_orig
            end
            yield
          else
            run_callbacks_orig(name, &block)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, SkipActiveRecordCallbacks::ModelHelpers)
