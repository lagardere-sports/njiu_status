# NjiuStatus

This gem provides a Rack application that supplies the basic structure for diagnostic endpoints. It's meant to be mounted within a Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "njiu_status", git: "git@github.com:njiuko/njiu_status.git"
```
## Usage

Mount the Rack application in your routes file.

```ruby
mount NjiuStatus::RackApp, at: "status"
```

Define endpoints (checks) that should be available under the mount point and restrict access to them by setting a token.

```ruby
NjiuStatus.configure do |config|
  config.token = "foobar123"
end

NjiuStatus.add_check name: "users", handler: -> (request, response) do
  response.write({users: User.count}.to_json)
  response.status = 200
end

NjiuStatus.add_check name: "posts", handler: -> (request, response) do
  if Post.failed.any?
    response.write({error: "There a failed posts!"}.to_json)
    response.status = 418
  else
    response.status = 200
  end
end
```

The example above would generate the following routes:

```
/status/users
/status/posts
```

Each handler has access to the current [request](http://www.rubydoc.info/gems/rack/Rack/Request) and should set the body and status in the [response](http://www.rubydoc.info/gems/rack/Rack/Response
).
