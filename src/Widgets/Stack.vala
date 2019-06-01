public class Litteris.Stack : Gtk.Stack {
    public Stack () {
        var welcome = new Litteris.Welcome ();
        add_named (welcome, "welcome");
    }
}
