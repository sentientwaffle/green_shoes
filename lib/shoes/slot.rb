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
      p "ADD CALLED"
      widget.cx, widget.cy = x + widget.parent.cx, y + widget.parent.cy
      if widget.class.ancestors.include? Slot
        # ???
      else
        @real.put widget.real, widget.cx, widget.cy unless widget.class.ancestors.include? Slot
      end
    end
    def position(widget, x, y)
      p "POSITION CALLED"
      widget.cx, widget.cy = x + widget.parent.cx, y + widget.parent.cy
      if not widget.class.ancestors.include? Slot
        @real.move widget.real, widget.cx, widget.cy
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
      
      @x, @cx, @y, @cy, @ix, @iy = [0] * 6
      if block_given?
        yield
        @app.cslot = @parent
      end
    end
    attr_accessor :real, :children, :x, :y, :cx, :cy, :ix, :iy, :parent
    
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
      p "stack add"
      @app.canvas.add(widget, @ix, @iy)
      re_layout
    end
    
    # Reposition the child widgets in the new window dimensions.
    def re_layout
      p "Stack RE-LAYOUT BEGIN"
      @iy = 0
      @children.each do |widget|
        # Re-position the widget.
        @app.canvas.position(widget, @ix, @iy)
        @iy += widget.height
      end
      p "Stack RE-LAYOUT BEGIN"
    end
  end
  # Position widgets side by side.
  class Flow < Slot
    def add(widget, x = nil, y = nil)
      @children << widget
      @app.canvas.add(widget, @ix, @iy)
      re_layout
    end
    
    # Reposition the child widgets in the new window dimensions.
    # This is where widget wrapping happens.
    def re_layout
      p "FLOW RE-LAYOUT BEGIN"
      t_w = 0
      t_h = 0
      #max_w = 0
      #max_h = 0
      @ix = 0
      @iy = 0
      @children.each do |widget|
        #max_w = widget.width if widget.width > max_w
        #max_h = widget.height if widget.height > max_h
        # If the addition of the widget would go over the
        # right side of this container, wrap around.
        if t_w + widget.width > self.width
          @ix = 0
          @iy += widget.height#max_h
        end
        # Re position
        @app.canvas.position(widget, @ix, @iy)
        @ix += widget.width
      end
      p "FLOW RE-LAYOUT END"
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
