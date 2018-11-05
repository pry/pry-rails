require 'rubygems'

module PryRails
  class Prompt
    class << self
      def formatted_env
        if Rails.env.production?
          bold_env = Pry::Helpers::Text.bold(Rails.env)
          Pry::Helpers::Text.red(bold_env)
        elsif Rails.env.development?
          Pry::Helpers::Text.green(Rails.env)
        else
          Rails.env
        end
      end

      def project_name
        File.basename(Rails.root)
      end
    end
  end

  description = "Includes the current Rails environment and project folder name.\n" \
                "[1] [project_name][Rails.env] pry(main)>"

  if Gem::Version.new(Pry::VERSION) < Gem::Version.new('0.12.0')
    RAILS_PROMPT = [
      proc do |target_self, nest_level, pry|
        "[#{pry.input_array.size}] " \
          "[#{Prompt.project_name}][#{Prompt.formatted_env}] " \
          "#{Pry.config.prompt_name}(#{Pry.view_clip(target_self)})" \
          "#{":#{nest_level}" unless nest_level.zero?}> "
      end,
      proc do |target_self, nest_level, pry|
        "[#{pry.input_array.size}] " \
          "[#{Prompt.project_name}][#{Prompt.formatted_env}] " \
          "#{Pry.config.prompt_name}(#{Pry.view_clip(target_self)})" \
          "#{":#{nest_level}" unless nest_level.zero?}* "
      end
    ]
    Pry::Prompt::MAP["rails"] = {
      value: RAILS_PROMPT,
      description: description
    }
  else
    RAILS_PROMPT_PROC = proc do |target_self, nest_level, pry, sep|
      "[#{pry.input_ring.size}] " \
        "[#{Prompt.project_name}][#{Prompt.formatted_env}] " \
        "#{Pry.config.prompt_name}(#{Pry.view_clip(target_self)})" \
        "#{":#{nest_level}" unless nest_level.zero?}#{sep} "
    end
    Pry::Prompt.add("rails", description, &RAILS_PROMPT_PROC)
  end
end
