# RestArea

This gem adds a off bare bones rest api to a rails application. Simply
create the initilizers file with the classes that you want to be in the
rest api and you will get the get basic rest routes for that class
This project rocks and uses MIT-LICENSE.

## Versions

This library supports both Rails 3.2.x and Rails 4.1.x.

### Rails 3.2.x
If you are useing Rails 3.2.x you should use the `rails-3_2` branch and/or version/tags 1.x.x, ie

    gem 'rest_area', '~>1.0'

### Rails 4.1.x
If you are using Rails 4.1.x you should use the master branch and/or versions/tags 2.x.x, ie

    gem 'rest_area', '~>2.0'

## Initilization / Setup

1. Create a file called `rest_area.rb` in your initilizers file
2. Add something the following in that file.

        RestArea.class_whitelist = [YourModel, ThatYouWant, ToBeInYour, RestApi]

3. Add something like the following to your `config/routes.rb` file.

        mount RestArea::Engine => "/your_base_route"

# Serializers

But what if I want to customize the JSON that comes back? Simple this
gem supports [active_model_serializer][1]. Go there, ignore the stuff
about controllers.

[1]:https://github.com/rails-api/active_model_serializers
