public class Litteris.Window : Gtk.ApplicationWindow {

	public Window (Gtk.Application application) {
		Object (
		    application: application,
    		height_request: 640,
            width_request: 980,
            border_width: 0,
            window_position: Gtk.WindowPosition.CENTER
		);
	}

    construct {
        var window_header = new Litteris.Header ();
        var window_panels = new Litteris.Panels ();

        set_titlebar (window_header);
        add (window_panels);

	 	show_all ();
    }

}
