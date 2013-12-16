#!/usr/bin/env ruby

# This script analyzes the output of the Rake build system to generate a
# graph of the available build tasks and their dependencies.
#
# The resulting graph specification is printed to stdout and is suitable for
# piping directly into a graph layout command such as `dot`:
#
#  $ rake-tasks.rb | dot -Tpng > tasks.png
#
# Author:: Greg Look


# Fails the script and exits with an error code.
def fail(message=nil, code=1)
  STDERR.puts(message) if message
  exit code
end


# List of task names.
TASK_NAMES = []
# Map of task names to their descriptions.
TASK_DESC = {}
# Map of task names to lists of their dependencies.
TASK_PREREQS = {}
# Task heirarchy.
TASK_NAMESPACES = {}



##### DATA COLLECTION #####

# Collect task descriptions.
begin
  descs = %x{rake --tasks}
  fail unless $?.success?

  descs.split("\n").each do |line|
    if line =~ /^rake (\S+)\s+# (.+)/
      TASK_DESC[$1] = $2
    end
  end
end

# Collect rake task prerequisites.
begin
  prereqs = %x{rake --prereqs}
  fail unless $?.success?

  task = nil
  prereqs.split("\n").each do |line|
    if line =~ /^rake (.+)/
      task = $1
      TASK_NAMES << task
    else
      TASK_PREREQS[task] ||= []
      TASK_PREREQS[task] << line.strip
    end
  end
end



##### DATA PROCESSING #####

# Resolve namespace-relative prereqs.
TASK_NAMES.each do |task|
  if TASK_PREREQS.has_key? task
    TASK_PREREQS[task] = TASK_PREREQS[task].map do |prereq|
      namespaces = task.split(':')
      namespaces.pop # remove the task name

      until namespaces.empty?
        fqtn = "#{namespaces.join(':')}:#{prereq}"
        if TASK_NAMES.include? fqtn
          prereq = fqtn
          break
        end
        namespaces.pop
      end

      prereq
    end
  end
end

# Build namespaced task hierarchy.
TASK_NAMES.each do |task|
  namespaces = task.split(':')
  namespaces.pop # remove the task name

  ns = TASK_NAMESPACES
  until namespaces.empty?
    name = namespaces.shift
    ns[name] ||= {}
    ns = ns[name]
  end
end



##### GRAPH GENERATION #####

# Sanitizes node names.
def sanitize(name)
  name.gsub(/[\/:\.]/, '_')
end

# Prints indented text.
def puts_indent(level, text)
  print "    "*level, text, "\n"
end

# Draws a task node.
def draw_task(task, level=1)
  id = sanitize task
  label = task.split(':').last
  style = TASK_DESC.has_key?(task) ? "" : ",style=dashed"
  puts_indent level, "#{id} [label=\"#{label}\"#{style}];"
end

# Recursively draws a namespace subgraph. The first argument should be a fully
# qualified namespace string, separated with colons. The second is the hash
# containing the child namespaces.
def draw_namespace(name, children, level=1)
  id = "cluster_#{sanitize name}"
  label = name.split(':').last

  puts_indent level, "subgraph #{id} {"
  puts_indent level + 1, "label = \"#{label}\";"

  # Draw child namespaces first.
  children.keys.sort.each do |child|
    draw_namespace child, children[child], level + 1
  end

  # Draw task nodes.
  tasks = TASK_NAMES.select do |task|
    ns = task.split(':')
    ns.pop
    name == ns.join(':')
  end

  tasks.sort.each do |task|
    draw_task task, level + 1
  end

  puts_indent level, "}"
end


# Generate output graph.
puts "digraph rake_tasks {"
puts "    node [shape=box];"

# Draw all tasks in namespace clusters.
TASK_NAMESPACES.each do |name, children|
  draw_namespace name, children
end

# Draw all top-level tasks.
puts_indent 1, "subgraph top_tasks {"
puts_indent 2, "rank = same;"
TASK_NAMES.each do |task|
  draw_task task unless task.include? ':'
end
puts_indent 1, "}"

# Draw dependencies between tasks.
TASK_PREREQS.keys.sort.each do |task|
  TASK_PREREQS[task].each do |prereq|
    puts_indent 1, "#{sanitize task} -> #{sanitize prereq};"
  end
end

puts "}"
