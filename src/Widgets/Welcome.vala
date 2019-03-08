public class Litteris.Welcome : Gtk.Grid {

    public Welcome () {
        var welcome_screen = new Granite.Widgets.Welcome ("Litteris", "Penpal Correspondence Organized");
            welcome_screen.append ("document-new", "Add a Penpal", "Include a new friend in your contacts.");
            welcome_screen.append ("mail-message-new", "Register Mail", "Letter received or sent? Keep track of it!");

        add (welcome_screen);
    }

}
