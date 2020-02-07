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

public class Litteris.PenpalStatusBar : Gtk.Box {
    public bool edit_mode { get; set; }
    public Litteris.PenpalView penpal_view { get; set; }
    public signal void statusbar_notification (string message);
    private Granite.Widgets.DatePicker new_mail_date;
    private Granite.Widgets.ModeButton new_mail_mailtype;
    private Granite.Widgets.ModeButton new_mail_direction;
    private Gtk.Button button_confirm;
    private Gtk.Button button_destroy;
    private Gtk.Button button_cancel;
    private Litteris.Utils utils;

    public PenpalStatusBar (Litteris.PenpalView penpal_view) {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 16,
            homogeneous: false,
            margin: 24,
            penpal_view: penpal_view
        );
    }

    construct {
        utils = new Litteris.Utils ();

        string status_bar_css = "* {font-size: 1.3em;}";
        var css_provider = new Gtk.CssProvider ();

        try {
            css_provider.load_from_data (status_bar_css);
        } catch (Error e) {
            stdout.printf ("Error: %s\n", e.message);
        }

        this.get_style_context ().add_provider (css_provider, 900);

        set_property ("edit-mode", false);
        load_status_bar ();

        notify["edit-mode"].connect (() => {
            if (!edit_mode) {
                load_status_bar ();
            }
        });
    }

    public void load_status_bar () {
        utils.remove_box_children (this);

        var button_new_date = new Gtk.Button.with_label (_("Register Mail"));
            button_new_date.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            button_new_date.clicked.connect (register_mail);

        pack_end (button_new_date, false, false);
        show_all ();

        if (edit_mode != false) {
            set_property ("edit-mode", false);
        }
    }

    private void register_mail () {
        utils.remove_box_children (this);
        load_edit_mode ();

        button_confirm.clicked.connect (() => {
            on_confirm_clicked ();
        });
    }

    public void edit_mail (Litteris.MailDate edit_date) {
        utils.remove_box_children (this);
        load_edit_mode (false);

        new_mail_date.date = new DateTime.from_unix_utc (edit_date.date);
        new_mail_mailtype.selected = edit_date.mail_type;
        new_mail_direction.selected = edit_date.direction;

        button_confirm.clicked.connect (() => {
            on_confirm_clicked (false, edit_date.rowid);
        });

        button_destroy.clicked.connect (() => {
            on_destroy_clicked (edit_date);
        });
    }

    private void load_edit_mode (bool new_mail = true) {
        set_property ("edit-mode", true);
        new_mail_date = new Granite.Widgets.DatePicker ();

        new_mail_mailtype = new Granite.Widgets.ModeButton ();
        new_mail_mailtype.append_icon ("emblem-mail", Gtk.IconSize.BUTTON);
        new_mail_mailtype.append_icon ("image-x-generic", Gtk.IconSize.BUTTON);

        new_mail_direction = new Granite.Widgets.ModeButton ();
        new_mail_direction.append_text (_("Received"));
        new_mail_direction.append_text (_("Sent"));

        button_confirm = new Gtk.Button ();
        button_confirm.label = new_mail ? _("Add Mail") : _("Save Changes");
        button_confirm.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        button_cancel = new Gtk.Button.with_label (_("Discard Changes"));
        button_cancel.clicked.connect (load_status_bar);

        button_destroy = new Gtk.Button.with_label (_("Remove Mail"));
        button_destroy.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

        var spacer = new Gtk.Grid ();
        var spacer_2 = new Gtk.Grid ();

        pack_start (spacer, true, true);
        pack_start (new_mail_mailtype, false, false);
        pack_start (new_mail_date, false, false);
        pack_start (new_mail_direction, false, false);
        pack_start (spacer_2, true, true);
        pack_end (button_confirm, false, false);

        if (!new_mail) {
            pack_end (button_destroy, false, false);
        }

        pack_end (button_cancel, false, false);
        show_all ();
    }

    private void on_confirm_clicked (bool new_mail = true, string rowid = "") {
        if (new_mail_mailtype.selected == -1 || new_mail_direction.selected == -1) {
            statusbar_notification (_("Please select Letter/Postcard and Received/Sent properly"));
        } else {
            string query = "";
            var insert_date = new_mail_date.date.to_unix ().to_string ();

            if (new_mail) {
                query = """INSERT INTO dates (date, penpal, type, direction)
                                VALUES ('"""+ insert_date +"""',
                                """+ penpal_view.loaded_penpal.rowid +""",
                                """+ new_mail_mailtype.selected.to_string () +""",
                                """+ new_mail_direction.selected.to_string () +""")""";
            } else {
                query = """UPDATE dates
                                SET date = '"""+ insert_date +"""',
                                penpal = """+ penpal_view.loaded_penpal.rowid +""",
                                type = """+ new_mail_mailtype.selected.to_string () +""",
                                direction = """+ new_mail_direction.selected.to_string () +"""
                                WHERE rowid = """+ rowid +""";""";
            }

            var exec_query = Application.database.exec_query (query);

            if (exec_query) {
                penpal_view.get_penpal ();
                statusbar_notification (new_mail ? _("Mail Registered") : _("Changes Saved"));
                load_status_bar ();
            } else {
                statusbar_notification (Utils.GENERIC_ERROR);
            }
        }
    }

    private void on_destroy_clicked (Litteris.MailDate edit_date) {
        var query = "DELETE FROM dates WHERE rowid = " + edit_date.rowid + ";";

        var delete_mail_mailtype = (edit_date.mail_type == Litteris.MailDate.MailType.LETTER) ?
                                    _("letter") : _("postcard");
        var delete_mail_date = new DateTime.from_unix_utc (edit_date.date).format ("%x");
        var dialog_title = _("Remove %s from %s?").printf (delete_mail_mailtype, delete_mail_date);

        var dialog = new Granite.MessageDialog.with_image_from_icon_name (
                                dialog_title,
                                _("This will delete this date from the database permanently!"),
                                "edit-delete",
                                Gtk.ButtonsType.CANCEL);

        var delete_confirm = new Gtk.Button.with_label (_("Remove Mail"));
            delete_confirm.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

        dialog.add_action_widget (delete_confirm, Gtk.ResponseType.ACCEPT);
        dialog.transient_for = penpal_view.main_window;
        dialog.show_all ();

        if (dialog.run () == Gtk.ResponseType.ACCEPT) {
            var exec_query = Application.database.exec_query (query);

            if (exec_query) {
                penpal_view.get_penpal ();
                statusbar_notification (_("Mail Removed"));
                load_status_bar ();
            } else {
                statusbar_notification (Utils.GENERIC_ERROR);
            }
        }

        dialog.destroy ();
    }

}
