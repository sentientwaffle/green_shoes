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
  class Layout
    attr_accessor :real, :height, :width, :x, :y
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
      
      @x, @y = 0, 0
      @width, @height = @app.width, @app.height
      @real = Gtk::Layout.new
    end
    def add(widget, x, y)
      widget.x, widget.y = x, y
      if widget.class.ancestors.include? Slot
        
      else
        @real.put widget.real, x, y unless widget.class.ancestors.include? Slot
      end
    end
    def position(widget, x, y)
      widget.x, widget.y = x,y#x + widget.parent.x, y + widget.parent.y
      if not widget.class.ancestors.include? Slot
        @real.move widget.real, x, y
      end
    end
  end
  
  
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
      @x, @y = 0, 0 # FIXME
      @current_x, @current_y = 0, 0
    end
    attr_accessor :real, :children, :x, :y
    
    def width
      @parent.width if @width == 0
      if @width.class == Float
        @width * @parent.width
      elsif @width.class == Fixnum
        @width
      end
    end
    def height
      @parent.height if @height == 0
      if @height.class == Float
        @height * @parent.height
      elsif @height.class == Fixnum
        @height
      end
    end
    
  end
  
  # Position widgets above & below each other.
  class Stack < Slot
    def add(widget, x = nil, y = nil)
      @children << widget
      @app.canvas.add widget, 0, 0
      re_layout
    end
    
    # Reposition the child widgets in the new window dimensions.
    def re_layout
      max_h = 0
      current_y = 0
      @children.each do |widget|
        # Re-position the widget.
        @app.canvas.position(widget, 0, current_y)
        current_y += widget.height
      end
      @current_y = current_y
    end
  end
  # Position widgets side by side.
  class Flow < Slot
    def add(widget, x = nil, y = nil)
      @children << widget
      @app.canvas.add widget, 0, 0
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
        if t_w + widget.width > self.width
          current_x = 0
          current_y += max_h
        end
        # Re position
        @app.canvas.position(widget, current_x, current_y)
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
