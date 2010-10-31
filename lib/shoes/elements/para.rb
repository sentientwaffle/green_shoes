class Shoes
  
  class Para < Element
    
  end
  
  class App
    def para(*texts)
      text = texts.join " "
      opts = basic_attributes {}
      
      lbl = Gtk::Label.new
      lbl.set_markup text
      
      opts[:real], opts[:text], opts[:app] = lbl, text, self
      
      ele = Para.new opts
      @cslot.add ele, opts[:left], opts[:top]
      ele
    end
  end
  
end
