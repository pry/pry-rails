module PryRails
  Commands = Pry::CommandSet.new do
    create_command "show-routes", "Print out all defined routes in match order, with names." do
      group "Rails"

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

    create_command "show-models", "Print out all defined models, with attribrutes." do
      group "Rails"

      def options(opt)
        opt.banner unindent <<-USAGE
          Usage: show-models

          show-models displays the current Rails app's models.
        USAGE

        opt.on :G, "grep", "Color output red by regular expression", :argument => true
      end

      def process
        Rails.application.eager_load!

        models = ActiveRecord::Base.descendants.map do |mod|
          model_string = mod.to_s + "\n"
          if mod.table_exists?
            model_string << mod.columns.map { |col| "  #{col.name}: #{col.type.to_s}" }.join("\n")
          else
            model_string << "  Table doesn't exist"
          end
          mod.reflections.each do |model,ref|
            model_string << "\n  #{ref.macro.to_s} #{model}"
            model_string << " through #{ref.options[:through]}" unless ref.options[:through].nil?
          end
          model_string
        end.join("\n")

        models.gsub!(Regexp.new(opts[:G] || ".", Regexp::IGNORECASE)) { |s| text.red(s) } unless opts[:G].nil?

        output.puts models
      end
    end

    create_command "show-middleware" do
      group "Rails"

      def options(opt)
        opt.banner unindent <<-USAGE
          Usage: show-middleware [-G]

          show-middleware shows the Rails app's middleware.

          If this pry REPL is attached to a Rails server, the entire middleware
          stack is displayed.  Otherwise, only the middleware Rails knows about is
          printed.
        USAGE

        opt.on :G, "grep", "Filter output by regular expression", :argument => true
      end

      def process
        # assumes there is only one Rack::Server instance
        server = nil
        ObjectSpace.each_object(Rack::Server) do |object|
          server = object
        end

        middlewares = []

        if server
          stack = server.instance_variable_get("@wrapped_app")
          middlewares << stack.class.to_s

          while stack.instance_variable_defined?("@app") do
            stack = stack.instance_variable_get("@app")
            # Rails 3.0 uses the Application class rather than the application
            # instance itself, so we grab the instance.
            stack = Rails.application  if stack == Rails.application.class
            middlewares << stack.class.to_s  if stack != Rails.application
          end
        else
          middleware_names = Rails.application.middleware.map do |middleware|
            # After Rails 3.0, the middleware are wrapped in a special class
            # that responds to #name.
            if middleware.respond_to?(:name)
              middleware.name
            else
              middleware.inspect
            end
          end
          middlewares.concat middleware_names
        end
        middlewares << Rails.application.class.to_s
        print_middleware middlewares.grep(Regexp.new(opts[:G] || "."))
      end

      def print_middleware(middlewares)
        middlewares.each do |middleware|
          string = if middleware == Rails.application.class.to_s
            "run #{middleware}.routes"
          else
            "use #{middleware}"
          end
          output.puts string
        end
      end
    end
  end
end
