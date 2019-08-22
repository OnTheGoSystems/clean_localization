# CleanLocalization
## Simple and minimalistic Ruby localization

# Translation resource example

```yaml
user:
  name: 
    en: User name
    uk: Im`я користувача
header:
  title:
    en: "Hi %{name}!"  
    uk: "Вітаю %{name}!"  
```

# Usage example
```ruby
# Define resources path
CleanLocalization::Config.base_path = Pathname("#{path}/resources")

# Use client
CleanLocalization::Client.new('fr').translate("user.name")

CleanLocalization::Client.new('uk').translate("header.title", name: "John Snow")
CleanLocalization::Client.new('en').translate("header.title", name: "John Snow")

```