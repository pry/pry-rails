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

    if defined?(ActiveRecord::Base)
      models = ActiveRecord::Base.descendants

      display(models.map do |model|
        model_string = model.to_s + "\n"

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

        model_string
      end.join)
    end

    if defined?(Mongoid::Document)
      models = []
      ObjectSpace.each_object do |o|
        if o.is_a?(Class) && o.ancestors.include?(Mongoid::Document)
          models << o
        end
      end

      display(models.map do |model|
        mod = extract_class_name(path)
        model_string = "\033[1;34m#{mod.to_s}\033[0m\n"
        begin
          if mod.constantize.included_modules.include?(Mongoid::Document)
            model_string << mod.constantize.fields.values.sort_by(&:name).map { |col|
              "  #{col.name}: \033[1;33m#{col.options[:type].to_s.downcase}\033[0m"
            }.join("\n")
            mod.constantize.relations.each do |model,ref|
              model_string << "\n  #{kind_of_relation(ref.relation.to_s)} \033[1;34m#{model}\033[0m"
              model_string << ", autosave" if ref.options[:autosave]
              model_string << ", autobuild" if ref.options[:autobuild]
              model_string << ", validate" if ref.options[:validate]
              model_string << ", dependent-#{ref.options[:dependent]}" if ref.options[:dependent]
            end
          else
            model_string << "  Collection doesn't exist"
          end
          model_string

        rescue Exception
          STDERR.puts "Warning: exception #{$!} raised while trying to load model class #{path}"
        end
      end.join("\n"))
    end
  end

  def display(string)
    if opts.present?(:G)
      regexp = Regexp.new(opts[:G], Regexp::IGNORECASE)
      string = string.gsub(regexp) { |s| text.red(s) }
    end

    output.puts string
  end

  def kind_of_relation(string)
    case string.gsub('Mongoid::Relations::', '')
    when 'Referenced::Many' then 'has_many'
    when 'Referenced::One' then 'has_one'
    when 'Referenced::In' then 'belongs_to'
    when 'Embedded::Many' then 'embeds_many'
    when 'Embedded::One' then 'embeds_one'
    when 'Embedded::In' then 'embedded_in'
    end
  end
end
