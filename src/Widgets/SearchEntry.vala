public class Litteris.Search : Gtk.Box {
    public signal void search_content_changed (string search_content = "");
    public signal void show_find_button ();
    public signal void show_search_entry ();

    public Search () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 0
        );
    }

    construct {
        create_find_button ();

        show_search_entry.connect (create_search_entry);
        show_find_button.connect (create_find_button);
    }

    public void create_find_button () {
        var find_button = new Gtk.ToggleButton ();
            find_button.image = new Gtk.Image.from_icon_name ("edit-find", Gtk.IconSize.LARGE_TOOLBAR);
            find_button.tooltip_text = _("Find Contact");
            find_button.clicked.connect (() => {
                this.show_search_entry ();
            });

        this.remove_widgets ();
        this.pack_end (find_button);
        this.show_all ();
        find_button.grab_focus ();
    }

    public void create_search_entry () {
        var search_entry = new Gtk.SearchEntry ();

        search_entry.focus_out_event.connect(() => {
            this.show_find_button ();
            this.search_content_changed ();
            return true;
        });

        search_entry.search_changed.connect (() => {
			this.search_content_changed (search_entry.text);
        });

        //work around to avoid multiple deletions
        search_entry.stop_search.connect (() => {
            search_entry.move_focus (Gtk.DirectionType.TAB_FORWARD);
        });

        this.remove_widgets ();
        this.pack_end (search_entry);
        this.show_all ();
        search_entry.grab_focus ();
    }

    public void remove_widgets () {
        var box_children = this.get_children ();
        foreach (var x in box_children) {
                this.remove (x);
        }
    }

}
