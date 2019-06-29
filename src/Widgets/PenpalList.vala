public class Litteris.PenpalList : Gtk.ScrolledWindow {
    public signal void penpal_selected (string penpal);
    public string active_penpal;
    public Granite.Widgets.SourceList source_list;
    private Sqlite.Database db;
    private string errmsg;

    public PenpalList () {
        Object (
            hadjustment : null,
            vadjustment : null
        );
    }

    construct {
        Application.database.open_database (out db);

        clear_list ();
        load_list ();
    }

    public void load_list (string search_content = "") {
        if (search_content != "") {
            clear_list ();

            var search = new Granite.Widgets.SourceList.ExpandableItem ("Search");
                search.collapsible = false;
            get_search (search, search_content);

            this.source_list.root.add (search);
        } else {
            clear_list ();

            var starred = new Granite.Widgets.SourceList.ExpandableItem ("Starred");
                starred.collapsible = false;
            get_penpals (true, starred);

            var penpals = new Granite.Widgets.SourceList.ExpandableItem ("Penpals");
                penpals.expand_all ();
            get_penpals (false, penpals);

            this.source_list.root.add (starred);
            this.source_list.root.add (penpals);
        }
    }

    public void get_penpals (bool starred, Granite.Widgets.SourceList.ExpandableItem group) {
        var starred_querry = starred ? "" : " NOT";
        var query = """
            SELECT name
                FROM penpals
                WHERE""" + starred_querry + """ EXISTS (SELECT * FROM starred WHERE penpals.rowid = starred.penpal)
                ORDER BY name ASC;
            """;

        var exec_query = this.db.exec (query, (n, v, c) => {
                var pal = new Granite.Widgets.SourceList.Item (v[0]);
                    group.add (pal);
                return 0;
            }, out errmsg);

        if (exec_query != Sqlite.OK) {
            stderr.printf ("Error: %s\n", errmsg);
        }
    }

    public void get_search (Granite.Widgets.SourceList.ExpandableItem group, string search_content) {
        var query = "SELECT name FROM penpals WHERE name LIKE '%"+search_content+"%' ORDER BY name ASC;";
        var count = 0;
        var exec_query = this.db.exec (query, (n, v, c) => {
                var pal = new Granite.Widgets.SourceList.Item (v[0]);
                    group.add (pal);
                    count++;
                return 0;
            }, out errmsg);

        if (count == 0) {
            var no_matches = new Granite.Widgets.SourceList.Item ("No matches ...");
                no_matches.selectable = false;
                group.add (no_matches);
        }

        if (exec_query != Sqlite.OK) {
            stderr.printf ("Error: %s\n", errmsg);
        }
    }

    public void clear_list () {
        if (source_list != null ) {
            remove (source_list);
        }

        source_list = new Granite.Widgets.SourceList ();

        source_list.item_selected.connect ((item) => {
            penpal_selected (item.name);
        });

        add (source_list);
    }

}
