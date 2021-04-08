# ruby-html-table

## Usage example
```ruby
# Resources class example
class Car
  attr_accessor :model, :plate

  def initialize(model, plate)
    @model = model
    @plate = plate
  end
end

# Objects
cars = 15.times.map do |i|
  Car.new("model #{i}")
end

# Preparing html table
html_table = HtmlTable.new(
  Car, # Objects class
  cars, # Array wirh all objects
  [:model, :plate], # Array with desired attributes
  { # Config params
    table_id: '', # Optional, if not passed, a hexadecimal hash will be created.
    base_url: '', # Optional. Application base url (Only for rails admin application).
    show_resource_link: '', # Optional. If not pass base url, will be false. Accepts true or false (Only for rails admin application).
    pagination_options: '', # Optional. Array with pagination options. Default_value: [5, 10, 20, 40].
    primary_color: '', # Optional. Primary color of table head, will be used on even head cells. Default value: #5bc0de.
    secondary_color: '' # Optional. Secondary color of table head, will be used on odd head cells. Default value: #5bc0de.
  }
)

# Generating table
html_table.generate!
```

## Locales
This gem accepts locales for attributes keys and attributes values.

```ruby
  # For table head locales, it's just declare the follow method for your resources_class
  def self.locale_key(attribute_name) # receives attribute_name as string or as symbol
    # Your locale method
  end

  # For table body locales, its just declare the follow method for your resources
  def locale_value(attribute_name) # receives attribute_name as string or as symbol
    # Your locale method
  end
```
