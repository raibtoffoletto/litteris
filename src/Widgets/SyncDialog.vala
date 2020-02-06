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

public class Litteris.SyncDialog : Gtk.Dialog {

    public SyncDialog (Litteris.Window window) {
        Object (
            modal: true,
            destroy_with_parent: true,
            deletable: true,
            transient_for: window
        );
    }

    construct {
        var dialog = get_content_area ();
        var main_grid = new Gtk.Grid ();

        var cloud_icon = new Gtk.Image.from_icon_name ("applications-internet", Gtk.IconSize.DIALOG);
            cloud_icon.margin_end = 16;
        var description_label = new Gtk.Label (_("If you have a synced folder to the cloud (ex: <i>Nextcloud \nor " +
                                                "Dropbox</i>), Litteris can automatically sync your \npenpal " +
                                                "database between multiple devices."));

            description_label.margin = 8;
            description_label.use_markup = true;
            description_label.justify = Gtk.Justification.CENTER;
        var description_grid = new Gtk.Grid ();
            description_grid.margin_start = 16;
            description_grid.margin_end = 16;
            description_grid.attach (cloud_icon, 0, 0);
            description_grid.attach (description_label, 1, 0);

        var sync_label = new Gtk.Label (_("Sync :"));
            sync_label.halign = Gtk.Align.END;
        var sync_switch = new Gtk.Switch ();
            sync_switch.valign = Gtk.Align.CENTER;
            sync_switch.halign = Gtk.Align.START;
            Application.sync_settings.bind ("sync", sync_switch, "active", SettingsBindFlags.DEFAULT);

        var path_label = new Gtk.Label (_("Path to synced folder :"));
            path_label.halign = Gtk.Align.END;
        var path_selected = new Gtk.FileChooserButton (_("Select the synced folder"),
                                                        Gtk.FileChooserAction.SELECT_FOLDER);

        if (Application.sync_settings.get_string ("path") ==
            Application.sync_settings.get_default_value ("path").get_string ()) {

            path_selected.set_uri ("file://" + Environment.get_home_dir ());
        } else {
            path_selected.set_uri (Application.sync_settings.get_string ("path"));
        }

        path_selected.file_set.connect (() => {
            Application.database.update_sync_path (path_selected.get_uri (), this as Gtk.Window);
        });

        main_grid.row_spacing = 8;
        main_grid.column_spacing = 8;
        main_grid.column_homogeneous = true;
        main_grid.margin = 16;
        main_grid.margin_top = 0;
        main_grid.attach (description_grid, 0, 0, 2, 1);
        main_grid.attach (sync_label, 0, 1);
        main_grid.attach (sync_switch, 1, 1);
        main_grid.attach (path_label, 0, 2);
        main_grid.attach (path_selected, 1, 2);

        dialog.add (main_grid);
        dialog.show_all ();
    }

}
