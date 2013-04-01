# Outpost::AssetHost

AssetHost integration with Outpost.

Dependencies:
* Outpost
* Backbone, >= 0.9

You should include these dependencies yourself.

## Usage

This gem only provides the client-side interaction. 
It dumps all of the asset information into the hidden `asset_json` input.
You need to handle that information. Here's a simple example:

```ruby
class PostAsset < ActiveRecord::Base
  belongs_to :post

  def as_json(options={})
    @as_json ||= begin
      self.asset.as_json(options).merge!({
        "post_asset_id"   => self.id,
        "caption"         => self.caption,
        "ORDER"           => self.position,
        "credit"          => self.asset.owner
      })
    end
  end

  def asset
    @asset ||= begin
      _asset = AssetHost::Asset.find(self.asset_id)
    
      if _asset.is_a? AssetHost::Fallback
        self.caption = "We encountered a problem, and this photo is currently unavailable."
      end
      
      _asset
    end
  end

  def simple_json
    {
      :id       => self.asset_id.to_i,
      :caption  => self.caption.to_s,
      :position => self.position.to_i
    }
  end
end


class Post < ActiveRecord::Base
  has_many :assets, class_name: "PostAsset"

  def asset_json
    self.assets.map(&:simple_json)
  end

  def asset_json=(val)
    return if json.empty?

    json = Array(JSON.parse(json)).sort_by { |c| c["position"].to_i }
    loaded_assets = []
    
    json.each do |asset_hash|
      new_asset = PostAsset.new(
        :asset_id    => asset_hash["id"].to_i, 
        :caption     => asset_hash["caption"].to_s, 
        :position    => asset_hash["position"].to_i
      )
      
      loaded_assets.push new_asset
    end

    self.assets = loaded_assets
  end
end
```

You'll also need to define a `window.assethost` object, with "SERVER" and "TOKEN":

```coffee
window.assethost =
    SERVER:      "http://assethost.yourserver.com"
    TOKEN:       "{your assethost key}
```

And include the javascript and stylesheet:

```
//= require outpost/asset_host
/* require outpost/assets
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
