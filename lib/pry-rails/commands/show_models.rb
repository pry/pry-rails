# encoding: UTF-8

PryRails::Commands.create_command "show-models", "Show all defined models." do
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

    display_activerecord_models
    display_mongoid_models
  end

  def display_activerecord_models
    return unless defined?(ActiveRecord::Base)

    models = ActiveRecord::Base.descendants

    models.sort_by(&:to_s).each do |model|
      model_string = "#{model}\n"

      if model.table_exists?
        model.columns.each do |column|
          model_string << "  #{column.name}: #{column.type.to_s}\n"
        end
      else
        model_string << "  Table doesn't exist\n"
      end

      model.reflections.each do |model, reflection|
        model_string << "  #{reflection.macro.to_s} #{model}"

        if reflection.options[:through].present?
          model_string << " through #{reflection.options[:through]}\n"
        else
          model_string << "\n"
        end
      end

      display model_string
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
      model_string = "#{model}\n"

      model.fields.values.sort_by(&:name).each do |column|
        model_string << "  #{column.name}: #{column.options[:type]}\n"
      end

      model.relations.each do |other_model, ref|
        model_string << "  #{kind_of_relation(ref.relation)} #{other_model}"
        model_string << ", autosave"  if ref.options[:autosave]
        model_string << ", autobuild" if ref.options[:autobuild]
        model_string << ", validate"  if ref.options[:validate]

        if ref.options[:dependent]
          model_string << ", dependent-#{ref.options[:dependent]}"
        end

        model_string << "\n"
      end

      display model_string
    end
  end

  def display(string)
    if opts.present?(:G)
      regexp = Regexp.new(opts[:G], Regexp::IGNORECASE)
      string = string.gsub(regexp) { |s| text.red(s) }
    end

    output.puts string
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
