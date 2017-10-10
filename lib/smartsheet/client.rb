require 'smartsheet/api/faraday_adapter/faraday_net_client'
require 'smartsheet/api/retry_net_client_decorator'
require 'smartsheet/api/response_net_client_decorator'
require 'smartsheet/api/request_client'
require 'smartsheet/api/retry_logic'
require 'smartsheet/api/request_logger'
require 'smartsheet/general_request'

require 'smartsheet/endpoints/contacts/contacts'
require 'smartsheet/endpoints/favorites/favorites'
require 'smartsheet/endpoints/folders/folders'
require 'smartsheet/endpoints/groups/groups'
require 'smartsheet/endpoints/home/home'
require 'smartsheet/endpoints/reports/reports'
require 'smartsheet/endpoints/search/search'
require 'smartsheet/endpoints/server_info/server_info'
require 'smartsheet/endpoints/sheets/sheets'
require 'smartsheet/endpoints/sights/sights'
require 'smartsheet/endpoints/templates/templates'
require 'smartsheet/endpoints/token/token'
require 'smartsheet/endpoints/update_requests/update_requests'
require 'smartsheet/endpoints/users/users'
require 'smartsheet/endpoints/webhooks/webhooks'
require 'smartsheet/endpoints/workspaces/workspaces'


module Smartsheet
  class Client
    include GeneralRequest
    include Smartsheet::Constants

    attr_reader :contacts, :favorites, :folders, :groups, :home, :reports, :search, :server_info,
                :sheets, :sights, :templates, :token, :update_requests, :users, :webhooks,
                :workspaces

    def initialize(
        token: nil,
        assume_user: nil,
        json_output: false,
        max_retry_time: nil,
        backoff_method: nil,
        logger: nil,
        log_full_body: false,
        base_url: API_URL
    )

      request_logger =
          logger ?
              API::RequestLogger.new(logger, log_full_body) :
              API::MuteRequestLogger.new

      token = token_env_var if token.nil?

      net_client = API::FaradayNetClient.new

      retry_logic = init_retry_logic(max_retry_time, backoff_method)

      retrying_client = API::RetryNetClientDecorator.new(
          net_client,
          retry_logic,
          logger: request_logger
      )

      response_client = API::ResponseNetClientDecorator.new(
          retrying_client,
          json_output: json_output
      )

      @client = API::RequestClient.new(
          token,
          response_client,
          base_url,
          assume_user: assume_user,
          logger: request_logger
      )

      build_categories
    end

    private

    attr_reader :client

    def build_categories
      @contacts = Contacts.new(client)
      @favorites = Favorites.new(client)
      @folders = Folders.new(client)
      @groups = Groups.new(client)
      @home = Home.new(client)
      @reports = Reports.new(client)
      @search = Search.new(client)
      @server_info = ServerInfo.new(client)
      @sheets = Sheets.new(client)
      @sights = Sights.new(client)
      @token = Token.new(client)
      @templates = Templates.new(client)
      @update_requests = UpdateRequests.new(client)
      @users = Users.new(client)
      @webhooks = Webhooks.new(client)
      @workspaces = Workspaces.new(client)
    end

    def init_retry_logic(max_retry_time, backoff_method)
      retry_opts = {}
      retry_opts[:max_retry_time] = max_retry_time unless max_retry_time.nil?
      retry_opts[:backoff_method] = backoff_method unless backoff_method.nil?

      API::RetryLogic.new(**retry_opts)
    end

    def token_env_var
      ENV['SMARTSHEET_ACCESS_TOKEN']
    end
  end
end