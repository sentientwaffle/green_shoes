class Shoes
  
  class TextBlock < Element
    def initialize(opts = {})
      opts[:real] = Gtk::Label.new
      opts[:markup] = opts[:text] || ""
      super
      update_style
    end
    def contents
      @texts
    end
    def replace(string) # alias text=
      self.text = string
    end
    def text
      @real.text
    end
    def text=(string)
      @real.text = string
    end
    def to_s # alias text
      self.text
    end
    ########################
    # Style related methods.
    ########################
    def update_style
      @markup = "<span "
      @markup += 'underline="single"' if @underline
      @markup += ">#{ @text }</span>"
      @real.set_markup @markup
    end
    
    #def foreground=(color)
    #  @foreground = rgb(color)
    #end
    def underline=(bool)
      @underline = bool
      update_style
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
      opts = basic_attributes opts
      
      opts[:text], opts[:texts], opts[:app] = text, texts, self
      
      ele = TextBlock.new opts
    end
  end
  
end
