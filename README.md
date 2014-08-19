# Fetching

Turn deeply nested hashes and arrays (like an API response) into a whiney object with method syntax.

## Usage

```ruby
Fetching(HTTParty.get(url, query: query)).forms[0].request_form_id

# fails loudly unless the response from HTTParty has a top level `forms` key
# fails loudly if `forms` is an empty array
# fails loudly if the first `form` doesn't have a `request_form_id` key
```

Or, if you prefer to learn from slide decks -- [As presented at RailsConf 2014](http://dapplebeforedawn.github.io/fetching-gem-talk)

## Installation

Add this line to your application's Gemfile:

    gem 'fetching'

And then execute:

    $ bundle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
