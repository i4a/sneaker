# Sneaker

Sneaker lets you launch a rails command in multiple capistrano stages simultaneously

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sneaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sneaker

## Usage

Use any command like inside a `rails console` 

```sh
sneaker User.count
```

Escape commands with single quotes
```sh
sneaker 'User.where(updated_at: 1.week.ago..1.day.ago).map(&:login)'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i4a/sneaker.
