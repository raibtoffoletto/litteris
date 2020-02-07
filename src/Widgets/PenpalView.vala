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

public class Litteris.PenpalView : Gtk.Grid {
    public string active_penpal { get; construct; }
    public Litteris.Window main_window { get; set; }
    public Litteris.Penpal loaded_penpal { get; set; }
    public Litteris.PenpalStatusBar status_bar;
    private Gtk.Label label_name;
    private Gtk.Label label_nickname;
    private Gtk.Label emoji_flag;
    private Gtk.Label icon_sent_label;
    private Gtk.Label icon_received_label;
    private Gtk.Label label_notes_content;
    private Gtk.Label label_address_content;
    private Gtk.Box box_sent;
    private Gtk.Box box_received;
    private Gtk.Box box_name_starred;
    private Litteris.Utils utils;
    private Gtk.Button icon_starred;

    public PenpalView (Litteris.Window window, string active_penpal) {
        Object (
            width_request: 580,
            main_window: window,
            active_penpal: active_penpal
        );
    }

    construct {
        utils = new Litteris.Utils ();

        string status_bar_css = "* {font-size: 1.15em;}";
        var css_provider = new Gtk.CssProvider ();

        try {
            css_provider.load_from_data (status_bar_css);
        } catch (Error e) {
            stdout.printf ("Error: %s\n", e.message);
        }

        this.get_style_context ().add_provider (css_provider, 900);

        /* header */
        label_name = new Gtk.Label ("");
        label_name.halign = Gtk.Align.START;
        label_name.use_markup = true;
        label_name.margin_start = 12;
        label_name.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

        box_name_starred = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        box_name_starred.pack_start (label_name, false, false);

        label_nickname = new Gtk.Label ("");
        label_nickname.halign = Gtk.Align.START;
        label_nickname.margin_start = 20;
        label_nickname.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

        var box_names = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box_names.halign = Gtk.Align.FILL;
            box_names.hexpand = true;
            box_names.pack_start (box_name_starred);
            box_names.pack_start (label_nickname);

        emoji_flag = new Gtk.Label ("");
        emoji_flag.valign = Gtk.Align.START;
        emoji_flag.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

        var icon_sent = new Gtk.Image.from_icon_name ("mail-send", Gtk.IconSize.LARGE_TOOLBAR);
            icon_sent.halign = Gtk.Align.START;

        icon_sent_label = new Gtk.Label ("");
        icon_sent_label.halign = Gtk.Align.END;
        icon_sent_label.get_style_context ().add_class (Granite.STYLE_CLASS_WELCOME);

        var icon_received = new Gtk.Image.from_icon_name ("mail-read", Gtk.IconSize.LARGE_TOOLBAR);
            icon_received.halign = Gtk.Align.START;

        icon_received_label = new Gtk.Label ("");
        icon_received_label.halign = Gtk.Align.END;
        icon_received_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

        var grid_icons = new Gtk.Grid ();
            grid_icons.hexpand = false;
            grid_icons.height_request = 60;
            grid_icons.width_request = 80;
            grid_icons.column_homogeneous = true;
            grid_icons.row_homogeneous = true;
            grid_icons.row_spacing = 6;
            grid_icons.column_spacing = 6;
            grid_icons.attach (icon_sent_label, 0, 0);
            grid_icons.attach (icon_sent, 1, 0);
            grid_icons.attach (icon_received_label, 0, 1);
            grid_icons.attach (icon_received, 1, 1);

        var header_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            header_box.hexpand = true;
            header_box.margin = 12;
            header_box.homogeneous = false;
            header_box.halign = Gtk.Align.FILL;
            header_box.pack_start (emoji_flag, false, false);
            header_box.pack_start (box_names, true, true);
            header_box.pack_end (grid_icons, false, false);

        /* penpal info */
        var label_notes = new Gtk.Label ("<b>" + _("Notes :") + " </b>");
            label_notes.use_markup = true;
            label_notes.halign = Gtk.Align.START;

        label_notes_content = new Gtk.Label ("");
        label_notes_content.wrap = true;
        label_notes_content.halign = Gtk.Align.START;
        label_notes_content.valign = Gtk.Align.START;
        label_notes_content.justify = Gtk.Justification.FILL;
        label_notes_content.margin_start = 12;
        label_notes_content.margin_end = 24;
        label_notes_content.selectable = true;
        label_notes_content.can_focus = false;

        var label_address = new Gtk.Label ("<b>" + _("Address :") + " </b>");
            label_address.use_markup = true;
            label_address.halign = Gtk.Align.START;

        label_address_content = new Gtk.Label ("");
        label_address_content.wrap = true;
        label_address_content.halign = Gtk.Align.START;
        label_address_content.valign = Gtk.Align.START;
        label_address_content.justify = Gtk.Justification.FILL;
        label_address_content.margin_start = 12;
        label_address_content.margin_end = 24;
        label_address_content.selectable = true;
        label_address_content.can_focus = false;
        label_address_content.use_markup = true;

        var label_sent = new Gtk.Label ("<b>" + _("Sent :") + " </b>");
            label_sent.use_markup = true;
            label_sent.halign = Gtk.Align.START;

        var label_received = new Gtk.Label ("<b>" + _("Received :") + " </b>");
            label_received.use_markup = true;
            label_received.halign = Gtk.Align.START;

        box_sent = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        box_sent.homogeneous = false;
        box_sent.margin_start = 12;
        box_received = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        box_received.homogeneous = false;
        box_received.margin_start = 12;

        var content_grid = new Gtk.Grid ();
            content_grid.column_spacing = 24;
            content_grid.column_homogeneous = true;
            content_grid.row_spacing = 6;
            content_grid.margin = 24;
            content_grid.row_homogeneous = false;
            content_grid.attach (label_address, 0, 0);
            content_grid.attach (label_address_content, 0, 1);
            content_grid.attach (label_notes, 1, 0);
            content_grid.attach (label_notes_content, 1, 1);
            content_grid.attach (label_sent, 0, 2);
            content_grid.attach (box_sent, 0, 3);
            content_grid.attach (label_received, 1, 2);
            content_grid.attach (box_received, 1, 3);

        var content_scrolled = new Gtk.ScrolledWindow (null, null);
            content_scrolled.expand = true;
            content_scrolled.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            content_scrolled.add (content_grid);

        /* penpal view constructor */
        status_bar = new Litteris.PenpalStatusBar (this);

        get_penpal ();

        var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        var separator_2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

        attach (header_box, 0, 0);
        attach (separator, 0, 1);
        attach (content_scrolled, 0, 2);
        attach (separator_2, 0, 3);
        attach (status_bar, 0, 4);

        status_bar.statusbar_notification.connect ((message) => {
            main_window.show_mainwindow_notification (message);
        });
    }

