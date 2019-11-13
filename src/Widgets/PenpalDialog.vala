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

public class Litteris.PenpalDialog : Gtk.Dialog {
    public bool edit_penpal { get; set; }
    public Gtk.Entry entry_name;
    public Gtk.Entry entry_nickname;
    public Gtk.TextView entry_notes;
    public Gtk.TextView entry_address;
    public Gtk.ComboBox combo_country;
    private Gtk.ListStore list_countries;
    private Gtk.Entry entry_country;
    private Litteris.CountryCodes countries_api;

    public PenpalDialog (Litteris.Window window) {
        Object (
            modal: true,
            destroy_with_parent: true,
            deletable: true,
            transient_for: window
        );
    }

    construct {
        countries_api = new Litteris.CountryCodes ();

        string gtk_theme_adjusted = """textview, text {background-color: rgb(245,245,245);}
                                       frame {border-radius: 3px;}
                                       frame, label {color: rgb(127,127,127);}
                                       combobox, box {color: rgb(127,127,127);}""";

        if (Gtk.Settings.get_default ().gtk_application_prefer_dark_theme) {
            gtk_theme_adjusted = """textview, text {background-color: rgb(61,61,61);}
                                    frame {border-radius: 3px;}
                                    frame, label {color: rgb(200,200,200);}
                                    combobox, box {color: rgb(200,200,200);}""";
        }

        var dialog = get_content_area ();
        var css_provider = new Gtk.CssProvider ();

            try {
                css_provider.load_from_data (gtk_theme_adjusted);
            } catch (Error e) {
                stdout.printf ("Error: %s\n", e.message);
            }

        entry_name = new Gtk.Entry ();
        entry_name.placeholder_text = _("* Name :");

        entry_nickname = new Gtk.Entry ();
        entry_nickname.placeholder_text = _("Nickname :");

        entry_notes = new Gtk.TextView ();
        entry_notes.get_style_context ().add_provider (css_provider, 900);
        var scroll_notes = new Gtk.ScrolledWindow (null, null);
            scroll_notes.hexpand = true;
            scroll_notes.margin_start = 6;
            scroll_notes.margin_end = 6;
            scroll_notes.margin_bottom = 6;
            scroll_notes.add (entry_notes);
        var frame_notes = new Gtk.Frame (_("Notes :"));
            frame_notes.add (scroll_notes);
            frame_notes.height_request = 120;
            frame_notes.label_widget.margin = 3;
            frame_notes.get_style_context ().add_provider (css_provider, 900);

        entry_address = new Gtk.TextView ();
        entry_address.get_style_context ().add_provider (css_provider, 900);
        var scroll_address = new Gtk.ScrolledWindow (null, null);
            scroll_address.hexpand = true;
            scroll_address.margin_start = 6;
            scroll_address.margin_end = 6;
            scroll_address.margin_bottom = 6;
            scroll_address.add (entry_address);
        var frame_address = new Gtk.Frame (_("Address :"));
            frame_address.add (scroll_address);
            frame_address.height_request = 120;
            frame_address.label_widget.margin = 3;
            frame_address.get_style_context ().add_provider (css_provider, 900);

        list_countries = countries_api.load_country_list ();
        var entry_country_completion = new Gtk.EntryCompletion ();
            entry_country_completion.set_model (list_countries);
            entry_country_completion.text_column = CountryCodes.Format.COUNTRY;
            entry_country_completion.inline_completion = true;
            entry_country_completion.inline_selection = true;
            entry_country_completion.action_activated.connect (on_country_changed);
        combo_country = new Gtk.ComboBox.with_model_and_entry (list_countries);
        combo_country.id_column = CountryCodes.Format.ALPHA3;
        combo_country.entry_text_column = CountryCodes.Format.COUNTRY;
        entry_country = (Gtk.Entry)combo_country.get_child ();
        entry_country.placeholder_text = _("* Country :");
        entry_country.completion = entry_country_completion;
        entry_country.key_press_event.connect (on_entry_key_pressed);
        entry_country.changed.connect (on_country_changed);
        entry_country.focus_out_event.connect (() => {
            entry_country.set_position (-1);
        });

        dialog.homogeneous = false;
        dialog.spacing = 6;
        dialog.margin_bottom = 8;
        dialog.margin_start = 16;
        dialog.margin_end = 16;
        dialog.pack_start (entry_name);
        dialog.pack_start (entry_nickname);
        dialog.pack_start (frame_notes);
        dialog.pack_start (frame_address);
        dialog.pack_start (combo_country);

        var button_cancel = new Gtk.Button.with_label (_("Discard Changes"));
            button_cancel.clicked.connect (confirm_discard);

        var button_confirm = new Gtk.Button ();
            button_confirm.label = _("Add Penpal");
            button_confirm.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        notify["edit-penpal"].connect (() => {
            button_confirm.label = _("Save Changes");
        });

        add_action_widget (button_cancel, Gtk.ResponseType.CANCEL);
        add_action_widget (button_confirm, Gtk.ResponseType.ACCEPT);

        dialog.show_all ();
        button_confirm.grab_focus ();

        delete_event.connect (() => {
            confirm_discard ();
            return true;
        });

        key_press_event.connect (event => {
            if (Gdk.keyval_name (event.keyval) == "Return" && event.state == Gdk.ModifierType.CONTROL_MASK) {
                this.response (Gtk.ResponseType.ACCEPT);
            }
            return false;
        });
    }

    private bool on_entry_key_pressed (Gdk.EventKey event) {
        var key = Gdk.keyval_name (event.keyval);
        var text = entry_country.text;

        if (key == "Escape") {
            entry_country.text = "";
            return true;
        }

        try {
            var key_letter = new Regex ("^\\p{L}$");
            var key_number = new Regex ("^\\p{N}$");
            if (key_letter.match (key) || key_number.match (key)) {
                return countries_api.check_country_exists (text+key);
            }
        } catch (RegexError e) {
            print ("Error: %s\n", e.message);
        }

        on_country_changed ();
        return false;
    }

    private void on_country_changed () {
        var country_selected = countries_api.get_country_code (entry_country.text);

        if (country_selected != null && country_selected != "") {
            combo_country.active_id = country_selected;
        }
    }

    private void confirm_discard () {
        if (entry_name.text != "" || entry_nickname.text != "" ||
            entry_notes.buffer.text != "" || entry_address.buffer.text != "" ||
            entry_country.text != "") {

            var dialog_discard = new Granite.MessageDialog.with_image_from_icon_name (
                                        _("Discard Changes?"),
                                        _("You will loose all changes made so far."),
                                        "edit-delete",
                                        Gtk.ButtonsType.CANCEL);

            var delete_confirm = new Gtk.Button.with_label (_("Discard"));
                delete_confirm.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

            dialog_discard.add_action_widget (delete_confirm, Gtk.ResponseType.ACCEPT);
            dialog_discard.transient_for = this;
            dialog_discard.show_all ();

            if (dialog_discard.run () == Gtk.ResponseType.ACCEPT) {
                this.destroy ();
            }

            dialog_discard.destroy ();
        } else {
            this.destroy ();
        }
    }

    public void get_penpal_to_edit (string penpal) {
        set_property ("edit-penpal", true);

        if (penpal != "") {
            var penpal_to_edit = new Litteris.Penpal (penpal);
            entry_name.text = penpal_to_edit.name;
            entry_nickname.text = penpal_to_edit.nickname;
            entry_notes.buffer.text = penpal_to_edit.notes;
            entry_address.buffer.text = penpal_to_edit.address;
            combo_country.active_id = penpal_to_edit.country;
        } else {
            this.destroy ();
        }
    }

}
