# rbs_activerecord

rbs_activerecord is a RBSGenerator for models built with ActiveRecord.

## Installation

Add a new entry to your Gemfile and run `bundle install`:

    group :development do
      gem 'rbs_activerecord', require: false
    end

After the installation, please run rake task generator:

    bundle exec rails g rbs_activerecord:install

## Usage

Run `rbs:activerecord:setup` task:

    bundle exec rake rbs:activerecord:setup

Then rbs_activerecord will scan your code and generate RBS files into
`sig/activerecord` directory.

## The goal of rbs_activerecord

rbs_activerecord is an experimental project to enhance the type generation for ActiveRecord models.
It is strongly inspired by [rbs_rails](https://github.com/pocke/rbs_rails).

The goal of this gem is to give feedbacks to the rbs_rails project, and improving rbs_rails.
One of the large goals is merging this gem into rbs_rails.

Main differences between rbs_activerecord and rbs_rails are:

* New features
    * Support Rails7 style enum definitions ([#268](https://github.com/pocke/rbs_rails/pull/268))
    * Support STI (Single Table Inheritance) models ([#287](https://github.com/pocke/rbs_rails/pull/287))
        * Inherits scope, enum and other definitions in the parent class to the child class
    * Support has_and_belongs_to_many association ([#272](https://github.com/pocke/rbs_rails/pull/272))
    * Support `alias_attribute` ([#263](https://github.com/pocke/rbs_rails/pull/263))
    * Support generating model definitions within the concern module ([#209](https://github.com/pocke/rbs_rails/pull/209))
    * Support extension ActiveRecord from 3rd party gems ([#254](https://github.com/pocke/rbs_rails/pull/254))
        * ex. kaminari
    * Support composite primary keys ([#275](https://github.com/pocke/rbs_rails/pull/275))
    * Extend return types of #pluck ([#273](https://github.com/pocke/rbs_rails/pull/273))
    * Override types of CollectionProxy ([#289](https://github.com/pocke/rbs_rails/pull/289))
* Bug fixes
    * [#290](https://github.com/pocke/rbs_rails/pull/290)
    * [#286](https://github.com/pocke/rbs_rails/pull/286)
    * [#285](https://github.com/pocke/rbs_rails/pull/285)
    * [#278](https://github.com/pocke/rbs_rails/pull/278)
    * [#277](https://github.com/pocke/rbs_rails/pull/277)
    * [#233](https://github.com/pocke/rbs_rails/pull/233)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also
run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then put
a git tag (ex. `git tag v1.0.0`) and push it to the GitHub. Then GitHub Actions
will release a new package to [rubygems.org](https://rubygems.org) automatically.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tk0miya/rbs_activerecord.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [code of conduct](https://github.com/tk0miya/rbs_activerecord/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the rbs_activerecord project's codebases, issue trackers is expected to
follow the [code of conduct](https://github.com/tk0miya/rbs_activerecord/blob/main/CODE_OF_CONDUCT.md).
