public class Litteris.Header : Gtk.HeaderBar {

	public Header () {
		Object (
			title: "Litteris",
			has_subtitle: false,
			show_close_button: true
		);
	}

	construct {
		var button_new = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        	//open_folder_button.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_OPEN_FOLDER;
			button_new.tooltip_text = "New Contact";

		var button_edit = new Gtk.Button.from_icon_name ("document-edit", Gtk.IconSize.LARGE_TOOLBAR);
			button_edit.tooltip_text = "Edit Contact";

		var button_del = new Gtk.Button.from_icon_name ("edit-delete", Gtk.IconSize.LARGE_TOOLBAR);
			button_del.tooltip_text = "Delete Contact";

		var button_find = new Gtk.ToggleButton ();
			button_find.image = new Gtk.Image.from_icon_name ("edit-find", Gtk.IconSize.LARGE_TOOLBAR);
			button_find.tooltip_text = "Find Contact";

		var appmenu = new Litteris.AppMenu ();
		var button_menu = new Gtk.MenuButton ();
			button_menu.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
			button_menu.popover = appmenu;
			button_menu.tooltip_text = "Menu";

		var field_search = new Gtk.SearchEntry ();

	        button_find.toggled.connect (() => {
				remove (button_find);
				this.pack_end (field_search);
				show_all ();
	        });

        pack_start (button_new);
		pack_start (button_edit);
		pack_start (button_del);
		pack_end (button_menu);
		pack_end (button_find);

		show_all ();
	}

}
