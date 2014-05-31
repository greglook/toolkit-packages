#!/usr/bin/env ruby


##### HELPER FUNCTIONS #####

# Executes a program and passes its output line-by-line to the given block. The
# block should return a map of metric values parsed from the given line, or nil.
# Returns a merged map of all the matched measurements.
def run(program)
  command, args = program.split(/\s/, 2)
  command = %x{which #{command} 2> /dev/null}.chomp unless File.executable? command
  if File.executable? command
    lines = %x{#{command} #{args}}.split("\n")
    puts "Error executing command: #{command} #{args}" unless $?.success?
    metrics = {}
    lines.each do |line|
      measurements = yield line
      metrics.merge!(measurements) if measurements
    end
    metrics
  else
    raise "Command #{command} not found"
  end
end

# Matches a line against a list of matching lambdas. Returns the first matched
# result.
def find_match(line, *matchers)
  matchers.each do |matcher|
    metrics = matcher[line]
    return metrics if metrics
  end
  nil
end

# Creates a Proc which takes a line and returns a map of metric values if the
# line matched.
def match(pattern, &block)
  lambda do |line|
    block[$~] if pattern === line
  end
end

# Returns a map with network traffic metrics based on the given name.
def record_traffic(name, packets, bytes)
  {"#{name} packets" => packets.to_i,
   "#{name} bytes" => bytes.to_i}
end

# Matches an iptables chain header.
def match_chain(name, chain)
  match /^Chain #{chain.upcase} \(policy \w+ (\d+) packets, (\d+) bytes\)/ do |m|
    record_traffic name, m[1], m[2]
  end
end

# Matches an iptables rule and records traffic statistics.
def match_rule(name, opts={})
  pattern = /^\s*(\d+)\s+(\d+)\s+#{opts[:target] || 'ACCEPT'}\s+#{opts[:proto] || 'all'}\s+\-\-\s+#{opts[:in] || 'any'}\s+#{opts[:out] || 'any'}\s+#{opts[:source] || 'anywhere'}\s+#{opts[:dest] || 'anywhere'}\s*#{opts[:match] || ''}/
  match pattern do |m|
    record_traffic name, m[1], m[2]
  end
end



##### MATCHER RULES #####

def get_metrics
  # FILTER:INPUT chain
  filter_input =
  run "iptables --list INPUT --verbose --exact" do |line|
    find_match line,
      match_chain("filter input DROP", "INPUT"),       # Dropped traffic
      match_rule("filter input lan0", in: 'lan0'),        # Traffic to XVI from the LAN
      match_rule("filter input established", in: 'wan0',  # Established traffic to XVI from Internet.
                 match: 'ctstate RELATED,ESTABLISHED')
  end

  # FILTER:OUTPUT chain
  filter_output =
  run "iptables --list OUTPUT --verbose --exact" do |line|
    find_match line,
      match_chain("filter output", "OUTPUT")      # Traffic sent by XVI
  end

  # FILTER:FORWARD chain
  filter_forward =
  run "iptables --list FORWARD --verbose --exact" do |line|
    find_match line,
      match_chain("filter forward DROP", "FORWARD"),
      match_rule("filter forward lan0", in: 'lan0'),      # Forwarded traffic from LAN to Internet.
      match_rule("filter forward established",            # Forward established traffic.
                 match: 'ctstate RELATED,ESTABLISHED')
  end

  # MANGLE:mark_qos_band chain
  mangle_qos =
  run "iptables --table mangle --list mark_qos_band --verbose --exact" do |line|
    find_match line,
      match_rule("mangle qos band1", target: 'RETURN', match: 'mark match 0x1'),
      match_rule("mangle qos band2", target: 'RETURN', match: 'mark match 0x2'),
      match_rule("mangle qos band3", target: 'RETURN', match: 'mark match 0x3'),
      match_rule("mangle qos band4", target: 'RETURN', match: 'mark match 0x4'),
      match_rule("mangle qos band5", target: 'RETURN', match: 'mark match 0x5')
  end

  filter_input.merge(filter_output.merge(filter_forward.merge(mangle_qos)))
end



##### REPORT LOOP #####

require 'riemann/client'

$riemann = Riemann::Client.new #host: 'xvi.home.greglook.net'
$metrics = {}

loop do
  metrics = get_metrics
  metrics.each do |metric, value|
    if $metrics[metric]
      service = "iptables #{metric}"
      delta = value - $metrics[metric]
      puts "%-40s %5d" % [service, delta]
      $riemann << {service: service, metric: delta, state: "ok", ttl: 10, tags: ['net']}
    end
    $metrics[metric] = value
  end
  sleep 5
end
