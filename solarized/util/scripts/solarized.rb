#!/usr/bin/ruby

# This script prints out examples of every terminal color for testing purposes.
#
# Author:: Greg Look


##### CONFIGURATION #####

$mapping = ARGV[0] || 'dark'
$depth = ARGV[1] || '16'


##### CONSTANTS #####

ANSI_COLORS = { }
%w{black red green yellow blue magenta cyan white}.each_with_index do |color, i|
  ANSI_COLORS[color.intern] = i
  ANSI_COLORS[("br" + color).intern] = 8 + i
end

SOLARIZED_COLORS = {
  '16' => {
    :base03  => "1c1c1c",
    :base02  => "262626",
    :base01  => "585858",
    :base00  => "626262",
    :base0   => "808080",
    :base1   => "8a8a8a",
    :base2   => "e4e4e4",
    :base3   => "ffffd7",
    :yellow  => "af8700",
    :orange  => "d75f00",
    :red     => "d70000",
    :magenta => "af005f",
    :violet  => "5f5faf",
    :blue    => "0087ff",
    :cyan    => "00afaf",
    :green   => "5f8700",
  },
  '256' => {
    :base03  => "002b36",
    :base02  => "073642",
    :base01  => "586e75",
    :base00  => "657b83",
    :base0   => "839496",
    :base1   => "93a1a1",
    :base2   => "eee8d5",
    :base3   => "fdf6e3",
    :yellow  => "b58900",
    :orange  => "cb4b16",
    :red     => "dc322f",
    :magenta => "d33682",
    :violet  => "6c71c4",
    :blue    => "268bd2",
    :cyan    => "2aa198",
    :green   => "859900",
  }
}

COLOR_MAPS = {
  'light' => {
    :brblack   => :base03,
    :black     => :base02,
    :brgreen   => :base01,
    :bryellow  => :base00,
    :brblue    => :base0,
    :brcyan    => :base1,
    :white     => :base2,
    :brwhite   => :base3,
    :yellow    => :yellow,
    :brred     => :orange,
    :red       => :red,
    :magenta   => :magenta,
    :brmagenta => :violet,
    :blue      => :blue,
    :cyan      => :cyan,
    :green     => :green,
  },
  'dark' => {
    :black     => :base03,
    :brblack   => :base02,
    :green     => :base01,
    :yellow    => :base00,
    :blue      => :base0,
    :cyan      => :base1,
    :brwhite   => :base2,
    :white     => :base3,
    :bryellow  => :yellow,
    :red       => :orange,
    :brred     => :red,
    :brmagenta => :magenta,
    :magenta   => :violet,
    :brblue    => :blue,
    :brcyan    => :cyan,
    :brgreen   => :green,
  }
}


##### EXECUTION #####

def set_color(color, hex)
  puts "\033]P%x%s" % [color, hex]
end

map = COLOR_MAPS[$mapping]
colors = SOLARIZED_COLORS[$depth]

map.each do |ansi, sol|
  set_color ANSI_COLORS[ansi], colors[sol]
end
