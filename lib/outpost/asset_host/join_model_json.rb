module Outpost
  module AssetHost
    module JoinModelJson
      def as_json(options={})
        @as_json ||= begin
          # grab asset as_json, merge in our values
          self.asset.as_json(options).merge!({
            "post_asset_id"   => self.id,
            "caption"         => self.caption,
            "ORDER"           => self.position,
            "credit"          => self.asset.owner
          })
        end
      end


      def simple_json
        @simple_json ||= {
          "id"          => self.asset_id.to_i,
          "caption"     => self.caption.to_s,
          "position"    => self.position.to_i
        }
      end
    end
  end
end
