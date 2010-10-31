class Shoes
  
  class EditLine < Element
    def change(&blk)
      @real.signal_connect "changed", &blk
    end
    
    def focus
      @real.grab_focus
    end
    
    def text
      @real.text
    end
    
    def text=(str)
      @real.text = str
    end
    
  end
  
  class App
    def editline(opts = {})
      opts = basic_attributes opts
      b = Gtk::Entry.new
      
      opts[:real], opts[:app] = b, self
      
      ele = EditLine.new opts
      @cslot.add ele
      ele
    end
  end
  
end
