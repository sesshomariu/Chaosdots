#!/usr/bin/ruby
load 'ncgems.rb' # load all necessary gems

if !(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  dismiss_dialog = Gtk::Dialog.new(:title=>"WHOOPSIE!!!11!!1")
  dismiss_dialog.child << Gtk::Label.new("Well, this app does not work on Windows.\nGet shit done, dude.")
  dismiss_dialog.add_button("I promise I will install Linux",0)
  dismiss_dialog.signal_connect("response") {Gtk.main_quit}
  dismiss_dialog.show_all
  Gtk.main
  exit(0)
end

builder_file = Dir.pwd << "/interface.ui"
builder = Gtk::Builder.new(:file=>builder_file)
win = builder.get_object("window1")
win.signal_connect("destroy") {Gtk.main_quit}
fc = builder.get_object("filechoose")
filter = Gtk::FileFilter.new
filter_arr = %w[png jpg gif bmp tif tiff]
filter_arr.each{|p|filter.add_pattern("*."<<p)}
fc.filter = filter
cb_gif_checked = false
send_button = builder.get_object("send_button")
cb = builder.get_object("check_ani")
fd_spin = builder.get_object("frame_delay")
=begin
fd_spin.value = 300
fd_spin.set_range(100,1000)
fd_spin.climb_rate = 100.0
fd_spin.numeric = true
fd_aj = Gtk::Adjustment.new(100, 100, 1000, 100, 1000)
fd_spin.adjustment = fd_aj
=end

send_button_enabled = false

validate_all = lambda{
  send_button_enabled = true
  send_button_enabled &= fc.uri!=nil
  send_button.sensitive = send_button_enabled
}

fc.signal_connect("selection-changed") {
  cb_gif_checked = cb.active?
  if fc.uri.to_s.split("/")[-1].split(".")[-1]=='gif' # check if the file is a gif
    cb.sensitive = true
    cb.active = cb_gif_checked
  else
    cb.sensitive = false
    cb.active = false
  end
  validate_all.call
}

cb.signal_connect("toggled") {
  fd_spin.sensitive = cb.active?
}

send_button.signal_connect("clicked") {
  Dir.chdir("picedit/")
  #TODO Prepare the sending of an image
  if !cb.active? # check if picture is not flagged as animated
    # single picture
    #fc.uri.to_s.split("file://")[-1]
    #puts execstr
    #system(execstr)
    puts "MODE: single picture"
  else
    puts "MODE: multiple pictures"
    # multiple pictures
  end
  Dir.chdir("..")
}

!Dir.exist?(Dir.pwd<<"/picedit")&&Dir.mkdir(Dir.pwd<<"/picedit")

send_button.sensitive = false

Gtk.main