class Shoes
  
  class Element
    attr_reader :real
    def initialize(opts = {})
      opts.each do |k, v|
        instance_variable_set "@#{ k }", v
      end
      @parent = @app.cslot
      
      @opts = opts
    end
    
    def displace(args = {})
    end
    
    def height
      @real.height_request
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
      return @styles if styles == nil
      #:align
      #:angle
      #:attach
      #:autoplay
      #:bottom
      #:cap
      #:center
      #:change
      #:checked
      #:click
      #:curve
      #:displace_left
      #:displace_top
      #:emphasis
      #:family
      #:fill
      #:font
      #:group
      #:height
      #:hidden
      #:inner
      #:items
      #:justify
      #:kerning
      #:leading
      #:left
      #:margin
      #:margin_bottom
      #:margin_left
      #:margin_right
      #:margin_top
      #:outer
      #:points
      #:radius
      #:right
      #:rise
      #:scroll
      #:secret
      #:size
      #:state
      #:stretch
      #:strikecolor
      #:strikethrough
      #:stroke
      #:strokewidth
      #:text
      #:top
      #:undercolor
      #:underline
      #:variant
      #:weight
      #:width
      #:wrap
      b.set_size_request opts[:width] || @width, opts[:height] || @height
    end
    
    def toggle
      (@real.visible) ? @real.hide : @real.show
    end
    
    def top
    end
    
    def width
      @real.width_request
    end
    
  end
  
end
