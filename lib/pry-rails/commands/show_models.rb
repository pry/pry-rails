# encoding: UTF-8

class PryRails::ShowModels < Pry::ClassCommand
  match "show-models"
  group "Rails"
  description "Show all models."

  def options(opt)
    opt.banner unindent <<-USAGE
      Usage: show-models

      show-models displays the current Rails app's models.
    USAGE

    opt.on :G, "grep", "Filter output by regular expression", :argument => true
  end

  def process
    Rails.application.eager_load!

    display_activerecord_models
    display_mongoid_models
  end

  def display_activerecord_models
    return unless defined?(ActiveRecord::Base)

    models = ActiveRecord::Base.descendants

    models.sort_by(&:to_s).each do |model|
      out = []
      out.push format_model_name model

      if model.table_exists?
        model.columns.each do |column|
          out.push format_column column.name, column.type
        end
      else
        out.push format_error "Table doesn't exist"
      end

      reflections = model.reflections.sort_by do |other_model, reflection|
        [reflection.macro.to_s, other_model.to_s]
      end

      reflections.each do |other_model, reflection|
        options = []

        if reflection.options[:through].present?
          options << "through #{text.blue ":#{reflection.options[:through]}"}"
        end

        out.push format_association reflection.macro, other_model, options
      end

      print_unless_filtered out
    end
  end

  def display_mongoid_models
    return unless defined?(Mongoid::Document)

    models = []

    ObjectSpace.each_object do |o|
      is_model = false

      begin
        is_model = o.class == Class && o.ancestors.include?(Mongoid::Document)
      rescue => e
        # If it's a weird object, it's not what we want anyway.
      end

      models << o if is_model
    end

    models.sort_by(&:to_s).each do |model|
      out = []
      out.push format_model_name model

      model.fields.values.sort_by(&:name).each do |column|
        out.push format_column column.name, column.options[:type]
      end

      model.relations.each do |other_model, ref|
        options = []
        options << 'autosave'  if ref.options[:autosave]
        options << 'autobuild' if ref.options[:autobuild]
        options << 'validate'  if ref.options[:validate]

        if ref.options[:dependent]
          options << "dependent-#{ref.options[:dependent]}"
        end

        out.push format_association \
          kind_of_relation(ref.relation), other_model, options
      end

      print_unless_filtered out
    end
  end

  def format_model_name(model)
    text.bright_blue model
  end

  def format_column(name, type)
    "  #{name}: #{text.green type}"
  end

  def format_association(type, other, options = [])
    options_string = (options.any?) ? " (#{options.join(', ')})" : ''
    "  #{type} #{text.blue ":#{other}"}#{options_string}"
  end

  def format_error(message)
    "  #{text.red message}"
  end

  def print_unless_filtered array_of_strings
    result = array_of_strings.join("\n")
    if opts.present?(:G)
      return unless result =~ grep_regex
      result = colorize_matches(result) # :(
    end
    output.puts result
  end

  def colorize_matches(string)
    if Pry.color
      string.to_s.gsub(grep_regex) { |s| "\e[7m#{s}\e[27m" }
    else
      string
    end
  end

  def grep_regex
    @grep_regex ||= Regexp.new(opts[:G], Regexp::IGNORECASE)
  end

  def kind_of_relation(relation)
    case relation.to_s.sub(/^Mongoid::Relations::/, '')
      when 'Referenced::Many' then 'has_many'
      when 'Referenced::One'  then 'has_one'
      when 'Referenced::In'   then 'belongs_to'
      when 'Embedded::Many'   then 'embeds_many'
      when 'Embedded::One'    then 'embeds_one'
      when 'Embedded::In'     then 'embedded_in'
    end
  end
end

PryRails::Commands.add_command PryRails::ShowModels
