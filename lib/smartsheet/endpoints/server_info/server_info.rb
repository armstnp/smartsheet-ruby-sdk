module Smartsheet
  # Server Information Endpoints
  # @see https://smartsheet-platform.github.io/api-docs/?ruby#server-information API Server
  #   Information Docs
  class ServerInfo
    attr_reader :client
    private :client

    def initialize(client)
      @client = client
    end

    def get(params: {}, header_overrides: {})
      endpoint_spec = Smartsheet::API::EndpointSpec.new(:get, ['serverinfo'], no_auth: true)
      request_spec = Smartsheet::API::RequestSpec.new(
          params: params,
          header_overrides: header_overrides,
      )
      client.make_request(endpoint_spec, request_spec)
    end
  end
end