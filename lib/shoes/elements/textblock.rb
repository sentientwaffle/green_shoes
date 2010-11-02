class Shoes
  
  class TextBlock < Element
    def initialize(opts = {})
      super
    end
    def contents
      @texts
    end
    def replace(string)
      self.text = string
    end
    def text
      @real.text
    end
    def text=(string)
      @real.text = string
    end
    def to_s
      self.text
    end
  end
  
  class App
    def para(*texts)
      if texts.last.class == Hash
        opts = texts.pop
      else
        opts = {}
      end
      text = texts.join " "
      opts = basic_attributes {}
      
      lbl = Gtk::Label.new
      lbl.set_markup text
      
      opts[:real], opts[:text], opts[:texts], opts[:app] = lbl, text, texts, self
      
      ele = TextBlock.new opts
      #@cslot.add ele, opts[:left], opts[:top]
      ele
    end
  end
  
end
