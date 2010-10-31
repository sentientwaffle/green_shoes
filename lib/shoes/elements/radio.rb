class Shoes
  
  class Radio < Element
    def initialize(opts = {})
      super
      group = nil
      # Set the radio button group to all other radio buttons in this slot.
      @parent.children.each do |element|
        if element.class == Radio
          group = element.real
          break
        end
      end
      @real.group = group if group
      
    end
    
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
