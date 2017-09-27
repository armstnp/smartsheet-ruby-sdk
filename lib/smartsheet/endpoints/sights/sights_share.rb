require 'smartsheet/endpoints/share/share'

module Smartsheet
  class SightsShare
    attr_reader :client, :url
    private :client, :url

    def initialize(client)
      @client = client

      @url = ['sights', :sight_id]
    end

    def delete(sight_id:, share_id:, header_overrides: {})
      delete_share(
          share_id: share_id,
          url: url,
          header_overrides: header_overrides,
          sight_id: sight_id
      )
    end

    def get(sight_id:, share_id:, header_overrides: {})
      get_share(
          share_id: share_id,
          url: url,
          header_overrides: header_overrides,
          sight_id: sight_id
      )
    end

    def list(sight_id:, params: {}, header_overrides: {})
      list_share(
          url: url,
          header_overrides: header_overrides,
          params: params,
          sight_id: sight_id
      )
    end

    def create(sight_id:, body:, params: {}, header_overrides: {})
      create_share(
          url: url,
          header_overrides: header_overrides,
          params: params,
          body: body,
          sight_id: sight_id
      )
    end

    def update(sight_id:, share_id:, body:, header_overrides: {})
      update_share(
          share_id: share_id,
          url: url,
          header_overrides: header_overrides,
          body: body,
          sight_id: sight_id
      )
    end

    private

    include Smartsheet::Share
  end
end