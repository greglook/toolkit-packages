#!/usr/bin/ruby

# This script analyzes a set of Java source files and produces a graph DOT
# file describing the class/interface inheritance hierarchy.
#
# Author:: Greg Look, Kevin Litwack

require 'optparse'
require 'yaml'


SCRIPT_NAME = File.basename($0)

$local_only = false
$exclude = []
$group_types = true
$show_imports = false
$layout = nil

# Parse command-line options.
opts = OptionParser.new do |opts|
  opts.banner = "Usage: #{SCRIPT_NAME} [options] <Java files...>"
  opts.on('-l', "--local-only", "Only show local entities") {|v| $local_only = true }
  opts.on('-x', "--exclude ID", "Exclude a subtree prefix from the graph (may be provided multiple times)") {|v| $exclude << v }
  opts.on('-g', "--[no-]group", "Group types together by package (default: #{$group_types})") {|v| $group_types = v }
  opts.on('-i', "--[no-]imports", "Show import relationships (default: #{$show_imports})") {|v| $show_imports = v }
  opts.on(      "--horizontal", "Lay out nodes horizontally") { $layout = :horizontal }
  opts.on('-v', "--verbose", "Show detailed processing information") { $verbose = true }
  opts.on('-h', "--help", "Display usage information") { puts opts; exit }
  opts.separator ""
  opts.separator "Example:"
  opts.separator "#{SCRIPT_NAME} -x java -x org.apache.commons src/**/*.java | dot -Tpng > classes.png"
end
opts.parse!

# Reports a failure message and exits with an optional code.
def fail(msg, code=1)
  STDERR.puts msg
  exit code
end

# Logs a message to stderr if the verbose flag is set.
def log(msg)
  STDERR.puts msg if $verbose
end

# Require at least one source argument.
fail opts if ARGV.empty?



##### JAVA SYNTAX CLASSES #####

# Represents a Java type reference.
class JavaType
  attr_reader :package, :name, :parameters

  include Comparable

  def initialize(package, name, parameters=nil)
    @package = package
    @name = name
    @parameters = parameters
  end

  # Fully-qualified class name.
  def qualified_name
    "#{@package}.#{@name}"
  end

  # Parameterized type name.
  def parameterized_name
    @parameters && ("%s<%s>" % [@name, @parameters.join(', ')]) || @name
  end

  # Fully-qualified and parameterized name.
  def full_name
    "#{@package}.#{parameterized_name}"
  end

  # Returns the raw (un-parameterized) type for this entity.
  def raw_type
    JavaType.new(@package, @name)
  end

  # Determines whether the given type has the same raw type as this one.
  def type_of?(type)
    type.raw_type == raw_type
  end

  def <=>(other)
    other.respond_to?(:full_name) &&
      (full_name <=> other.full_name)
  end

  def ==(other)
    other.respond_to?(:package) && (other.package == @package) &&
      other.respond_to?(:name) && (other.name == @name) &&
      other.respond_to?(:parameters) && (other.parameters == @parameters)
  end

  def eql?(other)
    other.kind_of?(JavaType) &&
      (self == other)
  end

  def hash
    [@package, @name, @parameters].hash
  end
end


# Represents a Java class, interface, or enum declaration.
class JavaEntity < JavaType
  attr_reader :visibility, :kind
  attr_accessor :supertype, :interfaces

  # Initializes a new Java entity.
  def initialize(kind, type, opts={})
    @kind = kind
    @package = type.package
    @name = type.name
    @parameters = type.parameters
    @visibility = opts[:visibility]
    @modifiers  = opts[:modifiers ] || []
    @interfaces = opts[:interfaces] || []
    @supertype  = opts[:supertype ]

    if !@modifiers.empty?
      raise "Interfaces cannot have modifiers" if @type == :interface
      raise "Enumerations cannot have modifiers" if @type == :enum
    end

    if @modifiers.include?(:abstract) && @modifiers.include?(:final)
      raise "Classes cannot be abstract and final at the same time"
    end
  end

  # Determines whether the given type is a supertype of this entity.
  def extends?(type)
    @supertype && @supertype.type_of?(type) && @supertype
  end

  # Determines whether the given type is implemented by this entity.
  def implements?(type)
    @interfaces.find do |interface|
      interface.type_of? type
    end
  end

  # Determines whether the entity is abstract.
  def abstract?
    @modifiers.include? :abstract
  end

  # Determines whether the entity is final.
  def final?
    @modifiers.include? :final
  end

  # Determines whether the entity is static.
  def static?
    @modifiers.include? :static
  end
