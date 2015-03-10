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

Define endpoints (checks) that should be available under the mount point. Preferred location is an initializer.

```ruby
NjiuStatus::Check.add name: "users", handler: -> (request, response) do
  response.write "{users: #{User.count}}"
  response.status = 200
end

NjiuStatus::Check.add name: "posts", handler: -> (request, response) do
  if Post.failed.any?
    response.write "Error: failed posts"
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
