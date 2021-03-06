require 'smartsheet/constants'

module Smartsheet
  module API
    # Accepts a callable proc and a predicate, calling the proc repeatedly with backoff until the
    # provided time limit is reached, or until the predicate applied to the proc's result returns
    # false.
    class RetryLogic
      include Smartsheet::Constants

      def initialize(max_retry_time: DEFAULT_MAX_RETRY_TIME, backoff_method: DEFAULT_BACKOFF_METHOD)
        @max_retry_time = max_retry_time
        @backoff_method = backoff_method
      end

      def run(should_retry, &method_to_run)
        end_time = Time.now.to_i + max_retry_time

        _run(method_to_run, should_retry, end_time, 0)
      end

      private

      attr_reader :backoff_method, :max_retry_time

      def _run(method_to_run, should_retry, end_time, iteration)
        result = method_to_run.call(iteration)

        backoff = backoff_method.call(iteration, result)

        if backoff == :stop || Time.now.to_i + backoff >= end_time || !should_retry.call(result)
          return result
        end

        sleep backoff
        _run(method_to_run, should_retry, end_time, iteration + 1)
      end
    end
  end
end
