require 'tmpdir'
require 'pathname'
require 'cairo'
require 'pango'
require 'gtk2'

Types = module Shoes; self end

module Shoes
  DIR = Pathname.new(__FILE__).realpath.dirname.to_s
  TMP_PNG_FILE = File.join(Dir.tmpdir, '__green_shoes_temporary_file__')
  HAND = Gdk::Cursor.new(Gdk::Cursor::HAND1)
  ARROW = Gdk::Cursor.new(Gdk::Cursor::ARROW)
end

class Object
  remove_const :Shoes
end

def require_relative(f)
  require File.join(File.dirname(__FILE__), f + '.rb')
end

require_relative 'shoes/ruby'
require_relative 'shoes/helper_methods'
require_relative 'shoes/colors'

require_relative 'shoes/basic'
["common", "background", "border",
  "button", "check", "editbox",
  "editline", "image", "listbox",
  "progress", "radio", "shape",
  "textblock", "timers", "video"
].each do |w|
  require_relative "shoes/elements/#{ w }"
end

require_relative 'shoes/main'
require_relative 'shoes/app'
require_relative 'shoes/anim'
require_relative 'shoes/slot'
