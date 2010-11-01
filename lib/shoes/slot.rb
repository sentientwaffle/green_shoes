class Shoes
  class Slot
    def initialize(opts = {})
      opts.each do |k, v|
        instance_variable_set "@#{ k }", v
      end
      @children = []
      @parent = @app.cslot
      @app.cslot = self
      if block_given?
        yield
        @app.cslot = @parent
      end
    end
    attr_accessor :real, :children
    
    def add(widget, x = nil, y = nil)
      @children << widget
      @real.pack_start widget.real, expand = false, fill = false
    end
  end
  
  class Layout < Slot
    def initialize(opts = {})
      opts = {
      }.update(opts)
      super
      @real = Gtk::Layout.new
    end
    def add(widget, x = 0, y = 0)
      @children << widget
      @real.put widget.real, x, y
    end
  end
  
  class Stack < Slot
    def initialize(opts = {})
      opts = {
      }.update(opts)
      @real = Gtk::VBox.new
      super
    end
  end
  
  class Flow < Slot
    def initialize(opts = {})
      opts = {
      }.update(opts)
      @real = Gtk::HBox.new
      super
    end
  end
  
  class App
    def stack(opts = {}, &blk)
      opts = slot_attributes(opts)
      opts[:app] = self
      stak = Stack.new(opts, &blk)
      self.cslot.add stak
      
      stak
    end
    
    def flow(opts = {}, &blk)
      opts = slot_attributes(opts)
      opts[:app] = self
      flo = Flow.new(opts, &blk)
      self.cslot.add flo
      
      flo
    end
  end
end
=begin
class Shoes
  class Slot
    def initialize(opts = {})
      @initials = opts
      opts.each do |k, v|
        instance_variable_set "@#{k}", v
      end
      
      Slot.class_eval do
        attr_accessor *opts.keys
      end
      
      @parent = @app.cslot
      @app.cslot = self
      @contents = []
      @parent.contents << self
      if block_given?
        yield
        @app.cslot = @parent
      else
        @left = @top = 0
      end
    end

    attr_accessor :contents
    attr_reader :parent, :initials

    def move3 x, y
      @left, @top = x, y
    end

    def positioning x, y, max
      @width = (parent.width * @initials[:width]).to_i if @initials[:width].is_a? Float
      if parent.is_a?(Flow) and x + @width <= parent.left + parent.width
        move3 x, max.top
        @height = Shoes.contents_alignment self
        max = self if max.height < @height
      else
        move3 parent.left, max.top + max.height
        @height = Shoes.contents_alignment self
        max = self
      end
      max.height = @height = @initials[:height] unless @initials[:height].zero?
      max
    end
  end

  class Stack < Slot; end
  class Flow < Slot; end
end
=end

