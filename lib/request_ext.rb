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
  end
end