public class Litteris.PenpalList : Gtk.ScrolledWindow {
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

        source_list = new Granite.Widgets.SourceList ();
        add (source_list);

        load_list ();

        source_list.item_selected.connect ((penpal) => {
            active_penpal = penpal.name;
        });
    }

    public void load_list (string search_content = "") {
        if (source_list.root.children != null ) {
            foreach (var child in source_list.root.children) {
                source_list.root.remove (child);
            }
        }

        if (search_content != "") {
            var search = new Granite.Widgets.SourceList.ExpandableItem ("Search");
                search.collapsible = false;

            source_list.root.add (search);
            get_search (search, search_content);
        } else {
            var starred = new Granite.Widgets.SourceList.ExpandableItem ("Starred");
                starred.collapsible = false;

            source_list.root.add (starred);
            get_penpals (true, starred);

            var penpals = new Granite.Widgets.SourceList.ExpandableItem ("Penpals");
                penpals.expand_all ();

            source_list.root.add (penpals);
            get_penpals (false, penpals);
        }
    }

    private void get_penpals (bool starred, Granite.Widgets.SourceList.ExpandableItem group) {
        var starred_querry = starred ? "" : " NOT";
        var query = """
            SELECT name
                FROM penpals
                WHERE""" + starred_querry + """ EXISTS (SELECT * FROM starred WHERE penpals.rowid = starred.penpal)
                ORDER BY name ASC;
            """;

        var exec_query = db.exec (query, (n, v, c) => {
                var pal = new Granite.Widgets.SourceList.Item (v[0]);
                group.add (pal);
                if (pal.name == active_penpal) {
                    source_list.selected = pal;
                }

                return 0;
            }, out errmsg);

        if (exec_query != Sqlite.OK) {
            stderr.printf ("Error: %s\n", errmsg);
        }
    }

    private void get_search (Granite.Widgets.SourceList.ExpandableItem group, string search_content) {
        int count = 0;
        var query = "SELECT name FROM penpals WHERE name LIKE '%"+search_content+"%' ORDER BY name ASC;";
        var exec_query = db.exec (query, (n, v, c) => {
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

}
