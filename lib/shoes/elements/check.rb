class Shoes
  
  class Check < Element
    def checked?
      @real.active?
    end
    def checked=(bool)
      @real.active = bool
    end
    def click(&blk)
      @real.signal_connect "clicked", &blk
    end
    def focus
      @real.grab_focus
    end
  end
  
  class App
    def check(opts={}, &blk)
      opts = basic_attributes opts
      b = Gtk::CheckButton.new
      opts[:real], opts[:app] = b, self
      
      ele = Check.new opts
      @cslot.add ele, opts[:left], opts[:top]
      ele
    end
  end
  
end
