/*
* Copyright (c) 2019 Raí B. Toffoletto (https://toffoletto.me)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Raí B. Toffoletto <rai@toffoletto.me>
*/

public class Litteris.PenpalList : Gtk.Box {
    public string active_penpal { get; set; }
    public Granite.Widgets.SourceList source_list;
    public Gtk.SearchBar search_bar;
    private Sqlite.Database db;
    private string errmsg;

    public PenpalList () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0,
            width_request: 180
        );
    }

    construct {
        Application.database.open_database (out db);

        var search_entry = new Gtk.SearchEntry ();

        search_bar = new Gtk.SearchBar ();
        search_bar.show_close_button = true;
        search_bar.add (search_entry);
        search_bar.connect_entry (search_entry);

        search_entry.search_changed.connect (() => {
            load_list (search_entry.text);
        });

        pack_start (search_bar, false, false);
        load_list ();
    }

    public void load_list (string search_content = "") {
        if (source_list != null) {
            remove (source_list);
        }

        source_list = new Granite.Widgets.SourceList ();
        source_list.item_selected.connect ((penpal) => {
            set_property ("active-penpal", penpal.name);
        });

        if (search_content != "") {
            var search = new Granite.Widgets.SourceList.ExpandableItem (_("Search"));
                search.collapsible = false;
                search.selectable = false;

            source_list.root.add (search);
            get_search (search, search_content);
        } else {
            var starred = new Granite.Widgets.SourceList.ExpandableItem (_("Starred"));
                starred.selectable = false;
                starred.collapsible = false;

            source_list.root.add (starred);
            get_penpals (starred, true);

            var penpals = new Granite.Widgets.SourceList.ExpandableItem (_("Penpals"));
                penpals.selectable = false;
                penpals.collapsible = false;

            source_list.root.add (penpals);
            get_penpals (penpals);
        }

        pack_end (source_list);
        show_all ();
    }

    private void get_penpals (Granite.Widgets.SourceList.ExpandableItem group, bool starred = false) {
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

                if (count == 1) {
                    source_list.selected = pal;
                    set_property ("active-penpal", pal.name);
                }

                return 0;
            }, out errmsg);

        if (count == 0) {
            var no_matches = new Granite.Widgets.SourceList.Item (_("No matches ..."));
                no_matches.selectable = false;
            group.add (no_matches);
        }

        if (exec_query != Sqlite.OK) {
            stderr.printf ("Error: %s\n", errmsg);
        }
    }

}