    public void get_penpal () {
        var new_loaded_penpal = new Litteris.Penpal (active_penpal);
        set_property ("loaded-penpal", new_loaded_penpal);

        label_name.label = "<b>" + Markup.escape_text (loaded_penpal.name) + "</b>";
        label_nickname.label = loaded_penpal.nickname;
        emoji_flag.label = loaded_penpal.country_emoji;
        icon_sent_label.label = loaded_penpal.mail_sent.size.to_string ();
        icon_received_label.label = loaded_penpal.mail_received.size.to_string ();
        label_notes_content.label = loaded_penpal.notes;
        label_address_content.label = "%s\n<b>%s</b>\n".printf (Markup.escape_text (loaded_penpal.address),
                                                                loaded_penpal.country_name);

        get_starred ();
        get_all_dates ();
    }

    private void get_dates (bool sent = true) {
        var dates_list = sent ? loaded_penpal.mail_sent : loaded_penpal.mail_received;
        var dates_years = sent ? loaded_penpal.mail_sent_years : loaded_penpal.mail_received_years;
        var dates_box = sent ? box_sent : box_received;
        utils.remove_box_children (dates_box);
        int count = 0;

        foreach (var year in dates_years) {
            var label_year = new Gtk.Expander ("<b>%i</b>".printf (year));
                if (count == 0) {
                    label_year.expanded = true;
                } else {
                    label_year.expanded = false;
                }
                count++;
                label_year.use_markup = true;
                label_year.margin = 3;

            var flowbox_year = new Gtk.FlowBox ();
                flowbox_year.homogeneous = true;
                flowbox_year.row_spacing = 3;

            label_year.add (flowbox_year);
            foreach (var mail_date in dates_list) {
                var date = new DateTime.from_unix_utc (mail_date.date);

                if (date.get_year () == year) {
                    var button_date = new Gtk.Button ();
                        button_date.label = date.format ("%x");
                        button_date.relief = Gtk.ReliefStyle.NONE;
                        button_date.halign = Gtk.Align.START;
                        button_date.can_focus = false;
                        button_date.always_show_image = true;
                        button_date.image_position = Gtk.PositionType.LEFT;

                    var button_date_icon = new Gtk.Image.from_icon_name
                                           ("emblem-mail", Gtk.IconSize.SMALL_TOOLBAR);

                    if (mail_date.mail_type == Litteris.MailDate.MailType.POSTCARD) {
                        button_date_icon = new Gtk.Image.from_icon_name
                                           ("image-x-generic", Gtk.IconSize.SMALL_TOOLBAR);
                    }
                    button_date.set_image (button_date_icon);

                    button_date.clicked.connect (() => {
                        status_bar.edit_mail (mail_date);
                    });

                    button_date.focus_out_event.connect (() => {
                        status_bar.load_status_bar ();
                        return true;
                    });

                    flowbox_year.add (button_date);
                }
            }

            dates_box.pack_start (label_year, false, false);
            dates_box.show_all ();
        }
    }

