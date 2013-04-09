module Outpost
  module AssetHost
    module JsonInput
      extend ActiveSupport::Concern

      module ClassMethods
        def accepts_json_input_for_assets
          include InstanceMethodsOnActivation
          @assets_association_join_class = self.reflect_on_association(:assets).klass
          
          @assets_association_join_class.send :include, JoinModelMethodsOnActivation
        end

        def assets_association_join_class
          @assets_association_join_class
        end
      end


      module JoinModelMethodsOnActivation
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


      module InstanceMethodsOnActivation
        # Asset Handling
        # Define these methods manually since Rails uses a cache (not method_missing 
        # directly) to call them, and we don't want (or need) to reset that.
        def assets_changed?
          attribute_changed?('assets')
        end

        #-------------------
        # #asset_json is a way to pass in a string representation
        # of a javascript object to the model, which will then be
        # parsed and turned into ContentAsset objects in the 
        # #asset_json= method.
        def asset_json
          current_assets_json.to_json
        end

        #-------------------
        # Parse the input from #asset_json and turn it into real
        # ContentAsset objects. 
        def asset_json=(json)
          # If this is literally an empty string (as opposed to an 
          # empty JSON object, which is what it would be if there were no assets),
          # then we can assume something went wrong and just abort.
          # This shouldn't happen since we're populating the field in the template.
          return if json.empty?

          json = Array(JSON.parse(json)).sort_by { |c| c["position"].to_i }
          loaded_assets = []
          
          json.each do |asset_hash|
            new_asset = self.class.assets_association_join_class.new(
              :asset_id    => asset_hash["id"].to_i, 
              :caption     => asset_hash["caption"].to_s, 
              :position    => asset_hash["position"].to_i
            )
            
            loaded_assets.push new_asset
          end
          
          loaded_assets_json = assets_to_simple_json(loaded_assets)

          # If the assets didn't change, there's no need to bother the database.        
          if current_assets_json != loaded_assets_json
            self.changed_attributes['assets'] = current_assets_json
            self.assets = loaded_assets
          end

          self.assets
        end


        private

        def current_assets_json
          assets_to_simple_json(self.assets)
        end

        def assets_to_simple_json(array)
          Array(array).map(&:simple_json)
        end
      end
    end
  end
end
