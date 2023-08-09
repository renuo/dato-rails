module Dato
  class Uploads
    BASE_ITEM_URL = "https://site-api.datocms.com/upload-requests"

    def initialize(api_token)
      @http_headers = HTTP.headers({ "Authorization" => "Bearer #{api_token}",
                                     "Accept" => "application/json",
                                     "X-Api-Version" => 3 })
    end

    def create_from_url(url:)
      uri = URI.parse(url)
      file_type = File.extname(uri.path)
      file_contents = Net::HTTP.get(uri)
      temp_file = Tempfile.new(['downloaded_file', file_type])
      temp_file.binmode
      temp_file.write(file_contents)
      temp_file.rewind
      temp_file.close

      puts "Downloading #{url} to #{temp_file.path}"

      data = {
        type: 'upload_request',
        attributes: { filename: File.basename(temp_file.path) }
      }

      response = @http_headers.post(BASE_ITEM_URL, json: { data: data })
      upload_url = response.parse['data']['attributes']['url']
      puts "Uploading to #{upload_url}"
      # upload file to upload_url (s3) SVG
      s3_headers = HTTP.headers({ 'Content-Type' => 'image/svg+xml' })
      response = s3_headers.put(upload_url, body: File.read(temp_file.path))
      puts "Upload complete"

      puts response.parse.inspect



      response
    rescue => e
      puts "Error: #{e.message}"
    end
  end
end
