public class Litteris.AppMenu : Gtk.Popover {

    public AppMenu () {
		Object (
			relative_to : null,
			modal : true
		);
	}

    construct {

        var gtk_settings = Gtk.Settings.get_default ();
        var dark_mode = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
            dark_mode.primary_icon_tooltip_text = ("Light Mode");
            dark_mode.secondary_icon_tooltip_text = ("Dark Mode");
            dark_mode.valign = Gtk.Align.CENTER;
            dark_mode.halign = Gtk.Align.CENTER;
            dark_mode.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");

        var menu_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_separator.margin = 6;

        var menu_about = new Gtk.MenuItem ();
            menu_about.label = "About";
            //menu_about.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_TOGGLE_SIDEBAR;

        var menu_grid = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            menu_grid.margin = 6;
            menu_grid.pack_start (dark_mode);
            menu_grid.pack_start (menu_separator);
            menu_grid.pack_start (menu_about);
            // menu_grid.attach (new_view_menuitem, 0, 4, 3, 1);
            // menu_grid.attach (remove_view_menuitem, 0, 5, 3, 1);
            // menu_grid.attach (preferences_menuitem, 0, 6, 3, 1);
            menu_grid.show_all ();

        add (menu_grid);

    }

		// var menu_item_preferences = new Gtk.MenuItem.with_label ("Preferences");
//          var menu_item_about = new Gtk.MenuItem.with_label ("About");
//          var menu_overlay = new Gtk.Menu ();
//          	menu_overlay.append (menu_item_preferences);
//          	menu_overlay.append (menu_item_about);
		// 	menu_overlay.show_all ();
		

}
