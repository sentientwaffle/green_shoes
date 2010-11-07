class Shoes
  
  class EditBox < Element
    def initialize(opts = {}, &blk)
      opts = opts[:app].basic_attributes opts
      #opts = {:height => 100, :width => 100}.update(opts)
      opts[:real] = Gtk::TextView.new
      opts[:markup] = opts[:text] if opts[:text]
      
      super
      @real.signal_connect "clicked", &blk if blk
      @real.buffer.text = opts[:markup]
    end
    def change(&blk)
      @real.signal_connect "changed", &blk
    end
    def focus
      @real.grab_focus
    end
    def text
      @real.buffer.text
    end
    def text=(str)
      @real.buffer.text = str
    end
  end
  
  class App
    def edit_box(opts = {}, &blk)
      opts[:app] = self
      ele = EditBox.new opts
      ele
    end
  end
  
end
