class Shoes
  class Canvas
    attr_accessor :real, :height, :width, :x, :y, :cx, :cy
    def initialize(opts = {})
      opts.each do |k, v|
        instance_variable_set "@#{ k }", v
      end
      @children = []
      @parent = @app.cslot
      @app.cslot = self
      
      @x, @cx, @y, @cy, @ix, @iy = [0] * 6
      @width, @height = @app.width, @app.height
      @real = Gtk::Layout.new
      
      if block_given?
        yield
        @app.cslot = @parent
      end
    end
    def add(widget, x, y)
      widget.cx, widget.cy = x + widget.parent.cx, y + widget.parent.cy
      if widget.class.ancestors.include? Slot
        # ???
      else
        @real.put widget.real, widget.cx, widget.cy
      end
    end
    def position(widget, x, y)
      widget.cx, widget.cy = x + widget.parent.cx, y + widget.parent.cy
      if not widget.class.ancestors.include? Slot
        @real.move widget.real, widget.cx, widget.cy
      else
        widget.re_layout
      end
    end
  end
  
  # x, y : the desired x and y coordinates in relation to the parent.
  # cx, cy : the current x and y coordinates.
  # ix, iy : the i is for iterate (it doesnt make too much sense, stop trying to figure it out)
  #         ix and iy are the next coordinates for a child to be added to.
  class Slot
    NO_PREF = 0
    
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
      
      @x, @cx, @y, @cy, @ix, @iy, @cw, @ch = [0] * 8
      if block_given?
        yield
        @app.cslot = @parent
      end
    end
    attr_accessor :children, :x, :y, :cx, :cy, :ix, :iy, :cw, :ch, :parent
    
    # FIXME Only call these writers on the top level Flow!!!
    attr_writer :width, :height
    
    def width
      return @cw if @width == NO_PREF
      if @width.class == Float
        @width * @parent.width
      elsif @width.class == Fixnum
        @width
      end
    end
    def height
      return @ch if @height == NO_PREF
      if @height.class == Float
        @height * @parent.height
      elsif @height.class == Fixnum
        @height
      end
    end
    
  end
  
  # Position widgets above & below each other.
  class Stack < Slot
    def add(widget)
      @children << widget
      @app.canvas.add(widget, @ix, @iy)
      @iy += widget.height
      re_layout
    end
    
    # Reposition the child widgets in the new window dimensions.
    def re_layout
      @ix, @iy = 0, 0
      @children.each do |widget|
        @cw = widget.width if widget.width > @cw
        @ch = widget.height if widget.height > @ch
        # Re-position the widget.
        @app.canvas.position(widget, @ix, @iy)
        @iy += widget.height
      end
    end
  end
  # Position widgets side by side.
  class Flow < Slot
    def add(widget)
      @children << widget
      @app.canvas.add(widget, @ix, @iy)
      re_layout
    end
    
    # Reposition the child widgets in the new window dimensions.
    # This is where widget wrapping happens.
    def re_layout
      @ix, @iy = 0, 0
      @children.each do |widget|
        @cw = widget.width if widget.width > @cw
        @ch = widget.height if widget.height > @ch
        # If the addition of the widget would go over the
        # right side of this container, wrap around.
        if @ix + widget.width > self.width
          @ix = 0
          @iy += widget.height
        end
        # Re position
        @app.canvas.position(widget, @ix, @iy)
        @ix += widget.width
      end
    end
    
  end
  
  class App
    def stack(opts = {}, &blk)
      opts[:app] = self
      stak = Stack.new(opts, &blk)
      self.cslot.add stak
      
      stak
    end
    
    def flow(opts = {}, &blk)
      opts[:app] = self
      flo = Flow.new(opts, &blk)
      self.cslot.add flo
      
      flo
    end
  end
end
