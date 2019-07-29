/*
* Copyright (c) 2019 Raí B. Toffoletto (https://toffoletto.me)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Raí B. Toffoletto <rai@toffoletto.me>
*/

public class Litteris.Window : Gtk.ApplicationWindow {
    // public SimpleActionGroup actions { get; construct; }
    // public const string ACTION_PREFIX = "win.";
    // public const string ACTION_ABOUT_DIALOG = "about-dialog";
    // public const string ACTION_IMPORT_DB = "import-db";
    // public const string ACTION_EXPORT_DB = "export-db";
    private Litteris.Header window_header;
    private Litteris.PenpalList list_panel;
    private Litteris.PenpalView penpal_view;
    private Litteris.Welcome welcome_panel;
    private Gtk.Paned panels;
    private int window_width;
    private int window_height;
    private int position_x;
    private int position_y;

    // private const ActionEntry[] action_entries = {
    //     { ACTION_ABOUT_DIALOG, about_dialog }
    // };

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
        // actions = new SimpleActionGroup ();
        // actions.add_action_entries (action_entries, this);
        // insert_action_group ("win", actions);

        Application.settings.get ("window-position", "(ii)", out position_x, out position_y);
        Application.settings.get ("window-size", "(ii)", out window_width, out window_height);

        if (position_x != -1 || position_y != -1) {
            move (position_x, position_y);
        }

        resize (window_width, window_height);

        if (Application.settings.get_boolean ("window-maximized")) {
            maximize ();
        }

        window_header = new Litteris.Header ();
        list_panel = new Litteris.PenpalList ();
        welcome_panel = new Litteris.Welcome ();

        panels = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        panels.position = Application.settings.get_int ("panel-position");
        panels.pack1 (list_panel, false, false);
        panels.pack2 (welcome_panel, true, false);

        set_titlebar (window_header);
        add (panels);
	 	show_all ();

        list_panel.notify["active-penpal"].connect (() => {
            if (list_panel.active_penpal != "") {
                window_header.title = "Litteris ~ " + list_panel.active_penpal;
            } else {
                window_header.title = "Litteris";
            }
            load_penpal_view ();
        });

        key_press_event.connect (on_key_pressed);

        delete_event.connect (e => {
            return app_quit ();
        });
    }

    public void load_penpal_view () {
        panels.remove (panels.get_child2 ());

        if (list_panel.active_penpal != null && list_panel.active_penpal != "") {
            penpal_view = new Litteris.PenpalView (this, list_panel.active_penpal);
            panels.pack2 (penpal_view, true, false);
        } else {
            panels.pack2 (welcome_panel, true, false);
        }

        show_all ();
    }

    private bool on_key_pressed (Gdk.EventKey event) {
        var keyname = Gdk.keyval_name (event.keyval);
        string[] keys_escape = {"Escape", "Return", "KP_Enter"};

        if ((keyname in keys_escape) && list_panel.search_bar.get_search_mode ()) {
            list_panel.search_bar.search_mode_enabled = false;
            list_panel.source_list.grab_focus ();
        }

        if (keyname == "Escape" && penpal_view.status_bar.edit_mode == true) {
            penpal_view.status_bar.set_property ("edit-mode", false);
        }

        try {
            var key_regex = new Regex ("^[a-zA-Z]$", RegexCompileFlags.JAVASCRIPT_COMPAT);
            if (list_panel.search_bar.get_search_mode ()
                && !list_panel.search_entry.has_focus
                && key_regex.match (keyname)) {
                    list_panel.search_entry.text = "";
                    list_panel.search_entry.grab_focus ();
            }
        } catch (RegexError e) {
            print ("Error: %s\n", e.message);
        }

        return list_panel.search_bar.handle_event (event);
    }

    public void edit_penpal_dialog () {
        // var dialog = new Gtk.Dialog.with_buttons ("Edit penpal", this, Gtk.DialogFlags.MODAL
    }

    public void about_dialog () {
        var about_dialog = new Gtk.AboutDialog ();
            about_dialog.transient_for = this;
            about_dialog.modal = true;
            about_dialog.program_name = "Litteris";
            about_dialog.comments = _("Penpal Correspondence Organized");
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

    public bool app_quit () {
        get_size (out window_width, out window_height);
        get_position (out position_x, out position_y);

        Application.settings.set ("window-position", "(ii)",position_x, position_y);
        Application.settings.set ("window-size", "(ii)", window_width, window_height);
        Application.settings.set_boolean ("window-maximized", this.is_maximized);
        Application.settings.set_boolean ("dark-mode", Gtk.Settings.get_default ().gtk_application_prefer_dark_theme);
        Application.settings.set_int ("panel-position", panels.get_position ());

        return false;
    }

    public void reload_penpal_list () {
        list_panel.load_list ();
    }
}
