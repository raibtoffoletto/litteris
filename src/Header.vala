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

public class Litteris.Header : Gtk.HeaderBar {
    public Gtk.MenuButton button_menu;
    public Litteris.AppMenu app_menu;

    public Header () {
        Object (
            title: "Litteris",
            has_subtitle: false,
            show_close_button: true
        );
    }

    construct {
        var button_new = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
            button_new.tooltip_markup = Granite.markup_accel_tooltip ({"<Control>N"}, _("New Penpal"));
            button_new.action_name = Window.ACTION_PREFIX + Window.ACTION_NEW_PENPAL;

        var button_edit = new Gtk.Button.from_icon_name ("document-edit", Gtk.IconSize.LARGE_TOOLBAR);
            button_edit.tooltip_markup = Granite.markup_accel_tooltip ({"<Control>E"}, _("Edit Penpal"));
            button_edit.action_name = Window.ACTION_PREFIX + Window.ACTION_EDIT_PENPAL;

        var button_del = new Gtk.Button.from_icon_name ("edit-delete", Gtk.IconSize.LARGE_TOOLBAR);
            button_del.tooltip_markup = Granite.markup_accel_tooltip ({"<Control>D"}, _("Remove Penpal"));
            button_del.action_name = Window.ACTION_PREFIX + Window.ACTION_DELETE_PENPAL;

        app_menu = new Litteris.AppMenu ();
        button_menu = new Gtk.MenuButton ();
        button_menu.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        button_menu.popover = app_menu;
        button_menu.tooltip_markup = Granite.markup_accel_tooltip ({"<Control>O"}, _("Options"));

        pack_start (button_new);
        pack_start (button_edit);
        pack_start (button_del);
        pack_end (button_menu);

        show_all ();
    }

}
