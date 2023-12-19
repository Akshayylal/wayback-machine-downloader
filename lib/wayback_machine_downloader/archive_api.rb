require 'json'
require 'uri'

module ArchiveAPI

def get_raw_list_from_api(url, page_index)
  # Your ScraperAPI key
  scraperapi_key = 'YOUR_SCRAPERAPI_KEY'

  # Original request setup for Wayback Machine
  original_request_url = URI("https://web.archive.org/cdx/search/xd")
  params = [["output", "json"], ["url", url]]
  params += parameters_for_api(page_index)
  original_request_url.query = URI.encode_www_form(params)

  # Modify the request to go through ScraperAPI
  scraperapi_url = URI("http://api.scraperapi.com?api_key=#{scraperapi_key}&url=#{URI.encode(original_request_url.to_s)}")

  begin
    json = JSON.parse(URI(scraperapi_url).open.read)
    if (json[0] <=> ["timestamp","original"]) == 0
      json.shift
    end
    json
  rescue JSON::ParserError
    []
  end
end


  def parameters_for_api page_index
    parameters = [["fl", "timestamp,original"], ["collapse", "digest"], ["gzip", "false"]]
    if !@all
      parameters.push(["filter", "statuscode:200"])
    end
    if @from_timestamp and @from_timestamp != 0
      parameters.push(["from", @from_timestamp.to_s])
    end
    if @to_timestamp and @to_timestamp != 0
      parameters.push(["to", @to_timestamp.to_s])
    end
    if page_index
      parameters.push(["page", page_index])
    end
    parameters
  end

end
