public class Litteris.PenpalView : Gtk.ScrolledWindow {
    public Litteris.Window main_window {get; construct;}

    public PenpalView (Litteris.Window main_window) {
        Object (
            main_window: main_window
        );
    }

    construct {
        Litteris.Penpal active_penpal = new Litteris.Penpal (main_window.list_panel.active_penpal);

        /* header */
        var label_name = new Gtk.Label ("<b>"+active_penpal.name+"</b>");
            label_name.halign = Gtk.Align.START;
            label_name.use_markup = true;
            label_name.margin_start = 12;
            label_name.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

        var label_nickname = new Gtk.Label (active_penpal.nickname);
            label_nickname.halign = Gtk.Align.START;
            label_nickname.margin_start = 20;
            label_nickname.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

        var box_names = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box_names.halign = Gtk.Align.FILL;
            box_names.hexpand = true;
            box_names.pack_start (label_name);
            box_names.pack_start (label_nickname);

        var emoji_flag = new Gtk.Label (active_penpal.country_emoji);
            emoji_flag.valign = Gtk.Align.START;
            emoji_flag.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

        var icon_sent = new Gtk.Image.from_icon_name ("mail-send", Gtk.IconSize.LARGE_TOOLBAR);
            icon_sent.halign = Gtk.Align.START;

        var icon_sent_label = new Gtk.Label (active_penpal.mail_sent.size.to_string ());
            icon_sent_label.halign = Gtk.Align.END;
            icon_sent_label.get_style_context ().add_class (Granite.STYLE_CLASS_WELCOME);

        var icon_received = new Gtk.Image.from_icon_name ("mail-read", Gtk.IconSize.LARGE_TOOLBAR);
            icon_received.halign = Gtk.Align.START;

        var icon_received_label = new Gtk.Label (active_penpal.mail_received.size.to_string ());
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
            header_box.homogeneous = false;
            header_box.halign = Gtk.Align.FILL;
            header_box.pack_start (emoji_flag, false, false);
            header_box.pack_start (box_names, true, true);
            header_box.pack_end (grid_icons, false, false);

        /* penpal info */
        var label_notes = new Gtk.Label ("<b>Notes : </b>");
            label_notes.use_markup = true;
            label_notes.halign = Gtk.Align.START;

        var label_notes_content = new Gtk.Label (active_penpal.notes);
            label_notes_content.wrap = true;
            label_notes_content.halign = Gtk.Align.START;
            label_notes_content.valign = Gtk.Align.START;
            label_notes_content.justify = Gtk.Justification.FILL;
            label_notes_content.margin_start = 16;
            label_notes_content.selectable = true;

        var label_address = new Gtk.Label ("<b>Address : </b>");
            label_address.use_markup = true;
            label_address.halign = Gtk.Align.START;

        var label_address_content = new Gtk.Label (active_penpal.address);
            label_address_content.label += "\n\n%s\n".printf (active_penpal.country_name);
            label_address_content.wrap = true;
            label_address_content.halign = Gtk.Align.START;
            label_address_content.valign = Gtk.Align.START;
            label_address_content.justify = Gtk.Justification.FILL;
            label_address_content.margin_start = 16;
            label_address_content.selectable = true;

        var icon_mail_sent = new Gtk.Image.from_icon_name ("mail-send", Gtk.IconSize.LARGE_TOOLBAR);
        var label_sent = new Gtk.Label ("<b>Mail Sent :</b>");
            label_sent.use_markup = true;
            label_sent.halign = Gtk.Align.START;

        var box_sent = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            box_sent.pack_start (icon_mail_sent, false, false);
            box_sent.pack_start (label_sent, false, false);

        var icon_mail_received = new Gtk.Image.from_icon_name ("mail-read", Gtk.IconSize.LARGE_TOOLBAR);
        var label_received = new Gtk.Label ("<b>Mail Received :</b>");
            label_received.use_markup = true;
            label_received.halign = Gtk.Align.START;

        var box_received = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            box_received.pack_start (icon_mail_received, false, false);
            box_received.pack_start (label_received, false, false);

// foreach (var x in active_penpal.mail_sent_years) {
//     stdout.printf ("sent: %s\n", x);
// }
// foreach (var x in active_penpal.mail_received_years) {
//     stdout.printf ("received: %s\n", x);
// }

        var content_grid = new Gtk.Grid ();
            content_grid.column_spacing = 24;
            content_grid.column_homogeneous = true;
            content_grid.row_spacing = 6;
            content_grid.row_homogeneous = false;
            content_grid.attach (label_address, 0, 0);
            content_grid.attach (label_address_content, 0, 1);
            content_grid.attach (label_notes, 1, 0);
            content_grid.attach (label_notes_content, 1, 1);
            content_grid.attach (box_sent, 0, 2);
            content_grid.attach (box_received, 1, 2);

        var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL,12);
            main_box.margin = 24;
            main_box.pack_start (header_box, false, false);
            main_box.pack_start (separator, false, false);
            main_box.pack_start (content_grid, false, false);

        add (main_box);
    }

}
