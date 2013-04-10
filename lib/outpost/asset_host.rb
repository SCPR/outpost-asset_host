require "outpost/asset_host/version"
require "outpost/asset_host/json_input"
require "outpost/asset_host/join_model_json"

module Outpost
  module AssetHost
    module Rails
      class Engine < ::Rails::Engine
        config.to_prepare do
          ActiveSupport.on_load(:active_record) do
            ActiveRecord::Base.send :include, Outpost::AssetHost::JsonInput
          end
        end
      end
    end
  end
end
