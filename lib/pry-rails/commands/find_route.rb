class PryRails::FindRoute < Pry::ClassCommand
  match 'find-route'
  group 'Rails'
  description 'See which URLs match a given Controller.'
  command_options argument_required: true
  banner <<-BANNER
    Usage: find-route <controller>

    Returns the URL(s) that match a given controller or controller action.

    find-route MyController#show  #=> The URL that matches the MyController show action
    find-route MyController       #=> All the URLs that hit MyController
    find-route Admin              #=> All the URLs that hit the Admin namespace
  BANNER

  def process(controller)
    if single_action?(controller)
      single_action(controller)
    else
      all_actions(controller)
    end
  end

  private

  def single_action(controller)
    controller_action_pair = controller_and_action_from(controller)
    route = routes.find { |route| route.defaults == controller_action_pair }
    show_routes(Array(route))
  end

  def all_actions(controller)
    all_routes = routes.select do |route|
      route.defaults[:controller].to_s.starts_with?(normalize_controller_name(controller))
    end

    show_routes(all_routes)
  end

  def controller_and_action_from(method_name)
    controller, action = method_name.split("#")
    {controller: normalize_controller_name(controller), action: action}
  end

  def routes
    Rails.application.routes.routes
  end

  def normalize_controller_name(controller)
    controller.underscore.chomp('_controller')
  end

  def show_routes(all_routes)
    if all_routes.any?
      grouped_routes = all_routes.group_by { |route| route.defaults[:controller] }
      grouped_routes.each do |controller, routes|
        output.puts "Routes for " + text.bold(controller.camelize + "Controller")
        output.puts "--"
        routes.each do |route|
          output.puts "#{text.bold(verb_for(route))} #{route.defaults[:action]} #{route.path.spec}"
        end
        output.puts
      end
    else
      output.puts "No routes found."
    end
  end

  def verb_for(route)
    %w(GET PUT POST PATCH DELETE).find { |v| route.verb =~ v }
  end

  def single_action?(controller)
    controller =~ /#/
  end

  PryRails::Commands.add_command(self)
end
