public class Litteris.PenpalView : Gtk.ScrolledWindow {
    public PenpalView () {
        /* header */
        var penpal_name = new Gtk.Label ("<b> Meu Penpal Name </b>");
            penpal_name.halign = Gtk.Align.START;
            penpal_name.use_markup = true;
            penpal_name.margin_start = 12;
            penpal_name.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

        var penpal_nickname = new Gtk.Label ("(E o seu Nickname)");
            penpal_nickname.halign = Gtk.Align.START;
            penpal_nickname.margin_start = 20;
            penpal_nickname.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

        var penpal_names = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            penpal_names.halign = Gtk.Align.FILL;
            penpal_names.hexpand = true;
            penpal_names.pack_start (penpal_name);
            penpal_names.pack_start (penpal_nickname);

        var penpal_flag = new Gtk.Label ("🇧🇷️");
            penpal_flag.halign = Gtk.Align.END;
            penpal_flag.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);


        var icon_sent = new Gtk.Image.from_icon_name ("mail-send", Gtk.IconSize.LARGE_TOOLBAR);
            icon_sent.halign = Gtk.Align.END;
        var icon_sent_label = new Gtk.Label ("12");
            icon_sent_label.halign = Gtk.Align.START;
            icon_sent_label.get_style_context ().add_class (Granite.STYLE_CLASS_WELCOME);

        var icon_received = new Gtk.Image.from_icon_name ("mail-read", Gtk.IconSize.LARGE_TOOLBAR);
            icon_received.halign = Gtk.Align.END;
        var icon_received_label = new Gtk.Label ("15");
            icon_received_label.halign = Gtk.Align.START;
            icon_received_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

        var header_icons = new Gtk.Grid ();
            header_icons.hexpand = false;
            header_icons.height_request = 60;
            header_icons.width_request = 80;
            header_icons.column_homogeneous = true;
            header_icons.row_homogeneous = true;
            header_icons.row_spacing = 6;
            header_icons.column_spacing = 6;
            header_icons.attach (icon_sent, 0, 0);
            header_icons.attach (icon_sent_label, 1, 0);
            header_icons.attach (icon_received, 0, 1);
            header_icons.attach (icon_received_label, 1, 1);

        var header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            header.hexpand = true;
            header.homogeneous = false;
            header.halign = Gtk.Align.FILL;
            header.pack_start (header_icons, false, false);
            header.pack_start (penpal_names, true, true);
            header.pack_end (penpal_flag, false, false);

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
            main_grid.attach (header, 0, 0, 2, 1);
            main_grid.attach (separator, 0, 1, 2, 1);
            main_grid.attach (left_column, 0, 2);
            main_grid.attach (right_column, 1, 2);

        add (main_grid);
    }
}
