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

public class Litteris.AppMenu : Gtk.Popover {
    public Granite.ModeSwitch dark_mode { get; set; }

    public AppMenu () {
        Object (
            relative_to : null,
            modal : true
        );
    }

    construct {
        var gtk_settings = Gtk.Settings.get_default ();

        dark_mode = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic",
                                                            "weather-clear-night-symbolic");
        dark_mode.primary_icon_tooltip_text = (_("Light Mode"));
        dark_mode.secondary_icon_tooltip_text = (_("Dark Mode"));
        dark_mode.valign = Gtk.Align.CENTER;
        dark_mode.halign = Gtk.Align.CENTER;
        dark_mode.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        dark_mode.margin = 12;

        var label_dummy = new Gtk.Label ("");
        var label_dummy_2 = new Gtk.Label ("");

        var box_theme = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box_theme.tooltip_markup = Granite.markup_accel_tooltip ({"<Control>M"});
            box_theme.pack_start (label_dummy, true, true);
            box_theme.pack_start (dark_mode, false, false);
            box_theme.pack_end (label_dummy_2, true, true);

        if (Application.settings.get_boolean ("dark-mode")) {
            dark_mode.active = true;
        }

        var menu_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_separator.margin = 6;
        var menu_separator2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            menu_separator2.margin = 6;

        var menu_export = new Gtk.ModelButton ();
            menu_export.centered = true;
            menu_export.text = _("Create a backup");
            menu_export.action_name =  Window.ACTION_PREFIX + Window.ACTION_EXPORT_DB;
            menu_export.tooltip_markup = Granite.markup_accel_tooltip ({"<Control><Shift>E"});

        var menu_import = new Gtk.ModelButton ();
            menu_import.centered = true;
            menu_import.text = _("Restore backup");
            menu_import.action_name =  Window.ACTION_PREFIX + Window.ACTION_IMPORT_DB;
            menu_import.tooltip_markup = Granite.markup_accel_tooltip ({"<Control><Shift>I"});

        var menu_sync = new Gtk.ModelButton ();
            menu_sync.centered = true;
            menu_sync.text = _("Sync options");
            menu_sync.action_name =  Window.ACTION_PREFIX + Window.ACTION_SYNC;
            menu_sync.tooltip_markup = Granite.markup_accel_tooltip ({"<Control><Shift>S"});

        var menu_about = new Gtk.ModelButton ();
            menu_about.centered = true;
            menu_about.text = _("About");
            menu_about.action_name = Window.ACTION_PREFIX + Window.ACTION_ABOUT_DIALOG;
            menu_about.tooltip_markup = Granite.markup_accel_tooltip ({"F1"});

        var menu_grid = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            menu_grid.margin = 6;
            menu_grid.pack_start (box_theme);
            menu_grid.pack_start (menu_separator);
            menu_grid.pack_start (menu_export);
            menu_grid.pack_start (menu_import);
            menu_grid.pack_start (menu_sync);
            menu_grid.pack_start (menu_separator2);
            menu_grid.pack_start (menu_about);
            menu_grid.show_all ();

        add (menu_grid);
    }

}
