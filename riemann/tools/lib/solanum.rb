$: << File.expand_path("..", __FILE__)

require 'solanum/source'


# Namespace module with some handy utility methods.
#
# Author:: Greg Look
module Solanum

  # Collects metrics from the given sources, in order. Returns a merged map of
  # metric data.
  def self.collect(*sources)
    sources.reduce({}) do |metrics, source|
      new_metrics = nil
      begin
        new_metrics = source.collect(metrics)
      rescue => e
        STDERR.puts "Error collecting metrics from #{source}: #{e}"
        raise e
      end
      new_metrics || metrics
    end
  end

end


# Creates a source which runs a command and matches against output lines.
def run(command, &block)
  source = Solanum::Source::Command.new(command)
  source.instance_exec &block
  source
end


# Creates a source which matches against the lines in a file.
def read(path, &block)
  source = Solanum::Source::File.new(path)
  source.instance_exec &block
  source
end


# Computes metrics directly.
def compute(&block)
  Solanum::Source::Compute.new(block)
end
