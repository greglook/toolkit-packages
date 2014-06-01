module Solanum

# This class maps a line-matching pattern to a set of calculations on the
# matched data.
#
# Author:: Greg Look
class Matcher
  attr_reader :pattern, :recorder

  # Creates a new Matcher
  def initialize(pattern, &block)
    raise "pattern must be provided" if pattern.nil?
    raise "block must be provided" if block.nil?

    @pattern = pattern
    @recorder = block
  end

  # Attempts to match the given line, calling it's recorder block with the
  # given match and metrics if matched. Returns a (potentially) updated
  # metrics map on match, or nil otherwise.
  def match(metrics, line)
    raise "line must be provided" if line.nil?
    raise "metrics must be provided" if metrics.nil?

    if @pattern === line
      @calc.call $~, metrics
    end
  end
end

end
