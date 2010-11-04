class Shoes
  include Types
  @apps = []

  def self.app(opts = {}, &blk)
    opts = {
      :width => 600,
      :height => 600,
      :title => "Green Shoes!",
      :left => 0,
      :top => 0
    }.update(opts)

    app = App.new(opts)
    @apps.push app

    #Flow.new(app.slot_attributes(:app => app, :left => 0, :top => 0)) # XXX
    
    # Gtk::Window setup.
    win = Gtk::Window.new
    win.icon = Gdk::Pixbuf.new File.join(DIR, '../static/gshoes-icon.png')
    win.title = opts[:title]
    win.set_default_size(opts[:width], opts[:height])
    
    style = win.style
    style.set_bg Gtk::STATE_NORMAL, 65535, 65535, 65535
    
    class << app; self end.class_eval do
      define_method(:width)  { win.size[0] }
      define_method(:height) { win.size[1] }
    end
    
    win.set_events Gdk::Event::BUTTON_PRESS_MASK | Gdk::Event::BUTTON_RELEASE_MASK | Gdk::Event::POINTER_MOTION_MASK
    
    win.signal_connect("delete-event") do
      false
    end
    
    win.signal_connect "destroy" do
      Gtk.main_quit
      File.delete TMP_PNG_FILE if File.exist? TMP_PNG_FILE
    end if @apps.size == 1
=begin
    win.signal_connect("button_press_event") do
      #mouse_click_control app
    end
    
    win.signal_connect("button_release_event") do
      #mouse_release_control app
    end

    win.signal_connect("motion_notify_event") do
      #mouse_motion_control app
    end
=end
    # Canvas is as Layout.
    app.canvas = Layout.new(:app => app)
    # Widgets should go to the Flow.
    app.cslot = Flow.new(:app => app)
    app.canvas.add(app.cslot, 0, 0)
    
    win.add app.canvas.real
    #app.canvas.style = style
    app.win = win

    app.instance_eval &blk if blk
    
    Gtk.timeout_add 100 do
      #if size_allocated? app
        #call_back_procs app
      w, h = app.width, app.height
      if (app.width_pre != w) || (app.height_pre != h)
        app.re_layout
      end
      app.width_pre, app.height_pre = w, h
      #end
      #set_cursor_type app
      true
    end

    #call_back_procs app
    
    win.show_all
    @apps.pop
    Gtk.main if @apps.empty?
    app
  end
end
