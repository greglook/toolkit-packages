$: << File.expand_path("..", __FILE__)

require 'solanum/source'


# Namespace module with some handy utility methods.
#
# Author:: Greg Look
module Solanum

  # Collects metrics from the given sources, in order. Returns a merged map of
  # metric data.

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
  source = Solanum::Source::Compute.new
  source.instance_exec &block
  source
end
