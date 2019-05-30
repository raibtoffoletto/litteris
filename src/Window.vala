public class Litteris.Window : Gtk.ApplicationWindow {
    public SimpleActionGroup actions { get; construct; }
    public const string ACTION_PREFIX = "win.";
    public const string ACTION_ABOUT_DIALOG = "about-dialog";
    public const string ACTION_IMPORT_DB = "import-db";
    public const string ACTION_EXPORT_DB = "export-db";
    public int win_w;
    public int win_h;
    public int pos_x;
    public int pos_y;

    private const ActionEntry[] action_entries = {
        { ACTION_ABOUT_DIALOG, about_dialog }
    };

	public Window (Gtk.Application app) {
		Object (
		    application: app,
    		height_request: 640,
            width_request: 860,
            border_width: 0,
            window_position: Gtk.WindowPosition.CENTER
		);
	}

    construct {
        actions = new SimpleActionGroup ();
        actions.add_action_entries (action_entries, this);
        insert_action_group ("win", actions);

        Application.settings.get ("window-position", "(ii)", out pos_x, out pos_y);
        Application.settings.get ("window-size", "(ii)", out win_w, out win_h);

        if (pos_x != -1 || pos_y != -1) {
            move (pos_x, pos_y);
        }

        resize (win_w, win_h);

        if (Application.settings.get_boolean ("window-maximized")) {
            maximize ();
        }

        var window_header = new Litteris.Header ();
        var window_panels = new Litteris.Panels ();

        set_titlebar (window_header);
        add (window_panels);
	 	show_all ();

        delete_event.connect (e => {
            return app_quit ();
        });

    }

    public bool app_quit () {

        get_size (out win_w, out win_h);
        get_position (out pos_x, out pos_y);

        Application.settings.set ("window-position", "(ii)",pos_x, pos_y);
        Application.settings.set ("window-size", "(ii)", win_w, win_h);
        Application.settings.set_boolean ("window-maximized", this.is_maximized);
        Application.settings.set_boolean ("dark-mode", Gtk.Settings.get_default ().gtk_application_prefer_dark_theme);

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
