class Shoes
  
  class Button < Element
    def click(&blk)
      @real.signal_connect "clicked", &blk
    end
    def focus
      @real.grab_focus
    end
  end
  
  class App
    def button(name, opts={}, &blk)
      opts = basic_attributes opts
      b = Gtk::Button.new name
      b.signal_connect "clicked", &blk if blk
      
      opts[:real], opts[:text], opts[:app] = b, name, self
      
      ele = Button.new opts
      #@cslot.add ele, opts[:left], opts[:top]
      ele
    end
  end
  
end
