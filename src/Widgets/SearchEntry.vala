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

public class Litteris.Search : Gtk.Box {
    public signal void search_content_changed (string search_content = "");
    public signal void show_find_button ();
    public signal void show_search_entry ();

    public Search () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 0
        );
    }

    construct {
        create_find_button ();

        show_search_entry.connect (create_search_entry);
        show_find_button.connect (create_find_button);
    }

    public void create_find_button () {
        var find_button = new Gtk.ToggleButton ();
            find_button.image = new Gtk.Image.from_icon_name ("edit-find", Gtk.IconSize.LARGE_TOOLBAR);
            find_button.tooltip_text = _("Find Contact");
            find_button.clicked.connect (() => {
                show_search_entry ();
            });

        remove_widgets ();
        pack_end (find_button);
        show_all ();
        find_button.grab_focus ();
    }

    public void create_search_entry () {
        var search_entry = new Gtk.SearchEntry ();

        search_entry.focus_out_event.connect(() => {
            show_find_button ();
            search_content_changed ();
            return true;
        });

        search_entry.search_changed.connect (() => {
            search_content_changed (search_entry.text);
        });

        //work around to avoid multiple deletions
        search_entry.stop_search.connect (() => {
            search_entry.move_focus (Gtk.DirectionType.TAB_FORWARD);
        });

        search_entry.activate.connect (() => {
            search_entry.move_focus (Gtk.DirectionType.TAB_FORWARD);
         });

        remove_widgets ();
        pack_end (search_entry);
        show_all ();

        search_entry.grab_focus ();
    }

    public void remove_widgets () {
        var box_children = get_children ();
        foreach (var x in box_children) {
            remove (x);
        }
    }

}
