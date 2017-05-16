require "./spec_helper"

describe "CSRF" do
  it "sends GETs to next handler" do
    handler = CSRF.new
    request = HTTP::Request.new("GET", "/")
    io_with_context = create_request_and_return_io(handler, request)
    client_response = HTTP::Client::Response.from_io(io_with_context, decompress: false)
    client_response.status_code.should eq 404
  end

  it "blocks POSTs without the token" do
    handler = CSRF.new
    request = HTTP::Request.new("POST", "/")
    io_with_context = create_request_and_return_io(handler, request)
    client_response = HTTP::Client::Response.from_io(io_with_context, decompress: false)
    client_response.status_code.should eq 403
  end

  it "allows POSTs with the correct token in FORM submit" do
    handler = CSRF.new
    request = HTTP::Request.new("POST", "/",
      body: "authenticity_token=cemal&hasan=lamec",
      headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"})
    io, context = process_request(handler, request)
    client_response = HTTP::Client::Response.from_io(io, decompress: false)
    client_response.status_code.should eq 403

    current_token = context.session.string("csrf")

    handler = CSRF.new
    request = HTTP::Request.new("POST", "/",
      body: "authenticity_token=#{current_token}&hasan=lamec",
      headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded",
                             "Set-Cookie"   => client_response.headers["Set-Cookie"]})
    io, context = process_request(handler, request)
    client_response = HTTP::Client::Response.from_io(io, decompress: false)
    client_response.status_code.should eq 404
  end

  it "allows POSTs with the correct token in HTTP header" do
    handler = CSRF.new
    request = HTTP::Request.new("POST", "/",
      body: "hasan=lamec",
      headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"})
    io, context = process_request(handler, request)
    client_response = HTTP::Client::Response.from_io(io, decompress: false)
    client_response.status_code.should eq 403

    current_token = context.session.string("csrf").not_nil!

    handler = CSRF.new
    request = HTTP::Request.new("POST", "/",
      body: "hasan=lamec",
      headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded",
                             "Set-Cookie"   => client_response.headers["Set-Cookie"],
                             "x-csrf-token" => current_token})
    io, context = process_request(handler, request)
    client_response = HTTP::Client::Response.from_io(io, decompress: false)
    client_response.status_code.should eq 404
  end

  it "allows POSTs to allowed route" do
    handler = CSRF.new(allowed_routes: ["/allowed"])
    request = HTTP::Request.new("POST", "/allowed/",
      body: "authenticity_token=cemal&hasan=lamec",
      headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"})
    io, context = process_request(handler, request)
    client_response = HTTP::Client::Response.from_io(io, decompress: false)
    client_response.status_code.should eq 404
  end

  it "allows POSTs to route using wildcards" do
    handler = CSRF.new(allowed_routes: ["/everything/*"])
    request = HTTP::Request.new("POST", "/everything/here/and",
      body: "authenticity_token=cemal&hasan=lamec",
      headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"})
    io, context = process_request(handler, request)
    client_response = HTTP::Client::Response.from_io(io, decompress: false)
    client_response.status_code.should eq 404
  end

  it "not allows POSTs to mismatched route using wildcards" do
    handler = CSRF.new(allowed_routes: ["/nothing/*"])
    request = HTTP::Request.new("POST", "/something/",
      body: "authenticity_token=cemal&hasan=lamec",
      headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"})
    io, context = process_request(handler, request)
    client_response = HTTP::Client::Response.from_io(io, decompress: false)
    client_response.status_code.should eq 403
  end
end

def process_request(handler, request)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  handler.call(context)
  response.close
  io.rewind
  {io, context}
end
