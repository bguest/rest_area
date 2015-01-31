[![Code Climate](https://codeclimate.com/github/bguest/rest_area.png)](https://codeclimate.com/github/bguest/rest_area) [![Build Status](https://travis-ci.org/bguest/rest_area.png?branch=master)](https://travis-ci.org/bguest/rest_area) [![Coverage Status](https://coveralls.io/repos/bguest/rest_area/badge.png)](https://coveralls.io/r/bguest/rest_area) [![Gem Version](https://badge.fury.io/rb/rest_area.png)](http://badge.fury.io/rb/rest_area) [![Dependency Status](https://gemnasium.com/bguest/rest_area.png)](https://gemnasium.com/bguest/rest_area)

# RestArea

This gem adds a bare bones rest api to a rails application. Simply
create the initilizer file with the classes that you want to be in the
rest api and you will get the get basic rest routes for that class
This project rocks and uses MIT-LICENSE.

## Versions

This library supports both Rails 3.2.x and Rails 4.1.x.

### Rails 3.2.x
If you are using Rails 3.2.x you should use the `rails-3_2` branch and/or version/tags 1.x.x, ie

    gem 'rest_area', '~>1.0'

### Rails 4.1.x
If you are using Rails 4.1.x you should use the master branch and/or versions/tags 2.x.x, ie

    gem 'rest_area', '~>2.0'

## Initialization / Setup

1. Create a file called `rest_area.rb` in your initializers file
2. Add configuration like the following in that file.

        RestArea.configure do
          resources :thing_one, :thing_two     # Defaults to all actions

          resources :cereal, :thing do
            action :index, :show, :create, :update, :delete
            key :name
            headers({
              'Cache-Control' => 'public, max-age=86400'
              'Expires' => ->{Date.today + 1}
            })
          end

          resource :supermarket do
            read_only!
            messages :say_hello, :ring_it_up
          end
        end

  Alternatively you can still just pass in a class whitelist, but this is being deprecated.

        RestArea.class_whitelist = [YourModel, ThatYouWant, ToBeInYour, RestApi]


3. Add something like the following to your `config/routes.rb` file.

        mount RestArea::Engine => "/your_base_route"

### Config Settings

Within the RestArea.config block, use `resource` to specify a single resource and `resources` to specify mulitiple resources

With in the `resource` / `resources` block,
+ Use `action` to specify what actions that resource will respond to, the available actions are
  `:index`, `:show`, `:create`, `:create`, `:update`, and `:delete`, the default is to use all actions

+ Use `read_only!` to specify that the resource will only respond to the `index` and `show` actions

+ Use `key` to specify what column rest_area will use to look up a resource. This is the column name
  that is used for the `:key` in `/:resource/:key` part of the restful path. This defaults to `:id`

+ Use `message` or `messages` to whitelist methods for a class. Methods much be defined at
  launch. Methods must respond with an object that responds to `.to_json`

+ Use `headers` to specify the response headers hash, this will be merged with existing headers

# Serializers

But what if I want to customize the JSON that comes back? Simple this
gem supports [active_model_serializer][1]. Go there, ignore the stuff
about controllers.

*NOTE* You must use AMS 0.8.x, things are not working for AMS 0.9.x+

[1]:https://github.com/rails-api/active_model_serializers