    public void get_all_dates () {
        get_dates (true);
        get_dates (false);
    }

    private void get_starred () {
        if (icon_starred != null) {
            box_name_starred.remove (icon_starred);
        }

        if (loaded_penpal.starred) {
            icon_starred = new Gtk.Button.from_icon_name ("starred", Gtk.IconSize.LARGE_TOOLBAR);
        } else {
            icon_starred = new Gtk.Button.from_icon_name ("non-starred", Gtk.IconSize.LARGE_TOOLBAR);
        }

        icon_starred.relief = Gtk.ReliefStyle.NONE;
        icon_starred.can_focus = false;
        icon_starred.clicked.connect (on_starred_clicked);

        box_name_starred.pack_start (icon_starred, false, false);
        box_name_starred.show_all ();
    }

    private void on_starred_clicked () {
        string query = "";
        var set_unset_starred = loaded_penpal.starred ? false : true;

        if (set_unset_starred) {
            query = "INSERT INTO starred (penpal) VALUES (" + loaded_penpal.rowid + ");";
        } else {
            query = "DELETE FROM starred WHERE penpal = " + loaded_penpal.rowid + ";";
        }

        var exec_query = Application.database.exec_query (query);

        if (exec_query) {
            loaded_penpal.set_property ("starred", set_unset_starred);
            get_starred ();
            main_window.reload_penpal_list ();
        } else {
            main_window.show_mainwindow_notification (Utils.GENERIC_ERROR);
        }
    }

    public void edit_active_penpal (string name, string nickname,
                                    string notes, string address, string country) {

        string query = """UPDATE penpals
                            SET `name` = '""" + name + """',
                                `nickname` = '""" + nickname + """',
                                `notes` = '""" + notes + """',
                                `address` = '""" + address + """',
                                `country` = '""" + country + """'
                            WHERE rowid = """ + loaded_penpal.rowid + """;""";

        var exec_query = Application.database.exec_query (query);

        if (exec_query) {
            main_window.list_panel.set_property ("active-penpal", name);
            main_window.reload_penpal_list ();
            main_window.show_mainwindow_notification (_("Penpal updated with success!"));
        } else {
            main_window.show_mainwindow_notification (Utils.GENERIC_ERROR);
        }
    }

    public void remove_active_penpal () {
        string query = """DELETE FROM starred WHERE penpal = """ + loaded_penpal.rowid + """;
                            DELETE FROM dates WHERE penpal = """ + loaded_penpal.rowid + """;
                            DELETE FROM penpals WHERE rowid = """ + loaded_penpal.rowid + """;""";

        var exec_query = Application.database.exec_query (query);

        if (exec_query) {
            main_window.list_panel.set_property ("active-penpal", "");
            main_window.reload_penpal_list ();
        } else {
            main_window.show_mainwindow_notification (Utils.GENERIC_ERROR);
        }
    }
}
