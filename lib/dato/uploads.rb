# frozen_string_literal: true

module Dato
  class Uploads
    BASE_ITEM_URL = "https://site-api.datocms.com/upload-requests"

    def initialize(api_token)
      @auth_header = "Bearer #{api_token}"

      headers = {
        "Authorization" => @auth_header,
        "Accept" => "application/json",
        "X-Api-Version" => 3
      }
      @http_headers = HTTP.headers(headers)
    end

    def create_from_url(url, filename: nil, attributes: nil, meta: nil)
      file = download_file_from_url(url)
      result = create_from_file(file.path, filename:, attributes:, meta:)
      file.delete

      result
    end

    def create_from_file(path_to_file, filename: nil, attributes: nil, meta: nil)
      request = request_file_upload_permission(filename || path_to_file)
      upload_url = request[:url]
      upload_id = request[:id]

      upload_file_to_bucket(url: upload_url, path: path_to_file)

      job_id = upload_file_to_dato(upload_id:, attributes:)
      upload_id = retrieve_job_result(job_id).parse["data"]["attributes"]["payload"]["data"]["id"]

      {upload_id:}
    end

    def retrieve_job_result(job_id)
      headers = {
        "X-Api-Version" => 3,
        "Authorization" => @auth_header,
        "Accept" => "application/json",
        "Content-Type" => "application/vnd.api+json"
      }

      headers = HTTP.headers(headers)

      headers.get("https://site-api.datocms.com/job-results/#{job_id}")
    end

    private

    def download_file_from_url(url)
      uri = URI.parse(url)
      file_type = File.extname(uri.path)
      file_contents = Net::HTTP.get(uri)
      temp_file = Tempfile.new(["downloaded_file", file_type])
      temp_file.binmode
      temp_file.write(file_contents)
      temp_file.rewind
      temp_file.close

      temp_file
    end

    def request_file_upload_permission(filename)
      data = {
        type: "upload_request",
        attributes: {filename:}
      }

      response = @http_headers.post(BASE_ITEM_URL, json: {data:})
      response = response.parse["data"]

      {
        url: response["attributes"]["url"],
        id: response["id"]
      }
    end

    def upload_file_to_bucket(url:, path:)
      s3_headers = HTTP.headers({"Content-Type" => MimeMagic.by_magic(File.open(path))&.type || "application/octet-stream"})
      s3_headers.put(url, body: File.read(path))
    end

    def upload_file_to_dato(upload_id:, attributes: nil)
      attributes ||= {}

      headers = {
        "Content-Type" => "application/vnd.api+json",
        "X-Api-Version" => 3,
        "Authorization" => @auth_header,
        "Accept" => "application/json"
      }
      headers = HTTP.headers(headers)

      data = {
        type: "upload",
        attributes: {
          path: upload_id,
          **attributes
        }
      }

      response = headers.post("https://site-api.datocms.com/uploads", json: {data:})

      response.parse["data"]["id"]
    end
  end
end
