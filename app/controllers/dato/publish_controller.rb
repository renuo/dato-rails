require "net/http"
require "uri"

module Dato
  class PublishController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :check, only: :create

    def create
      Rails.cache.clear(namespace: Dato::Config.cache_namespace)

      notify_success

      render json: {message: "ok"}, status: :ok
    end

    def check
      if request.headers["Authorization"] != Dato::Config.publish_key
        render json: {message: "unauthorized"}, status: :unauthorized
      end
    end

    private

    def notify_success
      if Dato::Config.build_trigger_id.present?
        Thread.new do
          sleep 5 # wait for the build to finish
          uri = URI("https://webhooks.datocms.com/#{Dato::Config.build_trigger_id}/deploy-results")
          req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
          req.body = {status: "success"}.to_json
          Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        end
      else
        Rails.logger.info "Dato::Config.build_trigger_id is not set, skipping notification."
      end
    end
  end
end
