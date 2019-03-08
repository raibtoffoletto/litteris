public class Litteris.Panels : Gtk.Paned {

	public Panels () {
		Object (
			orientation: Gtk.Orientation.HORIZONTAL,
    		position: 180
		);
	}

	construct {
		var left_panel = new Litteris.ContactList ();
		var right_panel = new Litteris.Welcome ();

		add1 (left_panel);
		add2 (right_panel);
	}
}
