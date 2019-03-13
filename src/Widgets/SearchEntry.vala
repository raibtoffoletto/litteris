public class Litteris.Search : Gtk.Box {

	public Gtk.ToggleButton button_find;
	public Gtk.SearchEntry search_entry;

	public Search () {
		Object (
			orientation: Gtk.Orientation.HORIZONTAL,
			spacing: 0
		);
	}

	construct {

		button_find = new Gtk.ToggleButton ();
		button_find.image = new Gtk.Image.from_icon_name ("edit-find", Gtk.IconSize.LARGE_TOOLBAR);
		button_find.tooltip_text = "Find Contact";
        button_find.toggled.connect (search_entry_show);

		search_entry = new Gtk.SearchEntry ();
        search_entry.stop_search.connect (search_entry_hide); 
        search_entry.focus_out_event.connect(() => {
        	search_entry_hide ();
			return false;
        });

		search_entry.search_changed.connect (() => {
			stdout.printf ("changed!! \n \n ");
        }); 

		pack_start (button_find);
        show_all ();
	}

	public void search_entry_show () {
		remove (button_find);
		pack_end (search_entry);
		show_all ();
		search_entry.grab_focus ();
	}

	public void search_entry_hide () {
		var list = this.get_children ();
		foreach (var x in list) {
			if (x.name == "GtkSearchEntry") {
				pack_end (button_find);
				button_find.grab_focus ();
				show_all ();
				search_entry.set_text ("");
				remove (search_entry);
			}
		}
	}

}
