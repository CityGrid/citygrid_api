module HTTParty
  class Request

    def get_uri
      if (self.respond_to?('last_uri') && last_uri)
        return last_uri
      else
        return uri
      end
    end
    
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