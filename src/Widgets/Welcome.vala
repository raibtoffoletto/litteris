public class Litteris.Welcome : Gtk.Grid {
    public Welcome () {
        var welcome_screen = new Granite.Widgets.Welcome ("Litteris", _("Penpal Correspondence Organized"));

            welcome_screen.append ("document-new", _("New Penpal"),
                                    _("Add a new friend to start tracking your mail exchange."));

            welcome_screen.append ("system-search", _("Search"), _("Too many penpals? Look for their name!"));

        add (welcome_screen);
    }

}
