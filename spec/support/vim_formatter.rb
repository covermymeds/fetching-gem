# Adapted from https://github.com/bronson/vim-runtest/blob/master/rspec_formatter.rb.
require "rspec/core/formatters/base_text_formatter"

class VimFormatter < RSpec::Core::Formatters::BaseTextFormatter

  def example_failed example
    exception = example.execution_result[:exception]
    path = Regexp.last_match[1] if exception.backtrace.find do |frame|
      frame =~ %r{\b(spec/.*_spec\.rb:\d+)(?::|\z)}
    end
    message = format_message exception.message
    path    = format_caller(path || " ")
    output.puts "#{path}: #{example.example_group.description.strip} " \
      "#{example.description.strip}: #{message.strip}" if path
  end

  def example_pending *_args; end

  def dump_failures   *_args; end

  def dump_pending    *_args; end

  def message          _msg;  end

  def dump_summary    *_args; end

  def seed            *_args; end

  private

  def format_message msg
    msg.gsub("\n", " ")[0, 80]
  end

end
