module HTTParty
  class Request
    def to_json
      {
        "requestUrl" => self.uri,
        "requestMethod" => self.http_method.to_s.split("::").last.upcase,
        "requestBody" => self.send(:body) || "",
        "headers" => options[:headers].to_a.flatten || []
      }.to_json
    end
    
    def to_curl
      args = ["curl -X #{self.http_method.to_s.split("::").last.upcase}"]
      args << "-d #{self.send(:body).to_json}" if self.send(:body)
      
      args << "#{(options[:headers] || []).map{|k, v| "--header \"#{k}:#{v}\""}.join(" ")}" if options[:headers]
      
      args << "\"#{self.uri}\""
      
      return args.join(" ")
    end
  end
end