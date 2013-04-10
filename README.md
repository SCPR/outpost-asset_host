# Outpost::AssetHost

AssetHost integration with Outpost.

Dependencies:
* Outpost
* Backbone, >= 0.9

You should include these dependencies yourself.

## Usage

```ruby
class PostAsset < ActiveRecord::Base
  belongs_to :post
end


class Post < ActiveRecord::Base
  has_many :assets, class_name: "PostAsset"
  accepts_json_input_for_assets
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

/*
*= require outpost/assets
*/
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
