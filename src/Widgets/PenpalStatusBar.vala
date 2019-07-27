public class Litteris.PenpalStatusBar : Gtk.Box {
    public Litteris.PenpalView penpal_view {get; set;}
    private Granite.Widgets.DatePicker new_mail_date;
    private Granite.Widgets.ModeButton new_mail_mailtype;
    private Granite.Widgets.ModeButton new_mail_direction;
    private Gtk.Button button_confirm;
    private Gtk.Button button_cancel;
    private Litteris.Utils utils;

    public PenpalStatusBar (Litteris.PenpalView penpal_view) {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 8,
            homogeneous: false,
            margin: 8,
            penpal_view: penpal_view
        );
    }

    construct {
        utils = new Litteris.Utils ();
        load_status_bar ();
    }

    private void load_status_bar () {
        utils.remove_box_children (this);

        var button_new_date = new Gtk.Button.with_label ("Register Mail");
            button_new_date.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            button_new_date.clicked.connect (register_mail);

        pack_end (button_new_date, false, false);

        show_all ();
    }

    private void register_mail () {
        utils.remove_box_children (this);
        load_edit_mode ();

        button_confirm.clicked.connect (() => {
            if (new_mail_mailtype.selected == -1 || new_mail_direction.selected == -1) {
                penpal_view.notifications.title = "Please select Letter/Postcard and Received/Sent";
                penpal_view.notifications.send_notification ();
            } else {
                var insert_date = new_mail_date.date.to_unix ().to_string ();
                string query = """INSERT INTO dates (date, penpal, type, direction)
                                VALUES ('"""+ insert_date +"""',
                                        """+ penpal_view.loaded_penpal.rowid +""",
                                        """+ new_mail_mailtype.selected.to_string () +""",
                                        """+ new_mail_direction.selected.to_string () +""")""";
                var exec_query = Application.database.exec_query (query);
                if (exec_query) {
                    penpal_view.loaded_penpal.load_dates ();
                    penpal_view.load_dates ((new_mail_direction.selected == 0) ? false : true);
                    penpal_view.notifications.title = "Mail registered";
                    penpal_view.notifications.send_notification ();
                    load_status_bar ();
                }
            }
        });
    }

    // public void edit_mail () {
    //     remove_widgets ();
    // }

    private void load_edit_mode (bool new_mail = true) {
        new_mail_date = new Granite.Widgets.DatePicker ();

        new_mail_mailtype = new Granite.Widgets.ModeButton ();
        new_mail_mailtype.append_icon ("emblem-mail", Gtk.IconSize.BUTTON);
        new_mail_mailtype.append_icon ("image-x-generic", Gtk.IconSize.BUTTON);

        new_mail_direction = new Granite.Widgets.ModeButton ();
        new_mail_direction.append_text ("Received");
        new_mail_direction.append_text ("Sent");

        button_confirm = new Gtk.Button ();
        button_confirm.label = new_mail ? "Add Mail" : "Save Changes";
        button_confirm.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        button_cancel = new Gtk.Button.with_label ("Cancel");
        button_cancel.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        button_cancel.clicked.connect (load_status_bar);

        var spacer = new Gtk.Grid ();
        var spacer_2 = new Gtk.Grid ();

        pack_start (spacer, true, true);
        pack_start (new_mail_mailtype, false, false);
        pack_start (new_mail_date, false, false);
        pack_start (new_mail_direction, false, false);
        pack_start (spacer_2, true, true);
        pack_end (button_confirm, false, false);
        pack_end (button_cancel, false, false);

        show_all ();
    }

}
