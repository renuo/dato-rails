module Dato
  class Uploads
    BASE_ITEM_URL = 'https://site-api.datocms.com/upload-requests'

    def initialize(api_token)
      @auth_header = "Bearer #{api_token}"
      @http_headers = HTTP.headers({ 'Authorization' => @auth_header,
                                     'Accept' => 'application/json',
                                     'X-Api-Version' => 3 })
    end

    def create_from_url(url)
      # Step 0: Save file locally
      file = download_file_from_url(url)

      # Step 1: Request file upload permission
      permission = request_file_upload_permission(file.path)
      upload_url = permission[:url]
      upload_id = permission[:id]

      # Step 2: Upload file to storage bucket
      upload_file_to_bucket(upload_url, file.path)

      # Step 3: Create the actual upload
      job_id = upload_file_to_dato(upload_id)

      # Step 4: Retrieve the job result
      retrieve_job_result(job_id)
    rescue StandardError => e
      puts "Error: #{e.message}"
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
        attributes: { filename: File.basename(path) }
      }

      response = @http_headers.post(BASE_ITEM_URL, json: { data: data })
      response = response.parse['data']

      {
        url: response['attributes']['url'],
        id: response['id']
      }
    end

    def upload_file_to_bucket(url, path)
      s3_headers = HTTP.headers({ 'Content-Type' => 'application/octet-stream' })
      s3_headers.put(url, body: File.open(path, &:read))
    end

    def upload_file_to_dato(upload_id)
      headers = {
        'Content-Type' => 'application/vnd.api+json',
        'X-Api-Version' => 3,
        'Authorization' => @auth_header,
        'Accept' => 'application/json',
      }
      headers = HTTP.headers(headers)

      data = {
        "type": 'upload',
        "attributes": {
          "path": upload_id,
          "author": 'DatoRails',
          "copyright": '2020 DatoCMS',
          "default_field_metadata": {
            "en": {
              "alt": 'A example image',
              "title": 'Something sent by DatoRails',
              "custom_data": {}
            }
          }
        }
      }

      response = headers.post('https://site-api.datocms.com/uploads', json: { data: data })
      response.parse['data']['id']
    end

    def retrieve_job_result(job_id)
      headers = {
        'X-Api-Version' => 3,
        'Authorization' => @auth_header,
        'Accept' => 'application/json',
        'Content-Type' => 'application/vnd.api+json'
      }

      headers = HTTP.headers(headers)

      headers.get("https://site-api.datocms.com/job-results/#{job_id}")
    end
  end
end