end


# Represents a Java source file, which imports classes from other files and
# contains its own type definitions.
class SourceFile
  attr_reader :name, :entities, :imports
  attr_accessor :package

  ENTITY_KINDS = [:class, :enum, :interface]
  VISIBILITIES = [:private, :protected, :public]
  MODIFIERS = [:abstract, :final, :static]

  # Initializes a new source file object.
  def initialize(path)
    @name = File.basename(path)
    @entities = []
    @imports = {}
  end

  # Adds a new import available to this file.
  def import(import)
    parts = import.split('.')
    package = parts[0...(parts.length-1)].join('.')
    name = parts.last # NOTE: this fails for member classes, but is fixed later
    @imports[name] = JavaType.new(package, name)
  end

  # Adds a new entity declaration to this file.
  def define(declaration)
    unless /^\s*((?:\w+\s+)*)(class|enum|interface)\s+(.+)$/ === declaration
      raise "Unprocessable declaration: #{declaration}"
    end

    # Format regex captures.
    keywords = $1.strip.split(' ').map { |k| k && k.strip.intern }.compact
    kind = $2.strip.intern
    remaining = $3

    # Check entity kind.
    unless ENTITY_KINDS.include? kind
      raise "Unknown entity kind: #{kind}"
    end

    opts = {}

    # Parse visibility and modifier keywords.
    keywords.each do |keyword|
      if VISIBILITIES.include? keyword
        raise "Declaration contains multiple visibility keywords: #{declaration}" if opts[:visibility]
        opts[:visibility] = keyword
      elsif MODIFIERS.include? keyword
        opts[:modifiers] ||= []
        opts[:modifiers] << keyword
      else
        raise "Unknown keyword: #{keyword}"
      end
    end

    # Parse entity type definition.
    type, remaining = parse_type(remaining, true)

    # Detect and parse supertype.
    if /^(.*)extends\s+(.+)/ === remaining
      before = $1
      opts[:supertype], after = parse_type($2)
      remaining = before && after && "#{before} #{after}" || before || after
    end

    # Detect and parse implemented interfaces.
    if /^\s*implements\s+(.+)/ === remaining
      opts[:interfaces] = []
      remaining = $1
      until remaining.empty?
        itype, remaining = parse_type(remaining)
        opts[:interfaces] << itype
      end
    end

    @entities << JavaEntity.new(kind, type, opts)
  end

  # Resolves all unqualified entity supertype and interface types.
  # - packages is a map of package names => simple names => type objects
  def resolve_types(packages)
    # Build a hash of qualified names to type objects.
    types = packages.values.map do |names|
      names.values
    end.flatten.inject(Hash.new) do |hash, type|
      hash[type.qualified_name] = type
      hash
    end

    # Check if an import's "package" is itself an entity.
    @imports.values.each do |import|
      actual_type = types[import.qualified_name]
      if actual_type && import != actual_type
        @imports[import.name] = actual_type
      end
    end

    # Resolve all contained entity types.
    @entities.each do |entity|
      entity.supertype = resolve(packages, entity.supertype)
      entity.interfaces = entity.interfaces.map do |interface|
        resolve(packages, interface)
      end
    end
  end

  private

  # Resolves the given simple name to a type.
  def resolve(packages, type)
    if type.nil?
      nil
    elsif type.package
      type
    elsif @imports.keys.include? type.name
      import = @imports[type.name]
      JavaType.new(import.package, type.name, type.parameters)
    elsif packages[@package] && packages[@package][type.name]
      JavaType.new(@package, type.name, type.parameters)
    else
      JavaType.new("java.lang", type.name, type.parameters)
    end
  end

  # Parses a Java type specification from a string, returning the type name,
  # any template parameters, and the unparsed part of the string.
  def parse_type(string, local=false)
    #log "parse_type(#{string.inspect}, #{local})"

    tokens = string.strip.split(/\s+/)
    token = tokens.shift

    unless /^([a-zA-Z]\w+)(<.+)?/ === token
      raise "First token is not a valid Java identifier: #{token}"
    end

    name = $1
    parameters = $2
    package = local && @package

    file_entity = @name.split('.').first
    name = "#{file_entity}$#{name}" if local && name != file_entity

    #log "  package: #{package.inspect}"
    #log "  name: #{name.inspect}"
    #log "  parameters: #{parameters.inspect}"
    #log "  tokens: #{tokens.inspect}"

    if parameters
      while !tokens.empty? && parameters.count('<') != parameters.count('>')
        parameters << " " << tokens.shift
      end
      unless parameters.count('<') == parameters.count('>')
        raise "Unbalanced parameters in type: #{string}" if tokens.empty?
      end
      parameters = parameters[1...(parameters.length-1)].split(/,\s*/)
    end

    [JavaType.new(package, name, parameters), tokens.join(' ')]
  end
