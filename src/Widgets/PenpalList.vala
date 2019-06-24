public class Litteris.PenpalList : Gtk.Grid {
    private Gtk.Label label;
    private Sqlite.Database db;
    private string errmsg;

    public PenpalList () {
        Application.database.open_database (out db);

        label = new Gtk.Label ("");
        attach (label, 0, 0);

        get_starred ();
        get_penpal ();
    }

    public void get_starred () {
        var querry = """
            SELECT penpals.rowid, penpals.name
                FROM penpals, starred
                WHERE starred.penpal LIKE penpals.rowid
                ORDER BY penpals.name ASC;
            """;

        var exec_querry = this.db.exec (querry, (n, v, c) => {
                this.label.label += " - %s (%s) \n".printf (v[1], v[0]);
                return 0;
            }, out errmsg);

        if (exec_querry != Sqlite.OK) {
            stderr.printf ("Error: %s\n", errmsg);
        }
    }

    public void get_penpal () {
        var querry = "SELECT rowid, name FROM penpals ORDER BY name ASC;";
        var exec_querry = this.db.exec (querry, (n, v, c) => {
                this.label.label += " - %s (%s) \n".printf (v[1], v[0]);
                return 0;
            }, out errmsg);

        if (exec_querry != Sqlite.OK) {
            stderr.printf ("Error: %s\n", errmsg);
        }
    }

}
