#!/usr/bin/ruby

# This script prints out examples of every terminal color for testing purposes.
# See: http://en.wikipedia.org/wiki/ANSI_escape_code
#
# Author:: Greg Look



##### COLOR CLASS #####

class Color
  attr_reader :num, :names, :r, :g, :b, :hex

  def initialize(num, props={})
    @num = num
    @names = props[:names] || []

    if props[:hex]
      @hex = props[:hex]
      unless props[:rgb]
        @r = @hex[0..1].to_i(16)
        @g = @hex[2..3].to_i(16)
        @b = @hex[4..5].to_i(16)
      end
    end

    if props[:rgb]
      @r = props[:rgb][0]
      @g = props[:rgb][1]
      @b = props[:rgb][2]
      unless @hex
        @hex = "%02x%02x%02x" % [@r, @g, @b]
      end
    end
  end

  def name
    @names.first
  end

  def diff(color)
    dr = color.r - @r
    dg = color.g - @g
    db = color.b - @b

    Math.sqrt(dr**2 + dg**2 + db**2)
  end

  def mag
    Math.sqrt(@r**2 + @g**2 + @b**2)
  end

  COLORS = [
    Color.new( 0, :hex => '000000', :names => ['black']),
    Color.new( 1, :hex => 'cd0000', :names => ['red']),
    Color.new( 2, :hex => '00cd00', :names => ['green']),
    Color.new( 3, :hex => 'cdcd00', :names => ['yellow']),
    Color.new( 4, :hex => '0000ee', :names => ['blue']),
    Color.new( 5, :hex => 'cd00cd', :names => ['magenta']),
    Color.new( 6, :hex => '00cdcd', :names => ['cyan']),
    Color.new( 7, :hex => 'e5e5e5', :names => ['white', 'gray']),
    Color.new( 8, :hex => '7f7f7f', :names => ['brightblack', 'darkgray']),
    Color.new( 9, :hex => 'ff0000', :names => ['brightred']),
    Color.new(10, :hex => '00ff00', :names => ['brightgreen']),
    Color.new(11, :hex => '5c5cff', :names => ['brightyellow']),
    Color.new(12, :hex => '0000ff', :names => ['brightblue']),
    Color.new(13, :hex => 'ff00ff', :names => ['brightmagenta']),
    Color.new(14, :hex => '00ffff', :names => ['brightcyan']),
    Color.new(15, :hex => 'ffffff', :names => ['brightwhite']),
  ]

  def self.[](i)
    raise "#{i} is not a valid color number" if i < 0 || i > 255

    # basic ansi color
    if i < 16
      COLORS[i]

    # color cube
    elsif i < 232
      # get cube coordinates
      r = ((i - 16)     )/36
      g = ((i - 16) % 36)/6
      b = ((i - 16) %  6)

      # translate to colors
      r = ( r == 0 ) ? 0 : ( 55 + 40*r )
      g = ( g == 0 ) ? 0 : ( 55 + 40*g )
      b = ( b == 0 ) ? 0 : ( 55 + 40*b )

      Color.new(i, :rgb => [r, g, b])

    # grayscale ramp
    else
      v = 10*(i - 232) + 8

      Color.new(i, :rgb => [v, v, v])
    end
  end

  def self.match(target)
    best = COLORS[0]

    256.times do |i|
      color = self[i]
      best = color if target.diff(color) < target.diff(best)
    end

    best
  end
end



##### COLORIZING METHODS #####

ANSI_SGR = "\e[%sm"

SGR_NONE      = 0
SGR_BOLD      = 1
SGR_UNDERLINE = 3
SGR_REVERSE   = 7
SGR_HIDDEN    = 8
SGR_FG_BASE   = 30
SGR_FG_256    = 38
SGR_FG_RESET  = 39
SGR_BG_BASE   = 40
SGR_BG_256    = 48
SGR_BG_RESET  = 49

# select graphic rendition
def sgr(*codes)
  ANSI_SGR % codes.join(';')
end

# reset colors
def reset
  sgr(SGR_NONE)
end

# set 256-color foreground
def fg(i)
  sgr(SGR_FG_256, 5, i)
end

# set 256-color background
def bg(i)
  sgr(SGR_BG_256, 5, i)
end

# print a square block of solid color
def swatch(i)
  print "#{bg(i)}  #{reset}"
end

# print detailed info about a color object
def detail(color)
  invert = color.mag < 150
  block = "#{bg(color.num)}#{fg(invert ? 7 : 0)} %s #{reset}" % color.hex
  rgb = "(#{fg(9)}%3d#{reset}, #{fg(10)}%3d#{reset}, #{fg(12)}%3d#{reset})" % [color.r, color.g, color.b]
  puts "%4d %s %s %s" % [color.num, block, rgb, color.names.join(', ')]
end



##### COLOR TESTS #####

def test_ansi_colors
  puts "ANSI colors (0-15):"
  Color::COLORS[0...8].each do |color|
    puts "%8s: %sdark#{reset} %slight#{reset}" % [color.name, sgr(SGR_FG_BASE + color.num), sgr(1, SGR_FG_BASE + color.num)]
  end
  print "\n"
end

def test_system_colors
  puts "System colors (0-15):"
  print " %3d " % 0
  8.times {|i| swatch(i) }
  print "\n %3d " % 8
  8.times {|i| swatch(i+8) }
  print "\n\n"
end

def test_color_cube
  puts "6x6x6 color cube (16-231):"
  6.times do |row|
    6.times do |layer|
      offset = 36*layer + 6*row + 16
      print " %3d " % offset
      6.times do |col|
        swatch(offset + col)
      end
      print " "
    end
    print "\n"
  end
  print "\n"
end

def test_grayscale
  puts "Grayscale (232-255):"
  print " %3d " % 232
  24.times do |i| swatch(i + 232) end
  print "\n\n"
end



##### EXECUTION #####

def fail(msg)
  STDERR.puts(msg)
  exit 1
end

# if no arguments, just output test colors
if ARGV.empty?
  test_ansi_colors
  test_system_colors
  test_color_cube
  test_grayscale
  exit
end

# otherwise, try to interpret arguments as a color name, number, or rgb hex string
ARGV.each do |arg|
  search = arg.strip.downcase

  color = case search
  when /^#?[0-9a-f]{6}$/
    hex = search.gsub(/^#/, '')
    target = Color.new(nil, :hex => hex)
    Color.match(target)
  when /^\d+$/
    Color[search.to_i]
  else
    name = search.gsub(/^(bold|light)/, 'bright').gsub(' ', '')
    Color::COLORS.find {|c| c.names.include? name }
  end

  fail "#{arg} is not a valid hex value, color number, or color name" unless color
  detail(color)
end
