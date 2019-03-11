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

            var settings = new GLib.Settings ("com.github.raibtoffoletto.litteris");
            if (settings.get_boolean ("dark-mode")) {
                dark_mode.active = true;
            }

        var menu_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_separator.margin = 6;
        var menu_separator2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_separator2.margin = 6;

        var menu_import = new Gtk.ModelButton ();
            menu_import.centered = true;
            menu_import.text = "Import";

        var menu_export = new Gtk.ModelButton ();
            menu_export.centered = true;
            menu_export.text = "Export";

        var menu_about = new Gtk.ModelButton ();
            menu_about.centered = true;
            menu_about.text = "About";
            menu_about.action_name = "win.about-action";

        var menu_grid = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            menu_grid.margin = 6;
            menu_grid.pack_start (dark_mode);
            menu_grid.pack_start (menu_separator);
            menu_grid.pack_start (menu_import);
            menu_grid.pack_start (menu_export);
            menu_grid.pack_start (menu_separator2);
            menu_grid.pack_start (menu_about);
            menu_grid.show_all ();

        add (menu_grid);

    }

}
