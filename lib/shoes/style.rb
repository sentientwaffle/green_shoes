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
=end
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
  
  class StyledText
    def initialize(string, opts = {})
      @text = string
      @opts = opts
    end
    attr_reader :text
    def to_pango
      styles = {}
      styles[:underline] = "single" if opts[:underline] == true
      
      styles_s = ""
      styles.each do |style_name, style_val|
        styles_s += "#{ style_name }=\"#{ style_val }\""
      end
      "<span #{ styles_s }>#{ @text }</span>"
    end
  end
  
end