end



##### PROCESSING #####

$start = Time.now
$sources = []

# Process input file arguments.
ARGV.each do |path|
  log "Processing #{path}"
  source = SourceFile.new(path)
  File.open(path) do |file|
    file.each do |line|
      case line
      when /^\s*package\s+([^;]+);/
        source.package = $1.strip
      when /^\s*import\s+(?:static\s+)?([^;]+?)(?:\.\*)?\s*;/
        source.import $1.strip
      when /^\s*(?:\w+\s+)*(?:class|enum|interface) /
        declaration = line.strip
        declaration << " " << file.readline.strip until declaration.include?('{')
        declaration = declaration[0...declaration.index('{')].strip
        source.define declaration
      end
    end
  end
  STDERR.puts "WARNING: #{source.name} does not appear to declare any entities!" if source.entities.empty?
  $sources << source
end

# Set of all local entity objects.
$entities = $sources.map { |source| source.entities }.flatten.sort

# Map of local package names to simple names to contained types.
$local_packages = $entities.inject(Hash.new) do |hash, entity|
  hash[entity.package] ||= Hash.new
  hash[entity.package][entity.name] = entity.raw_type
  hash
end

# Resolve entity types.
$sources.each do |source|
  source.resolve_types $local_packages
end

# Set of local raw types.
$local_types = $entities.map { |entity| entity.raw_type }

# Set of external raw types.
$external_types = $sources.map do |source|
  imports = source.imports.values
  supertypes = source.entities.map { |e| e.supertype }
  interfaces = source.entities.map { |e| e.interfaces }.flatten
  [imports, supertypes, interfaces].flatten
end.flatten.compact.map do |entity|
  entity.raw_type
end.uniq - $local_types

# Map of external package names to simple names to contained types.
$external_packages = $external_types.inject(Hash.new) do |hash, type|
  hash[type.package] ||= Hash.new
  hash[type.package][type.name] = type
  hash
end

# Set of types which are *implemented* by local entities. This helps determine
# whether external types are interfaces.
$implemented_types = $entities.map do |entity|
  entity.interfaces.map do |interface|
    interface.raw_type
  end
end.flatten.uniq

# Set of types which are *extended* by local entities and NOT implemented by
# any local entity. This helps etermine whether external types are classes.
$extended_types = $entities.map do |entity|
  entity.supertype && entity.supertype.raw_type
end.compact.uniq - $implemented_types

log "Processed %d files in %.3f sec" % [ARGV.size, Time.now - $start]
log "  Local: %d types in %d packages" % [$local_types.size, $local_packages.size]
log "  External: %d types in %d packages" % [$external_types.size, $external_packages.size]



##### GRAPHING #####

# Determines whether the given type should be excluded from the graph.
def excluded?(type)
  return true if $local_only && !$local_types.include?(type.raw_type)
  $exclude.each do |prefix|
    return true if type.qualified_name.index(prefix) == 0
  end
  false
end

# Print text indented by a certain amount.
def puts_indent(level, text)
  print "    "*level, text, "\n"
end

# Sanitize a name to allow it to be used as a node identifier.
def sanitize(name)
  #name.gsub(".", "_").gsub(/<.+>/, "")
  name.gsub(".", "_").gsub("$", "_")
end

# Opens a package subgraph.
def open_package_subgraph(level, package)
  name = sanitize package
  name = "cluster_#{name}" if $group_types

  puts_indent level, "subgraph #{name} {"
  puts_indent (level + 1), "label = \"#{package}\";"
end

