# RestArea

This gem adds a off bare bones rest api to a rails application. Simply
create the initilizers file with the classes that you want to be in the
rest api and you will get the get basic rest routes for that class
This project rocks and uses MIT-LICENSE.

## Initilization

1. Create a file called rest_area.rb in your initilizers file
2. Add something the following in that file.

        RestArea.class_whitelist = [YourModel, ThatYouWant, ToBeInYour, RestApi]

3. Add something like the following to your routes file.

        mount RestArea::Engine => "/your_base_route"

