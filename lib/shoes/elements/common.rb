class Shoes
  
  class Element
    attr_accessor :real, :x, :y # debug only -- change to reader
    def initialize(opts = {})
      opts.each do |k, v|
        instance_variable_set "@#{ k }", v
      end
      @parent = @app.cslot
      @parent.add self
      
      @markup = opts[:text] || ""
      
      @opts = opts
    end
    
    def displace(args = {})
    end
    
    def height
      #if self.class.ancestors.include? Slot
      #  @real.size[1]
      #else
        @real.size_request[1]
      #end
    end
    
    def hide
      @real.hide
    end
    
    def left
    end
    
    def move(opts)
      args = {:left => 0, :top => 0}.update(opts)
    end
    
    def parent
      @parent
    end
    
    def remove
    end
    
    def show
      @real.show
    end
    
    def style(opts = nil)
    #  return @styles if styles == nil
    #  b.set_size_request opts[:width] || @width, opts[:height] || @height
    end
    
    def toggle
      (@real.visible) ? @real.hide : @real.show
    end
    
    def top
    end
    
    def width
      #if self.class.ancestors.include? Slot
      #  @real.size[0]
      #else
        @real.size_request[0]
      #end
    end
    
  end
  
end
