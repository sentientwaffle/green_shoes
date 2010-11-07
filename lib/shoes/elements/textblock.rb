class Shoes
  
  class TextBlock < Element
    def initialize(opts = {})
      opts = opts[:app].basic_attributes opts
      
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
      {"font_family" => @family || nil,
      "font_desc" => @font || nil,
      "background" => @fill || nil,
      "foreground" => @stroke || nil,
      "stretch" => @stretch || nil,
      "strikethrough_color" => @strikecolor || nil,
      "strikethrough" => (@strikethrough) ? "true" : nil,
      "underline_color" => @undercolor || nil,
      "underline" => (@underline) ? "single" : nil,
      "variant" => @variant || nil,
      "weight" => @weight || nil
      }.each do |attr_name, attr_val|
        @markup += " #{ attr_name }=\"#{ attr_val }\"" if attr_val
      end
      @markup += ">#{ @text }</span>"
      @real.set_markup @markup
    end
    
    [:family, :font, :fill, :stroke, :stretch, :strikecolor,
      :strikethrough, :undercolor, :underline, :variant, :weight
    ].each do |style|
      define_method(style.to_s + "=") do |arg|
        instance_variable_set("@#{ style.to_s }", arg)
        update_style
      end
    end
    # : description
    #   Should have the form "[FAMILY-LIST] [STYLE-OPTIONS] [SIZE]"
    
    # : stretch
    # Possible values:
    # "condensed" - a smaller width of letters.
    # "normal" - the standard width of letters.
    # "expanded" - a larger width of letters.
    
    # : variant
    # "normal" - standard font.
    # "smallcaps" - font with the lower case characters
    # replaced by smaller variants of the capital characters.
    
    # : weight
    # "ultralight" || "light" || "normal" || "semibold" || "bold" || "ultrabold" || "heavy"
  end
  
  class App
    # Preference is a single style, passed by banner or another method.
    def text_block(preference, *texts)
      opts = preference.update(
        if texts.last.class == Hash
          texts.pop
        else
          {}
        end )
      text = texts.join " "
      
      opts[:text], opts[:texts], opts[:app] = text, texts, self
      
      ele = TextBlock.new opts
    end
    # The last argument can be a hash with additional options.
    def para(*texts) text_block(:font => 12, *texts); end
    def banner(*texts) text_block(:font => 48, *texts); end
    def title(*texts) text_block(:font => 34, *texts); end
    def subtitle(*texts) text_block(:font => 26, *texts); end
    def tagline(*texts) text_block(:font => 18, *texts); end
    def caption(*texts) text_block(:font => 14, *texts); end
    def inscription(*texts) text_block(:font => 10, *texts); end
    
    def code(*texts) text_block(:family => "Monospace", *texts); end
    def del(*texts) text_block(:strikethrough => true, *texts); end
    def em(*texts) text_block(:style => "italic", *texts); end
    def ins(*texts) text_block(:underline => true, *texts); end
    # TODO implement link
    def span(*texts) text_block({}, *texts); end
    def strong(*texts) text_block(:weight => "bold", *texts); end
    # TODO implement sub
    # TODO implement sup
    
  end
  
end
