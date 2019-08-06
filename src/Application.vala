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

public class Litteris.Application : Gtk.Application {
    public Litteris.Window main_window;
    public static Litteris.DataBase database;
    public static GLib.Settings settings;

    public Application () {
        Object (
            application_id: "com.github.raibtoffoletto.litteris",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    static construct {
        settings = new GLib.Settings ("com.github.raibtoffoletto.litteris");
        database = new Litteris.DataBase ();
    }

    protected override void activate () {
        database.verify_database ();

        if (get_windows ().length () > 0) {
            main_window.present ();
        } else {
            main_window = new Litteris.Window (this);
            add_window (main_window);
            main_window.present ();
        }
    }

    public void reload_application () {
        Gdk.EventAny event = (Gdk.EventAny) new Gdk.Event (Gdk.EventType.DELETE);
        main_window.delete_event (event);
        main_window.destroy ();

        database = new Litteris.DataBase ();
        database.verify_database ();

        main_window = new Litteris.Window (this);
        add_window (main_window);
        main_window.present ();
        main_window.show_mainwindow_notification ("Backup restored with success!");
    }

    public static int main (string[] args) {
        var app = new Litteris.Application ();
        return app.run (args);
    }

}
