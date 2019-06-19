public class Litteris.Stack : Gtk.Stack {
    public Stack () {
        // var welcome = new Litteris.Welcome ();
        var penpal_model = new Litteris.Penpal ();

        add_named (penpal_model, "welcome");
    }
}
