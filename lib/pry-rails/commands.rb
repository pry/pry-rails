module PryRails
  Commands = Pry::CommandSet.new do
    create_command "show-routes", "Print out all defined routes in match order, with names." do
      def options(opt)
        opt.banner unindent <<-USAGE
          Usage: show-routes [-G]

          show-routes displays the current Rails app's routes.
        USAGE

        opt.on :G, "grep", "Filter output by regular expression", :argument => true
      end

      def process
        all_routes = Rails.application.routes.routes
        require 'rails/application/route_inspector'
        inspector = Rails::Application::RouteInspector.new
        output.puts inspector.format(all_routes).grep(Regexp.new(opts[:G] || ".")).join "\n"
      end
    end
  end
end

