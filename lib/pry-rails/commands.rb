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
        Rails.application.reload_routes!
        all_routes = Rails.application.routes.routes

        all_routes = begin
          begin
            # rails 4
            require 'action_dispatch/routing/inspector'
            inspector = ActionDispatch::Routing::RoutesInspector.new
          rescue LoadError => e
            # rails 3.2
            require 'rails/application/route_inspector'
            inspector = Rails::Application::RouteInspector.new
          end
          inspector.format(all_routes)
        rescue LoadError => e
          # rails 3.0 and 3.1. cribbed from
          # https://github.com/rails/rails/blob/3-1-stable/railties/lib/rails/tasks/routes.rake
          routes = all_routes.collect do |route|

            reqs = route.requirements.dup
            reqs[:to] = route.app unless route.app.class.name.to_s =~ /^ActionDispatch::Routing/
              reqs = reqs.empty? ? "" : reqs.inspect

            {:name => route.name.to_s, :verb => route.verb.to_s, :path => route.path, :reqs => reqs}
          end

          # Skip the route if it's internal info route
          routes.reject! { |r| r[:path] =~ %r{/rails/info/properties|^/assets} }

          name_width = routes.map{ |r| r[:name].length }.max
          verb_width = routes.map{ |r| r[:verb].length }.max
          path_width = routes.map{ |r| r[:path].length }.max

          routes.map do |r|
            "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:path].ljust(path_width)} #{r[:reqs]}"
          end
        end

        output.puts all_routes.grep(Regexp.new(opts[:G] || ".")).join "\n"
      end
    end
  end
end

