public class Litteris.PenpalView : Gtk.ScrolledWindow {
    public Litteris.Window main_window {get; construct;}

    public PenpalView (Litteris.Window main_window) {
        Object (
            main_window: main_window
        );
    }

    construct {
        var active_penpal = new Litteris.Penpal (main_window.list_panel.active_penpal);

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
            emoji_flag.halign = Gtk.Align.END;
            emoji_flag.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);


        var icon_sent = new Gtk.Image.from_icon_name ("mail-send", Gtk.IconSize.LARGE_TOOLBAR);
            icon_sent.halign = Gtk.Align.END;
        var icon_sent_label = new Gtk.Label (active_penpal.mail_sent.size.to_string ());
            icon_sent_label.halign = Gtk.Align.START;
            icon_sent_label.get_style_context ().add_class (Granite.STYLE_CLASS_WELCOME);

        var icon_received = new Gtk.Image.from_icon_name ("mail-read", Gtk.IconSize.LARGE_TOOLBAR);
            icon_received.halign = Gtk.Align.END;
        var icon_received_label = new Gtk.Label (active_penpal.mail_received.size.to_string ());
            icon_received_label.halign = Gtk.Align.START;
            icon_received_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

        var grid_icons = new Gtk.Grid ();
            grid_icons.hexpand = false;
            grid_icons.height_request = 60;
            grid_icons.width_request = 80;
            grid_icons.column_homogeneous = true;
            grid_icons.row_homogeneous = true;
            grid_icons.row_spacing = 6;
            grid_icons.column_spacing = 6;
            grid_icons.attach (icon_sent, 0, 0);
            grid_icons.attach (icon_sent_label, 1, 0);
            grid_icons.attach (icon_received, 0, 1);
            grid_icons.attach (icon_received_label, 1, 1);

        var header_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            header_box.hexpand = true;
            header_box.homogeneous = false;
            header_box.halign = Gtk.Align.FILL;
            header_box.pack_start (grid_icons, false, false);
            header_box.pack_start (box_names, true, true);
            header_box.pack_end (emoji_flag, false, false);

        /* left column */
        var notes_label = new Gtk.Label ("<b>Notes : </b>");
            notes_label.use_markup = true;
            notes_label.halign = Gtk.Align.START;
            notes_label.margin_bottom = 6;
        var notes_content = new Gtk.Label ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean neque ex, condimentum in arcu id, maximus congue lectus. Donec tempor convallis elementum. Etiam blandit sem elit, ac tincidunt massa convallis id. Phasellus ac rhoncus magna. Pellentesque ullamcorper eleifend luctus. Nunc a ex in sapien pellentesque commodo ut ut arcu. Duis ullamcorper viverra arcu at volutpat. Maecenas viverra aliquet lacinia. In tempor est sit amet dictum gravida. Nulla malesuada feugiat orci. Nullam quis neque in libero ullamcorper fermentum et eu mi. Donec leo est, interdum a facilisis vel, maximus viverra quam. Nulla non libero vel leo vestibulum scelerisque. Cras euismod consectetur turpis, vel suscipit neque consectetur eget.");
            notes_content.wrap = true;
            notes_content.justify = Gtk.Justification.FILL;

        var addresses_label = new Gtk.Label ("<b>Addresses : </b>");
            addresses_label.use_markup = true;
            addresses_label.halign = Gtk.Align.START;
            addresses_label.margin_top = 12;
            addresses_label.margin_bottom = 6;
        var addresses_content = new Gtk.Label ("Addresses : ");
            addresses_content.halign = Gtk.Align.START;

        var left_column = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            left_column.pack_start (notes_label, false, false);
            left_column.pack_start (notes_content, false, false);
            left_column.pack_start (addresses_label, false, false);
            left_column.pack_start (addresses_content);

        /* right column */
        var sent_label = new Gtk.Label ("<b>Sent</b>");
            sent_label.use_markup = true;
            sent_label.halign = Gtk.Align.END;
            sent_label.margin_bottom = 6;

        var sent_dates = new Gtk.Expander.with_mnemonic ("2009");
        var sent_dates_content = new Gtk.Label ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean neque ex, condimentum in arcu id, maximus congue lectus. Donec tempor convallis elementum. Etiam blandit sem elit, ac tincidunt massa convallis id. Phasellus ac rhoncus magna. Pellentesque ullamcorper eleifend luctus. Nunc a ex in sapien pellentesque commodo ut ut arcu. Duis ullamcorper viverra arcu at volutpat. Maecenas viverra aliquet lacinia. In tempor est sit amet dictum gravida. Nulla malesuada feugiat orci. Nullam quis neque in libero ullamcorper fermentum et eu mi. Donec leo est, interdum a facilisis vel, maximus viverra quam. Nulla non libero vel leo vestibulum scelerisque. Cras euismod consectetur turpis, vel suscipit neque consectetur eget.");
            sent_dates_content.wrap = true;
            sent_dates.add (sent_dates_content);

        var received_dates = new Gtk.Expander.with_mnemonic ("2019");
        var received_dates_content = new Gtk.Label ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean neque ex, condimentum in arcu id, maximus congue lectus. Donec tempor convallis elementum. Etiam blandit sem elit, ac tincidunt massa convallis id. Phasellus ac rhoncus magna. Pellentesque ullamcorper eleifend luctus. Nunc a ex in sapien pellentesque commodo ut ut arcu. Duis ullamcorper viverra arcu at volutpat. Maecenas viverra aliquet lacinia. In tempor est sit amet dictum gravida. Nulla malesuada feugiat orci. Nullam quis neque in libero ullamcorper fermentum et eu mi. Donec leo est, interdum a facilisis vel, maximus viverra quam. Nulla non libero vel leo vestibulum scelerisque. Cras euismod consectetur turpis, vel suscipit neque consectetur eget.");
            received_dates_content.wrap = true;
            received_dates.add (received_dates_content);

        var received_label = new Gtk.Label ("<b>Received</b>");
            received_label.use_markup = true;
            received_label.halign = Gtk.Align.END;
            received_label.margin_top = 12;
            received_label.margin_bottom = 6;

        var right_column = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            right_column.pack_start (sent_label, false, false);
            right_column.pack_start (sent_dates, false, false);
            right_column.pack_start (received_label, false, false);
            right_column.pack_start (received_dates, false, false);

        var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

        var main_grid = new Gtk.Grid ();
            main_grid.margin = 24;
            main_grid.row_spacing = 12;
            main_grid.column_spacing = 24;
            main_grid.row_homogeneous = false;
            main_grid.column_homogeneous = true;
            main_grid.attach (header_box, 0, 0, 2, 1);
            main_grid.attach (separator, 0, 1, 2, 1);
            // main_grid.attach (left_column, 0, 2);
            // main_grid.attach (right_column, 1, 2);

        add (main_grid);
    }
}
