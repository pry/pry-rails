# encoding: UTF-8

PryRails::Commands.create_command "recognize-path" do
  group "Rails"
  description "Verify that a URL is mapped to the right controller and action"

  def options(opt)
    opt.banner unindent <<-USAGE
      Usage: recognize-path PATH [-m|--method METHOD]

      Verifies that a given PATH is mapped to the right controller and action.

      recognize-path example.com
      recognize-path example.com -m post
    USAGE

    opt.on :m, :method, "Methods", :argument => true
  end

  def process
    method = (opts.m? ? opts[:m] : :get)
    routes = Rails.application.routes

    begin
      info = routes.recognize_path("http://#{args.first}", :method => method)
    rescue ActionController::UnknownHttpMethod
      output.puts "Unknown HTTP method: #{method}"
    rescue ActionController::RoutingError => e
      output.puts e
    end

    output.puts Pry::Helpers::BaseHelpers.colorize_code(info)
  end
end
