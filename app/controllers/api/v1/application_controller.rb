module Api
  module V1
    class ApplicationController < ActionController::API
      def render_result(params)
        params[:root] = "data"
        render params
      end
      
      def render_errors(params)
        params[:status] = :unprocessable_entity
        params[:json] = { errors: params[:json] }
        render params
      end
    end
  end
end
