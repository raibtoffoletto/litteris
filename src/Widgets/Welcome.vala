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

public class Litteris.Welcome : Granite.Widgets.Welcome {
    public unowned Litteris.Window window { get; construct; }

    public Welcome (Litteris.Window window) {
        Object (
            window: window,
            title: "Litteris",
            subtitle: _("Penpal Correspondence Organized")
        );
    }

    construct {
        append ("document-new", _("New Penpal"), _("Add a new friend to start tracking your mail exchange."));
        append ("system-search", _("Search"), _("Too many penpals? Look up their name!"));

        activated.connect (i => {
                var action_group = window.get_action_group ("win");
            switch (i) {
                case 0:
                    action_group.activate_action (Window.ACTION_NEW_PENPAL, null);
                    break;
                case 1:
                    action_group.activate_action (Window.ACTION_SEARCH, null);
                    break;
            }
        });
    }

}
