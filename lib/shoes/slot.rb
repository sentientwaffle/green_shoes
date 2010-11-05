=begin
Slot
  
Layout
  
Stack
  add
  re_layout
Flow
  add
  re_layout

=end
class Shoes
  class Slot
    def initialize(opts = {})
      opts = {
        :left => nil,
        :top => nil,
        :width => 1.0,
        :height => 0
      }.update(opts)
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
      
      @current_x, @current_y = 0, 0
    end
    attr_accessor :real, :children, :x, :y, :height, :width
    
    # Widget can be an Element or another Slot.
    #def add(widget, x = nil, y = nil)
    #  @children << widget
    #  @real.put widget.real, x || @current_x, y || @current_y
    #end
    # Move the widget (which should have already been added) to the new coords.
    def position(widget, x, y)
      widget.x, widget.y = x, y
      if not widget.class.ancestors.include? Slot
        @app.canvas.real.move widget.real, x, y
      end
    end
    
  end
  
  # TODO:: This class is lame.
  class Layout < Slot
    def initialize(opts = {})
      opts = {
      }.update(opts)
      super
      @real = Gtk::Layout.new
    end
    def add(widget, x = 0, y = 0)
      @children << widget
      @app.canvas.real.put widget.real, x, y unless widget.class.ancestors.include? Slot
    end
  end
  
  # Position widgets above & below each other.
  class Stack < Slot
    def add(widget, x = nil, y = nil)
      @children << widget
      @app.canvas.add widget, 0, 0 unless widget.class.ancestors.include? Slot
      re_layout
    end
    
    # Reposition the child widgets in the new window dimensions.
    def re_layout
      max_h = 0
      current_y = 0
      @children.each do |widget|
        # Re-position the widget.
        position(widget, 0, current_y)
        current_y += widget.height
      end
      @current_y = current_y
    end
  end
  # Position widgets side by side.
  class Flow < Slot
    def add(widget, x = nil, y = nil)
      @children << widget
      @app.canvas.add widget, 0, 0 unless widget.class.ancestors.include? Slot
      re_layout
    end
    
    # Reposition the child widgets in the new window dimensions.
    # This is where widget wrapping happens.
    def re_layout
      t_w = 0
      t_h = 0
      max_w = 0
      max_h = 0
      current_x = 0
      current_y = 0
      @children.each do |widget|
        max_w = widget.width if widget.width > max_w
        max_h = widget.height if widget.height > max_h
        # If the addition of the widget would go over the
        # right side of this container, wrap around.
        if t_w + widget.width > @width
          current_x = 0
          current_y += max_h
        end
        # Re position
        position(widget, current_x, current_y)
        current_x += widget.width
      end
      @current_x = current_x
      @current_y = current_y
    end
  end
  
  class App
    def stack(opts = {}, &blk)
      #opts = slot_attributes(opts)
      opts[:app] = self
      stak = Stack.new(opts, &blk)
      self.cslot.add stak
      
      stak
    end
    
    def flow(opts = {}, &blk)
      #opts = slot_attributes(opts)
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

