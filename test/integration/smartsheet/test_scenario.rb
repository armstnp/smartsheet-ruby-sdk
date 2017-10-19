require_relative '../integration_test_helper'
require 'logger'

class TestScenario
  TOKEN = 'TOKEN'
  BASE_URL = 'http://localhost:8082'

  def self.run(scenario)
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG

    client = Smartsheet::Client.new(
        token: TOKEN,
        logger: logger,
        base_url: BASE_URL,
        base_headers: { 'Api-Scenario': scenario }
    )

    yield client
  end
end