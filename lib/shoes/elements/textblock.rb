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
      @markup = "<span"
      {"background" => @fill || nil,
      "foreground" => @stroke || nil,
      "stretch" => @stretch || nil,
      "strikethrough_color" => @strikecolor || nil,
      "strikethrough" => (@strikethrough) ? "true" : nil,
      "underline_color" => @undercolor || nil,
      "underline" => (@underline) ? "single" : nil
      }.each do |attr_name, attr_val|
        @markup += " #{ attr_name }=\"#{ attr_val }\"" if attr_val
      end
      @markup += ">#{ @text }</span>"
      @real.set_markup @markup
    end
    
    def fill=(color)
      @fill = color
      update_style
    end
    def stroke=(color)
      @stroke = color
      update_style
    end
    
    # Possible values:
    # "condensed" - a smaller width of letters.
    # "normal" - the standard width of letters.
    # "expanded" - a larger width of letters.
    def stretch=(str)
      @stretch = str if %w[condensed normal expanded].include? str
    end
    
    def strikecolor(color)
      @strikecolor = color
      update_style
    end
    def strikethrough=(bool)
      @strikethrough = bool
      update_style
    end
    
    def undercolor=(color)
      @undercolor = color
      update_style
    end
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
