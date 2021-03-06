# BarbequeClient [![Build Status](https://travis-ci.org/cookpad/barbeque_client.svg?branch=master)](https://travis-ci.org/cookpad/barbeque_client)

Barbeque client for Ruby.

## Installation

Add this line to your application's Gemfile:

```rb
gem 'barbeque_client'
```

And create "config/initializers/barbeque.rb" and edit it like:

```rb
BarbequeClient.configure do |config|
  config.application   = 'cookpad'
  config.default_queue = 'default'
  config.endpoint      = 'https://barbeque.example.com'
end
```

## Usage
### Enqueuing a job

```rb
execution = BarbequeClient.enqueue(
  job:     'NotifyAuthor',       # @param [String] job     - Job name to enqueue.
  message: { user_id: 7553989 }, # @param [Object] message - An object which is serializable as JSON.
  queue:   'default',            # @param optional [String] queue - A queue name to enqueue a job.
)
execution.message_id #=> "a3c653c1-335e-4d4d-a6f9-eb91c0253d02"
execution.status     #=> "pending"
```

### Polling the job's status

```rb
message_id = "a3c653c1-335e-4d4d-a6f9-eb91c0253d02"
BarbequeClient.status(message_id: message_id) #=> "success"
```

### Distributed tracing
Configure `tracing` option. Pick one of supported tracers.
See more detail in https://github.com/cookpad/garage_client#tracing.

```
BarbequeClient.configure do |config|
  # ...
  config.tracing = { tracer: 'aws-xray', service: 'barbeque' }
end
```
