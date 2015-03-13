# NjiuStatus

This gem provides a Rack application that supplies the basic structure for diagnostic endpoints. It's meant to be mounted within a Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "njiu_status", git: "git@github.com:njiuko/njiu_status.git"
```
## Setup

Mount the Rack application in your routes file.

```ruby
mount NjiuStatus::RackApp, at: "status"
```

Define endpoints (checks) that should be available under the mount point and restrict access to them by setting a token. ProTip: Put this into an initializer.

```ruby
NjiuStatus.configure do |config|
  config.token = "foobar123"
end

NjiuStatus.add_check name: "users", handler: -> (request, response) do
  begin
    response.write({users: User.first.name}.to_json)
    response.status = 200
  rescue NoMethodError
    response.write({error: "No users in database."}.to_json)
    response.status = 500
  end
end

NjiuStatus.add_check name: "posts", handler: -> (request, response) do
  if Post.failed.any?
    response.write({error: "There a failed posts."}.to_json)
    response.status = 418
  else
    response.status = 200
  end
end

# example for usage with nagios plugin 'check_json.rb'
NjiuStatus.add_check name: "nagios", handler: -> (request, response) do
  if SystemCheck.ok?
    response.write({message: "Everything went better than expected :)", exit_code: NjiuStatus::EXIT_OK}.to_json)
  elsif SystemCheck.failed?
    response.write({message: "Something went terribly wrong.", exit_code: NjiuStatus::EXIT_CRITICAL}.to_json)
  elsif SystemCheck.high_load?
    response.write({message: "It's gettin' hot in here.", exit_code: NjiuStatus::EXIT_WARNING}.to_json)
  end
end
```

## Usage

The example above generates the following routes:
```
/status/users
/status/posts
/status/nagios
```

If a token was configured it has to be supplied in every call either via a HTTP header (preferred) or as a query param.

```
curl -I -H"Authorization: Token foobar123" http://localhost:3000/status/users

curl -I http://localhost:3000/status/users?token=foobar123
```

Within a check each handler has access to the current [request](http://www.rubydoc.info/gems/rack/Rack/Request) and should set the body and status in the [response](http://www.rubydoc.info/gems/rack/Rack/Response).

The gem provides basic error handling if an exception is raised within the handler. Nevertheless: each check should rescue possible exceptions itself and always return a valid response.


## Development & Testing

Install all necessary dependencies:

```ruby
bundle
appraisal install
```

Run specs without integration tests:

```ruby
rspec
```

Run specs with integrations tests for Rails 3 and Rails 4:

```ruby
appraisal rspec
```
