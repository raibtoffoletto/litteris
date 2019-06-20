public class Litteris.Header : Gtk.HeaderBar {
    public Header () {
        Object (
            title: "Litteris",
            has_subtitle: false,
            show_close_button: true
        );
    }

    construct {
        var button_new = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        button_new.tooltip_text = _("New Penpal");

        var button_edit = new Gtk.Button.from_icon_name ("document-edit", Gtk.IconSize.LARGE_TOOLBAR);
        button_edit.tooltip_text = _("Edit Penpal");

        var button_del = new Gtk.Button.from_icon_name ("edit-delete", Gtk.IconSize.LARGE_TOOLBAR);
        button_del.tooltip_text = _("Delete Penpal");

        var app_menu = new Litteris.AppMenu ();
        var button_menu = new Gtk.MenuButton ();
        button_menu.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        button_menu.popover = app_menu;
        button_menu.tooltip_text = _("Options");

        var penpal_search = new Litteris.Search ();

        pack_start (button_new);
        pack_start (button_edit);
        pack_start (button_del);
        pack_end (button_menu);
        pack_end (penpal_search);

        show_all ();
    }

}
