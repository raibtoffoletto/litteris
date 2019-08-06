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

/* TO-DOs:
add database sync support (via nextcloud, dropbox folder)
*/

public class Litteris.Window : Gtk.ApplicationWindow {
    public weak Litteris.Application app { get; construct; }
    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();
    public SimpleActionGroup actions { get; construct; }
    public const string ACTION_PREFIX = "win.";
    public const string ACTION_NEW_PENPAL = "new-penpal";
    public const string ACTION_EDIT_PENPAL = "edit-penpal";
    public const string ACTION_DELETE_PENPAL = "delete-penpal";
    public const string ACTION_SEARCH = "search";
    public const string ACTION_OPEN_MENU = "open-menu";
    public const string ACTION_INVERT_THEME = "invert-theme";
    public const string ACTION_ABOUT_DIALOG = "about-dialog";
    public const string ACTION_APP_EXIT = "app-exit";
    public const string ACTION_IMPORT_DB = "import-db";
    public const string ACTION_EXPORT_DB = "export-db";
    private const ActionEntry[] action_entries = {
        { ACTION_NEW_PENPAL, new_penpal },
        { ACTION_EDIT_PENPAL, edit_penpal },
        { ACTION_DELETE_PENPAL, delete_penpal },
        { ACTION_SEARCH, toggle_search_bar },
        { ACTION_OPEN_MENU, open_menu_popover },
        { ACTION_INVERT_THEME, invert_color_mode },
        { ACTION_IMPORT_DB, import_db },
        { ACTION_EXPORT_DB, export_db },
        { ACTION_ABOUT_DIALOG, about_dialog },
        { ACTION_APP_EXIT, app_exit }
    };

    public bool active_penpal_view = false;
    public signal void show_mainwindow_notification (string message);
    public Granite.Widgets.Toast notifications { get; set; }
    public Litteris.PenpalList list_panel;
    private Litteris.Header window_header;
    private Gtk.Paned panels;
    private Gtk.Overlay overlay;
    private Litteris.Welcome welcome;
    private Litteris.PenpalView penpal_view;
    private int window_width;
    private int window_height;
    private int position_x;
    private int position_y;

