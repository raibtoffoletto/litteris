public class Litteris.Window : Gtk.ApplicationWindow {

    public GLib.Settings settings;
    public SimpleActionGroup actions { get; construct; }

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_ABOUT_DIALOG = "about-dialog";
    public const string ACTION_IMPORT_DB = "import-db";
    public const string ACTION_EXPORT_DB = "export-db";

    private const ActionEntry[] action_entries = {
        { ACTION_ABOUT_DIALOG, about_dialog }
    };

	public Window (Gtk.Application app) {
		Object (
		    application: app,
    		height_request: 640,
            width_request: 980,
            border_width: 0,
            window_position: Gtk.WindowPosition.CENTER
		);
	}

    construct {
        settings = new GLib.Settings ("com.github.raibtoffoletto.litteris");

        actions = new SimpleActionGroup ();
        actions.add_action_entries (action_entries, this);
        insert_action_group ("win", actions);

        var window_header = new Litteris.Header ();
        var window_panels = new Litteris.Panels ();

        set_titlebar (window_header);
        add (window_panels);

        //Centres the window in first use
        if (!(settings.get_int ("pos-x") == 190 && settings.get_int ("pos-y") == 140)) {
            move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));
        }
        //Loads user settings
        resize (settings.get_int ("win-w"), settings.get_int ("win-h"));

        //Saves user settings
        delete_event.connect (e => {
            return app_quit ();
        });

	 	show_all ();
    }

    public bool app_quit () {
        int win_w, win_h, pos_x, pos_y;

        get_size (out win_w, out win_h);
        get_position (out pos_x, out pos_y);

        settings.set_int ("win-w", win_w);
        settings.set_int ("win-h", win_h);
        settings.set_int ("pos-x", pos_x);
        settings.set_int ("pos-y", pos_y);
        settings.set_boolean ("dark-mode", Gtk.Settings.get_default ().gtk_application_prefer_dark_theme);

        return false;
    }

    public void about_dialog () {
        var about_dialog = new Gtk.AboutDialog ();
            about_dialog.set_transient_for (this);
            about_dialog.set_modal (true);
            about_dialog.program_name = "Litteris";
            about_dialog.comments = "Penpal Correspondence Organized";
            about_dialog.copyright = "Copyright © 2019 Raí B. Toffoletto";
            about_dialog.license_type = Gtk.License.GPL_3_0;
            about_dialog.logo = null;
            about_dialog.version = "0.1";
            about_dialog.website = "https://github.com/raibtoffoletto/litteris";
            about_dialog.website_label = "github.com/raibtoffoletto/litteris";
            about_dialog.response.connect ((response_id) => {
		        if (response_id == Gtk.ResponseType.CANCEL || response_id == Gtk.ResponseType.DELETE_EVENT) {
			        about_dialog.hide_on_delete ();
		        }
	        });
            about_dialog.present ();
    }

}