# Draws a node for the given properties.
def draw_node(level, name, label, kind, styles=[])
  shape = case kind
          when :class     then "box"
          when :enum      then "hexagon"
          when :interface then "ellipse"
          else "rect"
          end

  attrs = []
  attrs << "color=red" unless kind
  attrs << "shape=#{shape}" if shape
  attrs << "label=\"#{label}\""
  attrs << "style=#{styles.join(',')}" unless styles.empty?

  puts_indent level, "#{sanitize name} [#{attrs.join(',')}];"
end

# Draws a local entity node.
def draw_local_entity(level, entity)
  return if excluded? entity

  name = entity.qualified_name
  label = entity.parameterized_name
  kind = entity.kind
  styles = []
  styles << "dashed" if entity.abstract?
  styles << "bold" if entity.final?
  styles << "diagonals" if entity.static?

  draw_node level, name, label, kind, styles
end

# Draws an external type node.
def draw_external_type(level, type)
  return if excluded? type

  name = type.qualified_name
  label = type.name
  kind = $implemented_types.include?(type) && :interface || $extended_types.include?(type) && :class

  draw_node level, name, label, kind
end

# Draws an edge between two nodes.
def draw_edge(level, src, dst)
  return if excluded?(src) || excluded?(dst)

  src_name = sanitize src.qualified_name
  dst_name = sanitize dst.qualified_name
  attrs = [];

  # Show parameterized type if present and not identical.
  unless dst.parameters.nil? || dst.parameters.empty? || dst.parameters == src.parameters
    attrs << "label=\"<#{dst.parameters.join(', ')}>\""
  end

  if attrs.empty?
    puts_indent level, "#{src_name} -> #{dst_name};"
  else
    puts_indent level, "#{src_name} -> #{dst_name} [#{attrs.join(',')}];"
  end
end


# Write graph file.
puts_indent 0, "digraph java_classes {"
puts_indent 1, "rankdir=LR;" if $layout == :horizontal
puts_indent 1, "node [shape=circle];" # this is for debugging any nodes which don't have an explicit shape set
puts ""

# Draw local package clusters and nodes.
puts_indent 1, "subgraph local_entities {"
$local_packages.each do |package, types|
  open_package_subgraph 2, package
  puts_indent 3, "node [color=black];"
  types.each do |name, type|
    entity = $entities.find {|e| e.raw_type == type }
    draw_local_entity 3, entity
  end
  puts_indent 2, "}"
end
puts_indent 1, "}"

# Draw external package clusters and nodes.
unless $local_only
  puts_indent 1, "subgraph external_types {"
  puts_indent 2, "node [style=dotted];"
  $external_packages.each do |package, types|
    open_package_subgraph 2, package
    puts_indent 3, "style = dashed;"
    puts_indent 3, "node [color=black];"
    types.each do |name, type|
      draw_external_type 3, type
    end
    puts_indent 2, "}"
  end
  puts_indent 1, "}"
end

# Draw supertype relationships.
puts_indent 1, "subgraph supertypes {"
puts_indent 2, "edge [color=red,weight=1];"
$entities.each do |entity|
  draw_edge 2, entity, entity.supertype if entity.supertype
end
puts_indent 1, "}"

# Draw interface relationships.
puts_indent 1, "subgraph interfaces {"
puts_indent 2, "edge [color=blue,weight=1];"
$entities.each do |entity|
  entity.interfaces.each do |interface|
    draw_edge 2, entity, interface
  end
end
puts_indent 1, "}"

# Draw member class relationships.
puts_indent 1, "subgraph members {"
puts_indent 2, "edge [color=darkgreen,weight=1,constraint=false];"
$entities.each do |entity|
  qname = entity.qualified_name
  if qname.include? '$'
    parent_qname = qname[0...qname.index('$')]
    parent = $entities.find { |e| e.qualified_name == parent_qname }
    draw_edge 2, entity, parent
  end
end
puts_indent 1, "}"

# Draw import relationships.
if $show_imports
  puts_indent 1, "subgraph imports {"
  puts_indent 2, "edge [color=grey];"
  $sources.each do |source|
    source.entities.each do |entity|
      source.imports.each do |name, import|
        draw_edge 2, entity, import unless entity.extends?(import) || entity.implements?(import)
      end
    end
  end
  puts_indent 1, "}"
end

puts_indent 0, "}"
