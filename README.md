# Delmo demo - Step 4

In this final step, we will fix the Rails app relative to the current Delmo test.

The Rails app now captures the "PostgreSQL DB missing" error and displays the same static page for all circumstances.

In reality you might want to display different things for different URLs. And that's what Delmo can help you test - do you get the right output for each URL when the DB is missing.

Or, dev/test for any dependency missing - a backend microservice API or email system or caching system, etc. Delmo let's you run a subset of your complete application system and test that it behaves as you'd like.

## The fix

We can capture all DB connection errors, such as `PG::ConnectionBad` for all requests in `app/controllers/application_controller.rb`:

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::NoDatabaseError, with: :no_database_error
  rescue_from PG::ConnectionBad, with: :no_database_error
  protect_from_forgery with: :exception

  def no_database_error
    render "home/no_database_error"
  end
end
```

This code will always show the same HTML page - `app/views/home/no_database_error.html.erb` - for all incoming requests if the database cannot be accessed.

## Successful tests

We can make delmo slightly faster by skipping the step of trying to pull down any new Docker image updates (such as `postgresql` image):

```
delmo -m my-machine --skip-pull
```

The output will now conclude with `home-page-running` passing:

```
...
Executing - <Destroy: [db]>
Killing dboutage_db_1 ... done
Going to remove dboutage_db_1
Removing dboutage_db_1 ... done
Executing - <Wait: db-stopped, Timeout: 30s>
db-stopped |
(1) db-stopped | ++ rake db:version
(1) db-stopped | + [[ X != \X ]]
(1) db-stopped | + echo db cannot be accessed... good.
(1) db-stopped | db cannot be accessed... good.
(1) db-stopped | + exit 0
Executing - <Wait: home-page-running, Timeout: 30s>
(1) home-page-running | HTTP/1.1 200 OK
(1) home-page-running | X-Frame-Options: SAMEORIGIN
(1) home-page-running | X-XSS-Protection: 1; mode=block
(1) home-page-running | X-Content-Type-Options: nosniff
(1) home-page-running | Content-Type: text/html; charset=utf-8
(1) home-page-running | ETag: W/"2a81ff76a97d753c359307c6a222df7a"
(1) home-page-running | Cache-Control: max-age=0, private, must-revalidate
(1) home-page-running | Set-Cookie: _blog_session=MG9NZDg3Vm1IQ2lKb3pWVjg4UForQU83TUlqdXJhT3VCeVNoUXcxdlhxM0orLzMyb2NCcU1RaS9qamF2OXFVSGtrSGYxRkZUemsvWnN4QytQbVludmM2ZkhIaHlBTnByOUhoN09aSlZhUXR4a1MzZzFOZUZkWWxhRXRCUDdjVy9iTlI0N1hkZXFpc05WcE1JWjdhb0VRPT0tLWFLMlZrUlIxMGx2dHZLZW42MU5kcHc9PQ%3D%3D--5713d2c435ed57900f3d04db8bf57a88a6b4015e; path=/; HttpOnly
(1) home-page-running | X-Request-Id: 9442a03c-99b6-40e2-ba5b-768e2400909c
(1) home-page-running | X-Runtime: 0.039395
(1) home-page-running |
Stopping 'db-outage' Runtime...
Stopping dboutage_db_1 ... done
Stopping dboutage_web_1 ... done
Test 'db-outage' completed sucessfully!

SUMMARY:
1 tests succeeded
0 tests failed
```
