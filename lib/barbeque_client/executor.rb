require 'json'

module BarbequeClient
  class Executor
    # @param [String] job - Job class name
    # @param [String] message - JSON-serialized object
    # @param [String] message_id - SQS mesasge_id
    # @param [String] queue_name - barbeque's job_queues.name
    def initialize(job:, message:, message_id:, queue_name:)
      @job        = job
      @message_id = message_id
      @queue_name = queue_name

      parsed_message = JSON.load(message)

      # `arguments` in ActiveJob::Base.execute is expected as Array
      # and it expands to the arguments for AJ::Base#perform.
      # So when message is not an Array, it's converted to a 1-element Array.
      if parsed_message.is_a?(Array)
        @message = parsed_message
      else
        @message = [parsed_message]
      end
    end

    def run
      ActiveJob::Base.execute(
        'job_class'  => @job,
        'job_id'     => @message_id,
        'queue_name' => @queue_name,
        'arguments'  => @message,
      )
    end
  end
end
