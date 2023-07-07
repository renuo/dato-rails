# Dato::Rails

Use [DatoCMS](https://www.datocms.com/) in your Rails application.

This gem allows you to fetch data using Dato GraphQL APIs and render the content in your Rails app.

👉 See [this simple tutorial to get started on dev.to](https://dev.to/coorasse/datocms-with-ruby-on-rails-3ae5). 👈

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dato-rails', require: 'dato'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dato-rails

The gem is made of two parts:

## GraphQL client

The GraphQL client based on [GQLi](https://github.com/contentful-labs/gqli.rb) allows to perform
queries to the GraphQL endpoint.
Look at GQLi documentation for more information about the syntax of queries.
You can also find some examples in specs of this library.

Set your api token as `DATO_API_TOKEN` environment variable.

```ruby
client = Dato::Client.new # you can also pass the api token here.
query = GQLi::DSL.query {
  homepage {
    id
  }
}
response = client.execute(query)

puts response.data.homepage.id
```

We provide a fragment to extract a Responsive Image.

```ruby
GQLi::DSL.query {
  homepage {
    id
    content {
      value
      blocks {
        __typename
        id
        image {
          responsiveImage(imgixParams: {fm: __enum("png")}) {
            ___ Dato::Fragments::ResponsiveImage
          }
        }
      }
    }
  }
}
```

## View rendering

The library is also a Rails Engine and provides a whole set of ViewComponents to render your content.
The library aims to provide the most basic components and make it easy to create new one.

Once you fetched the response of a query, you can use the Dato ViewComponents to render the content.

If you have a StructuredText component, you can render it with:

```ruby
render Dato::StructuredText.new(response.data.homepage.content)
```

If you have a responsive image, you can render it with:

```ruby
render Dato::ResponsiveImage.new(node.image.responsiveImage)
```

To define a custom node, you can create a new `Dato::CustomNode` view component in your application and it will be automatically used.

You can also customize how each node type is rendered by specifying the mapping on the single render:

```ruby
render Dato::StructuredText.new(response.data.homepage.content, overrides: { link: Dato::NotRendered })
```

or globally:

```
# config/initializers/dato.rb

Dato::Config.overrides = {
  link: 'Dato::NotRendered'
}.with_indifferent_access
```

## Preview and live

The `Dato::Client` supports both [preview](https://www.datocms.com/docs/pro-tips/how-to-manage-a-live-and-a-preview-site) and [live updates](https://www.datocms.com/docs/real-time-updates-api) features from Dato CMS.

```ruby
Dato::Client.new(preview: true) # to fetch draft versions

client = Dato::Client.new(live: true) # => to fetch a live straming URL 
client.live!(your_query)
# => { url: 'https://your_event_source_url' }
```

A `ViewComponent` is provided to use both these features very easily!

Given that you have a `MyComponent` that takes in input only the result of a dato query,
you probably have the following:

```ruby
result = Dato::Client.new.execute!(my_query)
render(MyComponent.new(result))
```

you can now wrap everything in a `Dato::Live` component like this:

```ruby
render(Dato::Live.new(MyComponent, my_query, preview: true, live: true))
```

and your component will come to life with live updates 🎉 (requires turbo).

## CRUD Operations

The library also provides a set of helpers to perform CRUD operations on Dato CMS.

### All

```ruby
Dato::Client.new.items.all(item_type_id: '456')
```

### Find

```ruby
Dato::Client.new.items.find(item_id: '123')
```

### Create

```ruby
Dato::Client.new.items.create(attributes: { title: 'Hello world' }, item_type_id: '456')
```

### Update

```ruby
Dato::Client.new.items.update(attributes: { title: 'Hello world' }, item_id: '123')
```

### Destroy

```ruby
Dato::Client.new.items.destroy(item_id: '123')
```

## Configuration

The following options are available:

```ruby
# config/initializers/dato.rb

Dato::Config.configure do |config|
  config.overrides = {} # default: {}
  config.blocks = {} # default: {}
  config.cache = false # default: false
  config.cache_namespace = 'dato-rails' # default: 'dato-rails'
  config.publish_key = ENV['DATO_PUBLISH_KEY'] # default: ENV['DATO_PUBLISH_KEY']
  config.build_trigger_id = ENV['DATO_BUILD_TRIGGER_ID'] # default: ENV['DATO_BUILD_TRIGGER_ID']
end
```

## Caching

The library supports caching of the rendered components.
If you enable caching, the components rendered using `Dato::Live`, will be cached.

To enable caching, you need to set the `cache` option in the configuration.

```ruby
# config/initializers/dato.rb

Dato::Config.configure do |config|
  config.cache = 1.day # if you set it to `true`, it will default to 60 minutes
end
```

Now a call to

```ruby
render(Dato::Live.new(MyComponent, my_query))
```

will be cached for 1 day. 

This means that for the next 24 hours, the graphQL endpoint will not be invoked and the whole component rendering will also be skipped.

**We will cache the entire HTML result of the component, not only the graphQL response.**

If you want to expire the cache you have two options:

### manually

executing `Rails.cache.clear(namespace: Dato::Config.cache_namespace)`

### publish endpoint

You can take advantage of the publish mechanism of Dato CMS to expire the cache.
* Mount the `dato-rails` engine in your Rails routes file.
* Set the `DATO_PUBLISH_KEY` environment variable
* Create a build trigger with a custom webhook on your Dato CMS project setting.
* Define the Trigger URL as `https://yourapp.com/dato/publish`
* Set the `DATO_PUBLISH_KEY` as the Authorization header
* Copy the build trigger id and set it as `DATO_BUILD_TRIGGER_ID` environment variable.



## Development

After checking out the repo, run `bundle install` to install dependencies. 

You can now clone the dato-rails project

[![Clone DatoCMS project](https://dashboard.datocms.com/clone/button.svg)](https://dashboard.datocms.com/clone?projectId=57262&name=dato-rails
)


You then need to set a `DATO_API_TOKEN=abcd123x` in the `.env` file on the root of your project
to consume data from your project.

Then, run `bundle exec rspec` to run the tests. 

You can also run `rails console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, 
which will create a git tag for the version, push git commits and the created tag, 
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renuo/dato-rails. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to 
adhere to the [code of conduct](https://github.com/renuo/dato-rails/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dato::Rails project's codebases, issue trackers, chat rooms and mailing lists is 
expected to follow the [code of conduct](https://github.com/renuo/dato-rails/blob/master/CODE_OF_CONDUCT.md).
