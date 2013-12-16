#!/usr/bin/ruby

# This script analyzes a set of Java source files and produces a graph DOT
# file describing the dependencies between the packages.
#
# Author:: Greg Look

require 'optparse'


SCRIPT_NAME = File.basename($0)

$prefix = nil
$local_only = false
$exclude = []
$weight_edges = false
$group_packages = false
$group_by = 1
$layout = nil

# parse command-line options
opts = OptionParser.new do |opts|
  opts.banner = "Usage: #{SCRIPT_NAME} [options] <Java files...>"
  opts.on('-p', "--prefix STRING", "Prefix to remove from packages") {|v| $prefix = v }
  opts.on('-l', "--local-only", "Only show local packages") {|v| $local_only = true }
  opts.on('-x', "--exclude PACKAGE", "Exclude a package subgraph (may be provided multiple times)") {|v| $exclude << v }
  opts.on('-w', "--[no-]weight", "Weight edges by the number of imports") {|v| $weight_edges = v }
  opts.on('-g', "--[no-]group", "Group packages hierarchically") {|v| $group_packages = v }
  opts.on(      "--group-by N", Integer, "Use N segments to group top-level packages (default: #{$group_by})") {|n| $group_by = n.to_i }
  opts.on(      "--horizontal", "Lay out nodes horizontally") { $layout = :horizontal }
  opts.on('-v', "--verbose", "Show detailed processing information") { $verbose = true }
  opts.on('-h', "--help", "Display usage information") { puts opts; exit }
  opts.separator ""
  opts.separator "Example:"
  opts.separator "#{SCRIPT_NAME} -p com.amazon.trms.data. -x java.util -x java.nio src/**/*.java | dot -Tpng > packages.png"
end
opts.parse!

# helper method to report failures
def fail(msg, code=1)
  STDERR.puts msg
  exit code
end

# logging helper method
def log(msg)
  STDERR.puts msg if $verbose
end

fail opts if ARGV.empty?

$imports = Hash.new

# canonicalizes a package name
def canonical(name)
  name = $1 if name =~ /^(.*?)(?:\.\*)?$/
  name = "?" if name.empty?
  name
end

$start = Time.now

# process input files
ARGV.each do |path|
  log "Processing #{path}"
  package = nil

  IO.readlines(path).each do |line|
    if line =~ /^\s*package (.+);\s*$/
      package = canonical $1
      log "  Belongs to #{package}"

    elsif line =~ /^\s*import (?:static )?(.+);\s*$/
      import = $1
      import, cname = $1, $2 if import =~ /^([a-z0-9\.]+)\.([A-Z].+)$/
      log "  Imports #{cname} from #{import}"

      $imports[package] ||= Hash.new(0)
      $imports[package][import] += 1 unless import == package
    end
  end
end

log "Processed %d files in %.3f sec" % [ARGV.size, Time.now - $start]

$packages = ($imports.values.map { |h| h.keys }.flatten + $imports.keys).uniq

# filter excluded packages
$packages = $imports.keys if $local_only
$imports = $imports.delete_if do |package, imports|
  $exclude.include? package
end
$imports.keys.each do |package|
  $imports[package] = $imports[package].delete_if do |import, n|
    $exclude.include?(import) || $local_only && !$imports[import]
  end
end

#log "All packages: #{$packages.join(' ')}"

# helper method to indent some text
def puts_indent(level, text)
  print "    "*level, text, "\n"
end

# helper method to sanitize node names
def sanitize(name)
  name.gsub(".", "_")
end

# trims a package name from its prefix to get a label
def prefixed_label(package)
  label = ( package =~ /^#{$prefix}(.*)$/ ) && $1 || package
  label = '.' if label.empty?
  label
end

# draw a package node and its imports at some indent level
def draw_node(package, level=1)
  label = prefixed_label package
  name = sanitize package
  style = $imports[package] && 'rounded' || '"dashed,rounded"'
  puts_indent level, "#{name} [shape=box,style=#{style},label=\"#{label}\"];"
end

# draw a set of import edges
def draw_imports(package, imports, level=1)
  imports && imports.each do |import, n|
    width = (Math.log(n) + 1).ceil
    style = $weight_edges && "[weight=#{n},penwidth=#{width}]" || ""
    puts_indent level, "#{sanitize package} -> #{sanitize import} #{style};"
  end
end

# open a subgraph for the given package
def open_subgraph(package, parent, level)
  name = sanitize package
  name = "cluster_#{name}" if $group_packages
  label = parent && (package =~ /^#{parent}\.(.+)$/) && $1 || package
  puts_indent level, "subgraph #{name} {"
  puts_indent (level + 1), "label = \"#{label}\";"
end

# closes a subgraph at some level
def close_subgraph(level)
  puts_indent level, "}"
end

# Here `package` is fully qualified from the root, parent indicates the fully
# qualified next higher *subgraph* containing this one.
def write_package(package, parent=nil, level=1)
  return if $exclude.include? package

  log "Writing package #{package}"

  # see if there are direct subpackages
  subpackages = $packages.map { |p| $1 if p =~ /^#{package}\.(.+)$/ }.compact
  direct_subpackages = subpackages.map { |p| p.split('.').first }.uniq
  log "    direct subpackages: #{direct_subpackages.join(' ')}" unless direct_subpackages.empty?

  # package is real and contains classes
  if $packages.include? package
    if direct_subpackages.empty?
      draw_node package, level
    else
      open_subgraph package, parent, level
      draw_node package, (level + 1)
      direct_subpackages.each do |subpackage|
        write_package "#{package}.#{subpackage}", package, level + 1
      end
      close_subgraph level
    end

  # package is a virtual container, like "java" in "java.util.regex"
  else
    case direct_subpackages.size
    when 0:
      # omit package
    when 1:
      write_package "#{package}.#{direct_subpackages.first}", parent, level
    else
      open_subgraph package, parent, level
      direct_subpackages.each do |subpackage|
        write_package "#{package}.#{subpackage}", package, level + 1
      end
      close_subgraph level
    end
  end
end

# write graph file
puts_indent 0, "digraph dependencies {"
puts_indent 1, "rankdir=LR;" if $layout == :horizontal
puts_indent 1, "node [shape=circle];" # this is for debugging any nodes which don't have an explicit style set
puts ""

# write package hierarchy
roots = $packages.map do |package|
  segments = package.split('.')
  len = [[$group_by, segments.length].min, 1].max - 1
  segments[0..len].join('.')
end

roots.uniq.each do |package|
  write_package package
end

# write edges
$imports.each do |package, imports|
  draw_imports package, imports
end

puts "}"
