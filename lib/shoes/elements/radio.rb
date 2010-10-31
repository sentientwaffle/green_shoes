class Shoes
  
  class Radio < Element
    def checked?
      
    end
    def checked=(bool)
      @real.set_active bool
    end
    def click(&blk)
      @real.signal_connect "clicked", &blk
    end
    def focus
      @real.grab_focus
    end
  end
  
  class App
    def radio(opts={}, &blk)
      opts = basic_attributes opts
      b = Gtk::RadioButton.new
      
      opts[:real], opts[:app] = b, self
      
      ele = Radio.new opts
      @cslot.add ele, opts[:left], opts[:top]
      ele
    end
  end
  
end
