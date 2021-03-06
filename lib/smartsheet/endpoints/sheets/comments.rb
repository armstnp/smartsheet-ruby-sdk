require 'smartsheet/endpoints/sheets/comments_attachments'

module Smartsheet
  # Comments Endpoints
  # @see https://smartsheet-platform.github.io/api-docs/?ruby#comments API Comments Docs
  #
  # @!attribute [r] attachments
  #   @return [CommentsAttachments]
  class Comments
    attr_reader :client, :attachments
    private :client

    def initialize(client)
      @client = client

      @attachments = CommentsAttachments.new(client)
    end

    def add(sheet_id:, discussion_id:, body:, params: {}, header_overrides: {})
      endpoint_spec = Smartsheet::API::EndpointSpec.new(:post, ['sheets', :sheet_id, 'discussions', :discussion_id, 'comments'], body_type: :json)
      request_spec = Smartsheet::API::RequestSpec.new(
          header_overrides: header_overrides,
          params: params,
          body: body,
          sheet_id: sheet_id,
          discussion_id: discussion_id
      )
      client.make_request(endpoint_spec, request_spec)
    end

    def update(sheet_id:, comment_id:, body:, params: {}, header_overrides: {})
      endpoint_spec = Smartsheet::API::EndpointSpec.new(:put, ['sheets', :sheet_id, 'comments', :comment_id], body_type: :json)
      request_spec = Smartsheet::API::RequestSpec.new(
          header_overrides: header_overrides,
          params: params,
          body: body,
          sheet_id: sheet_id,
          comment_id: comment_id
      )
      client.make_request(endpoint_spec, request_spec)
    end

    def delete(sheet_id:, comment_id:, params: {}, header_overrides: {})
      endpoint_spec = Smartsheet::API::EndpointSpec.new(:delete, ['sheets', :sheet_id, 'comments', :comment_id])
      request_spec = Smartsheet::API::RequestSpec.new(
          params: params,
          header_overrides: header_overrides,
          sheet_id: sheet_id,
          comment_id: comment_id
      )
      client.make_request(endpoint_spec, request_spec)
    end

    def get(sheet_id:, comment_id:, params: {}, header_overrides: {})
      endpoint_spec = Smartsheet::API::EndpointSpec.new(:get, ['sheets', :sheet_id, 'comments', :comment_id])
      request_spec = Smartsheet::API::RequestSpec.new(
          params: params,
          header_overrides: header_overrides,
          sheet_id: sheet_id,
          comment_id: comment_id
      )
      client.make_request(endpoint_spec, request_spec)
    end
  end
end