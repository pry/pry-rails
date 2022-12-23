# frozen_string_literal: true

class PryRails::ShowNotes < Pry::ClassCommand
  match 'show-notes'
  group 'Rails'
  description 'Show all notes.'

  banner <<-BANNER
    Usage: show-notes [-w|--what TYPE]

    Prints all notes: FIXME, OPTIMIZE, TODO, etc from your code
  BANNER

  # TODO: todo me test
  def options(opt)
    opt.on :w, :what, 'Filter by type', argument: true
  end

  def process
    annotations = opts.w? ? [opts[:w]] : Rails::SourceAnnotationExtractor::Annotation.tags
    tag = (annotations.length > 1)

    output.puts Rails::SourceAnnotationExtractor.enumerate(annotations.join('|'), tag: tag, dirs: directories)
  end

  def directories
    Rails::SourceAnnotationExtractor::Annotation.directories
  end

  PryRails::Commands.add_command(self)
end
