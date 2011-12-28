module HTTParty
  class Request

    # HTTParty::Request does some weird things with url params (namely, repeating them)
    # use last_uri if it exists
    def get_uri
      (self.respond_to?('last_uri') && last_uri) ? last_uri : uri
    end
    
    # monkey patch to_json and to_curl methods into Request
    def to_json
      {
        "requestUrl" => get_uri,
        "requestMethod" => http_method.to_s.split("::").last.upcase,
        "requestBody" => send(:body) || "",
        "headers" => options[:headers].to_a.flatten || []
      }.to_json
    end
    
    def to_curl
      args = ["curl -X #{http_method.to_s.split("::").last.upcase}"]
      args << "-d #{send(:body).to_json}" if self.send(:body)
      
      args << "#{(options[:headers] || []).map{|k, v| "--header \"#{k}:#{v}\""}.join(" ")}" if options[:headers]
      
      args << "\"#{get_uri}\""
      
      return args.join(" ")
    end
  end
end