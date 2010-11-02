class Range 
  def rand 
    conv = (Integer === self.end && Integer === self.begin ? :to_i : :to_f)
    ((Kernel.rand * (self.end - self.begin)) + self.begin).send(conv) 
  end 
end

class Object
  def alert(msg)
    dialog = Gtk::MessageDialog.new(
      app.win,
      Gtk::Dialog::MODAL,
      Gtk::MessageDialog::INFO,
      Gtk::MessageDialog::BUTTONS_OK,
      msg
    )
    dialog.title = "Shoes says:"
    dialog.run
    dialog.destroy
  end
  
  # Convert the RGB(A) values to a hex color string.
  # The `A` is optional.
  # r, g, b, and a can be Float or Fixnum.
  def rgb(r, g, b, a = 1.0)
    c = "#"
    [r, g, b, a].each do |color|
      if color.class == Float
        c += (color * 255).to_s(16)
      elsif color.class == Fixnum
        c += color.to_s(16)
      else
        throw ArgumentError, "#{ color } is not a Float or Integer"
      end
    end
    return c
  end
end
