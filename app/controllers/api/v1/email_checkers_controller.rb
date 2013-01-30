module Api
  module V1
    class EmailCheckersController < Api::V1::ApiController

      before_filter :check_params, :only => [:show]

      def index
        TopLevelDomain.populate_top_level_domains
      end

      def show
         response = TopLevelDomain.validate_email(params[:id], true, true)
         handle_api_response :result => response
      end

      def check_params
        api_error :not_found, :type => 'ObjectNotFound', :message => 'email param is required' unless params[:id]
      end

    end
  end
end