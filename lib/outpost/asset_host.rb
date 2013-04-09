require "outpost/asset_host/version"
require "outpost/asset_host/json_input"

module Outpost
  module AssetHost
    module Rails
      class Engine < ::Rails::Engine
      end
    end
  end
end

ActiveRecord::Base.send :include, Outpost::AssetHost::JsonInput