    public Window (Litteris.Application app) {
        Object (
            application: app,
            app: app,
            height_request: 640,
            width_request: 880,
            border_width: 0,
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    static construct {
        action_accelerators.set (ACTION_NEW_PENPAL, "<Control>N");
        action_accelerators.set (ACTION_EDIT_PENPAL, "<Control>E");
        action_accelerators.set (ACTION_DELETE_PENPAL, "<Control>D");
        action_accelerators.set (ACTION_SEARCH, "<Control>F");
        action_accelerators.set (ACTION_OPEN_MENU, "<Control>O");
        action_accelerators.set (ACTION_INVERT_THEME, "<Control>M");
        action_accelerators.set (ACTION_ABOUT_DIALOG, "F1");
        action_accelerators.set (ACTION_IMPORT_DB, "<Control><Shift>I");
        action_accelerators.set (ACTION_EXPORT_DB, "<Control><Shift>E");
        action_accelerators.set (ACTION_APP_EXIT, "<Control>Q");
    }

    construct {
        actions = new SimpleActionGroup ();
        actions.add_action_entries (action_entries, this);
        insert_action_group ("win", actions);

        foreach (var action in action_accelerators.get_keys ()) {
            var accels_array = action_accelerators[action].to_array ();
            accels_array += null;
            app.set_accels_for_action (ACTION_PREFIX + action, accels_array);
        }

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
        welcome = new Litteris.Welcome (this);
        overlay = new Gtk.Overlay ();
        notifications = new Granite.Widgets.Toast ("");
        overlay.add_overlay (welcome);
        overlay.add_overlay (notifications);

        panels = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        panels.position = Application.settings.get_int ("panel-position");
        panels.pack1 (list_panel, false, false);
        panels.pack2 (overlay, true, false);

        set_titlebar (window_header);
        add (panels);
        show_all ();

        list_panel.notify["active-penpal"].connect (() => {
            load_penpal_view ();

            if (active_penpal_view) {
                window_header.title = "Litteris ~ " + list_panel.active_penpal;
            } else {
                window_header.title = "Litteris";
            }
        });

        key_press_event.connect (on_key_pressed);

        delete_event.connect (e => {
            return app_quit ();
        });

        show_mainwindow_notification.connect ((message) => {
            notifications.title = message;
            notifications.send_notification ();
        });
    }

    public void load_penpal_view () {
        if (active_penpal_view) {
            overlay.remove (penpal_view);
        } else {
            overlay.remove (welcome);
        }

        if (list_panel.active_penpal != null && list_panel.active_penpal != "") {
            active_penpal_view = true;
            penpal_view = new Litteris.PenpalView (this, list_panel.active_penpal);
            overlay.add_overlay (penpal_view);
        } else {
            active_penpal_view = false;
            welcome = new Litteris.Welcome (this);
            overlay.add_overlay (welcome);
        }

        overlay.reorder_overlay (notifications, -1);
        show_all ();
    }

    public void new_penpal () {
        var window_dialog = new Litteris.PenpalDialog (this);
            window_dialog.present ();
            window_dialog.response.connect ((id) => {
                if (id == Gtk.ResponseType.ACCEPT) {
                    if (window_dialog.entry_name.text != null && window_dialog.entry_name.text != "" &&
                        window_dialog.combo_country.active_id != null && window_dialog.combo_country.active_id != "") {

                        var new_name = window_dialog.entry_name.text[0].toupper ().to_string () +
                                    window_dialog.entry_name.text.slice (1, window_dialog.entry_name.text.length);

                        string query = """ INSERT INTO penpals
                                            (`name`, `nickname`, `notes`, `address`, `country`) VALUES
                                            ('""" + new_name + """',
                                             '""" + window_dialog.entry_nickname.text + """',
                                             '""" + window_dialog.entry_notes.buffer.text + """',
                                             '""" + window_dialog.entry_address.buffer.text + """',
                                             '""" + window_dialog.combo_country.active_id + """');""";

                        var exec_query = Application.database.exec_query (query);

                        if (exec_query) {
                            reload_penpal_list ();
                            show_mainwindow_notification (_("Penpal added with success!"));
                            window_dialog.destroy ();
                        } else {
                            show_mainwindow_notification (Utils.GENERIC_ERROR);
                        }

                    } else {
                        var dialog_incomplete_message = Markup.escape_text
                            (_("You should provide Name & Country for your new penpal."));

                        var dialog_incomplete = new Granite.MessageDialog.with_image_from_icon_name (
                                                    _("Incomplete data"),
                                                    dialog_incomplete_message,
                                                    "dialog-error",
                                                    Gtk.ButtonsType.CLOSE);
                            dialog_incomplete.transient_for = window_dialog;
                            dialog_incomplete.run ();
                            dialog_incomplete.destroy ();
                    }
                }
            });
    }

    public void edit_penpal () {
        if (list_panel.active_penpal != null && list_panel.active_penpal != "") {
            var window_dialog = new Litteris.PenpalDialog (this);
                window_dialog.get_penpal_to_edit (list_panel.active_penpal);
                window_dialog.present ();
                window_dialog.response.connect ((id) => {
                    if (id == Gtk.ResponseType.ACCEPT) {
                        penpal_view.edit_active_penpal (window_dialog.entry_name.text,
                                                        window_dialog.entry_nickname.text,
                                                        window_dialog.entry_notes.buffer.text,
                                                        window_dialog.entry_address.buffer.text,
                                                        window_dialog.combo_country.active_id);
                        window_dialog.destroy ();
                    }
                });
        }
    }

    public void delete_penpal () {
        if (list_panel.active_penpal != null && list_panel.active_penpal != "") {
            var penpal_to_remove = list_panel.active_penpal;
            var dialog_remove_penpal = new Granite.MessageDialog.with_image_from_icon_name (
                                        _("Remove %s ?").printf (penpal_to_remove),
                                        _("This action will permanently remove all data related to this penpal."),
                                        "user-trash-full",
                                        Gtk.ButtonsType.CANCEL);

            var remove_confirm = new Gtk.Button.with_label (_("Remove %s").printf (penpal_to_remove));
                remove_confirm.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

            dialog_remove_penpal.add_action_widget (remove_confirm, Gtk.ResponseType.ACCEPT);
            dialog_remove_penpal.transient_for = this;
            dialog_remove_penpal.show_all ();

            if (dialog_remove_penpal.run () == Gtk.ResponseType.ACCEPT) {
                penpal_view.remove_active_penpal ();
                show_mainwindow_notification (_("%s removed with success!").printf (penpal_to_remove));
            }

            dialog_remove_penpal.destroy ();
        }
    }

    public void import_db () {
        var confirm_import = new Granite.MessageDialog.with_image_from_icon_name (
                                    _("Restore backup?"),
                                    _("This will permanently override the current database."),
                                    "dialog-error",
                                    Gtk.ButtonsType.CANCEL);
        var button_import = new Gtk.Button.with_label (_("Restore"));
            button_import.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

        confirm_import.add_action_widget (button_import, Gtk.ResponseType.ACCEPT);
        confirm_import.transient_for = this;
        confirm_import.show_all ();

        if (confirm_import.run () == Gtk.ResponseType.ACCEPT) {
            var file_dialog = new Gtk.FileChooserNative (_("Restore backup file"),
                                                            this as Gtk.Window,
                                                            Gtk.FileChooserAction.OPEN,
                                                            _("Restore"), _("Cancel"));
            var file_filter = new Gtk.FileFilter ();
                file_filter.add_pattern ("*.db");
                file_filter.set_filter_name ("Sqlite DB");

            file_dialog.show_hidden = false;
            file_dialog.select_multiple = false;
            file_dialog.add_filter (file_filter);

            if (file_dialog.run () == Gtk.ResponseType.ACCEPT) {
                var file_name = file_dialog.get_filename ();
                if (Application.database.import_database (file_name)) {
                    app.reload_application ();
                } else {
                    show_mainwindow_notification (Utils.GENERIC_ERROR);
                }
            }

            file_dialog.destroy ();
        }

        confirm_import.destroy ();
    }

    public void export_db () {
        var file_dialog = new Gtk.FileChooserNative (_("Create backup file"),
                                                        this as Gtk.Window,
                                                        Gtk.FileChooserAction.SAVE,
                                                        _("Export"), _("Cancel"));
        var file_filter = new Gtk.FileFilter ();
            file_filter.add_pattern ("*.db");
            file_filter.set_filter_name ("Sqlite Database");

        var date_now = new DateTime.now_local ();

        file_dialog.do_overwrite_confirmation = true;
        file_dialog.show_hidden = false;
        file_dialog.set_current_name ("Litteris " + date_now.format ("%F") + ".db");
        file_dialog.add_filter (file_filter);

        if (file_dialog.run () == Gtk.ResponseType.ACCEPT) {
            var file_name = file_dialog.get_filename ();
            if (file_name.slice (-3, file_name.length) != ".db") {
                file_name += ".db";
            }

            if (Application.database.export_database (file_name)) {
                show_mainwindow_notification (_("Backup created with success!"));
            } else {
                show_mainwindow_notification (Utils.GENERIC_ERROR);
            }
        }

        file_dialog.destroy ();
    }

    public void about_dialog () {
        var about_dialog = new Gtk.AboutDialog ();
            about_dialog.transient_for = this;
            about_dialog.modal = true;
            about_dialog.program_name = "Litteris";
            about_dialog.comments = _("Penpal Correspondence Organized");
            about_dialog.copyright = "Copyright © 2019 Raí B. Toffoletto";
            about_dialog.license_type = Gtk.License.GPL_3_0;
            about_dialog.logo_icon_name = "dialog-information";
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

    public void toggle_search_bar () {
        if (list_panel.search_bar.get_search_mode ()) {
            list_panel.search_bar.search_mode_enabled = false;
            list_panel.source_list.grab_focus ();
        } else {
            list_panel.search_bar.search_mode_enabled = true;
            list_panel.search_entry.grab_focus ();
        }
    }

    public void reload_penpal_list () {
        list_panel.load_list ();
        list_panel.source_list.grab_focus ();
    }

    private bool on_key_pressed (Gdk.EventKey event) {
        var keyname = Gdk.keyval_name (event.keyval);
        string[] keys_to_escape = {"Escape", "Return", "KP_Enter"};

        if (keyname == "Escape" && active_penpal_view) {
            if (!list_panel.search_bar.get_search_mode () && !penpal_view.status_bar.edit_mode) {
                list_panel.set_property ("active-penpal", "");
                reload_penpal_list ();
                return true;
            }

            if (penpal_view.status_bar.edit_mode) {
                penpal_view.status_bar.set_property ("edit-mode", false);
                return true;
            }
        }

        if (list_panel.search_bar.get_search_mode ()) {
            if (keyname in keys_to_escape) {
                toggle_search_bar ();
                return true;
            }

            try {
                var key_regex = new Regex ("^\\p{L}$");
                if (!list_panel.search_entry.has_focus && key_regex.match (keyname)) {
                        list_panel.search_entry.text = "";
                        list_panel.search_entry.grab_focus ();
                }
            } catch (RegexError e) {
                print ("Error: %s\n", e.message);
            }
        }

        return list_panel.search_bar.handle_event (event);
    }

    public void open_menu_popover () {
        window_header.button_menu.activate ();
    }

    public void invert_color_mode () {
        var gtk_settings = Gtk.Settings.get_default ();
        var new_mode = gtk_settings.gtk_application_prefer_dark_theme ? false : true;

        window_header.app_menu.dark_mode.active = new_mode;
        gtk_settings.gtk_application_prefer_dark_theme = new_mode;
    }

    public void app_exit () {
        var exit = app_quit ();
        if (!exit) {
            destroy ();
        }
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

}
