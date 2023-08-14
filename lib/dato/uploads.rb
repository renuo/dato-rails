module Dato
  class Uploads
    BASE_ITEM_URL = 'https://site-api.datocms.com/upload-requests'

    def initialize(api_token)
      @auth_header = "Bearer #{api_token}"
      @http_headers = HTTP.headers({ 'Authorization' => @auth_header,
                                     'Accept' => 'application/json',
                                     'X-Api-Version' => 3 })
    end

    def create_from_url(url:)
      # Step 0: Save file locally
      puts 'step 0'

      uri = URI.parse(url)
      file_type = File.extname(uri.path)
      file_contents = Net::HTTP.get(uri)
      temp_file = Tempfile.new(['downloaded_file', file_type])
      temp_file.binmode
      temp_file.write(file_contents)
      temp_file.rewind
      temp_file.close

      puts "Downloading #{url} to #{temp_file.path}"

      # Step 1: Request file upload permission
      puts 'step 1'

      data = {
        type: 'upload_request',
        attributes: { filename: File.basename(temp_file.path) }
      }

      response = @http_headers.post(BASE_ITEM_URL, json: { data: })
      upload_url = response.parse['data']['attributes']['url']
      upload_id = response.parse['data']['id']

      # Step 2: Upload file to storage bucket
      puts 'step 2'

      puts "Uploading to #{upload_url}"
      s3_headers = HTTP.headers({ 'Content-Type' => 'application/octet-stream' })
      response = s3_headers.put(upload_url, body: File.open(temp_file.path, &:read))
      puts 'Upload complete'

      puts response.code

      # Step 3: Create the actual upload
      puts 'step 3'

      new_headers = HTTP.headers({
                                   'Content-Type' => 'application/vnd.api+json',
                                   'X-Api-Version' => 3,
                                   'Authorization' => @auth_header,
                                   'Accept' => 'application/json',
                                 })

      puts 'creating dato upload'

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

      response = new_headers.post('https://site-api.datocms.com/uploads', json: { data: data } )
      job_id = response.parse['data']['id']

      # Step 4: Retrieve the job result
      puts 'step 4'
      job_headers = HTTP.headers({
                                   'X-Api-Version' => 3,
                                   'Authorization' => @auth_header,
                                   'Accept' => 'application/json',
                                   'Content-Type' => 'application/vnd.api+json'
                                 })

      response = job_headers.get("https://site-api.datocms.com/job-results/#{job_id}")

      response
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end
