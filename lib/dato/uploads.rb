module Dato
  class Uploads
    BASE_ITEM_URL = 'https://site-api.datocms.com/upload-requests'

    def initialize(api_token)
      @auth_header = "Bearer #{api_token}"

      headers = {
        'Authorization' => @auth_header,
        'Accept' => 'application/json',
        'X-Api-Version' => 3
      }
      @http_headers = HTTP.headers(headers)
    end

    def create_from_url(url:, attributes: {}, meta: {})
      file = download_file_from_url(url)
      create(path_to_file: file.path, attributes:, meta:)
    end

    def create(path_to_file:, attributes:, meta: nil)
      # Step 1: Request file upload permission
      request = request_file_upload_permission(path_to_file)
      upload_url = request[:url]
      upload_id = request[:id]

      # Step 2: Upload file to storage bucket
      upload_file_to_bucket(url: upload_url, path: path_to_file)

      # Step 3: Create the actual upload
      upload_file_to_dato(upload_id:, attributes:, meta:)

      # Step 4: Retrieve Job result (via polling...)
    end

    def retrieve_job_result(job_id:)
      headers = {
        'X-Api-Version' => 3,
        'Authorization' => @auth_header,
        'Accept' => 'application/json',
        'Content-Type' => 'application/vnd.api+json'
      }

      headers = HTTP.headers(headers)

      headers.get("https://site-api.datocms.com/job-results/#{job_id}")
    end

    private

    def download_file_from_url(url)
      uri = URI.parse(url)
      file_type = File.extname(uri.path)
      file_contents = Net::HTTP.get(uri)
      temp_file = Tempfile.new(['downloaded_file', file_type])
      temp_file.binmode
      temp_file.write(file_contents)
      temp_file.rewind
      temp_file.close

      temp_file
    end

    def request_file_upload_permission(path)
      data = {
        type: 'upload_request',
        attributes: {filename: File.basename(path)}
      }

      response = @http_headers.post(BASE_ITEM_URL, json: {data:})
      response = response.parse['data']

      {
        url: response['attributes']['url'],
        id: response['id']
      }
    end

    def upload_file_to_bucket(url:, path:)
      s3_headers = HTTP.headers({'Content-Type' => 'application/octet-stream'})
      s3_headers.put(url, body: File.read(path))
    end

    def upload_file_to_dato(upload_id:, attributes: {}, meta: {})
      headers = {
        'Content-Type' => 'application/vnd.api+json',
        'X-Api-Version' => 3,
        'Authorization' => @auth_header,
        'Accept' => 'application/json'
      }
      headers = HTTP.headers(headers)

      data = {
        type: 'upload',
        attributes: {
          path: upload_id,
          **attributes,
          default_field_metadata: {
            **meta,
          }
        }
      }

      response = headers.post('https://site-api.datocms.com/uploads', json: {data:})
      response.parse['data']['id']
    end
  end
end
