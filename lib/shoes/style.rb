=begin
:align
:angle
:attach
:autoplay
:bottom
:cap
:center
:change
:checked
:click
:curve
:displace_left
:displace_top
:emphasis
:family
:fill
:font
:group
:height
:hidden
:inner
:items
:justify
:kerning
:leading
:left
:margin
:margin_bottom
:margin_left
:margin_right
:margin_top
:outer
:points
:radius
:right
:rise
:scroll
:secret
:size
:state
:stretch
:strikecolor
:strikethrough
:stroke
:strokewidth
:text
:top
:undercolor
:underline
:variant
:weight
:width
:wrap
end
class Shoes
  STYLES = [:align, :angle, :attach, :autoplay, :bottom, :cap, 
    :center, :change, :checked, :click, :curve, :displace_left, 
    :displace_top, :emphasis, :family, :fill, :font, :group, 
    :height, :hidden, :inner, :items, :justify, :kerning, :leading, 
    :left, :margin, :margin_bottom, :margin_left, :margin_right, 
    :margin_top, :outer, :points, :radius, :right, :rise, :scroll, 
    :secret, :size, :state, :stretch, :strikecolor, :strikethrough, 
    :stroke, :strokewidth, :text, :top, :undercolor, :underline, 
    :variant, :weight, :width, :wrap]
  
  class App
    def self.underline(text)
      "<u>#{ text }</u>"
    end
  end
  
  
  class Element
    
    def style(opts = nil)
      opts.each do |key, val|
        if STYLES.include? key
          instance_eval("#{ key.to_s } = val")
        end
      end
    end
    
    def restyle
      
    end
    
    def underline=(bool)
      @underline = bool
      @text = App.underline text
      restyle
    end
    
  end
=end
