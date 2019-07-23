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

public class Litteris.Penpal : Object {
    public string rowid {get; construct;}
    public string name {get; construct;}
    public string nickname {get; construct;}
    public string notes {get; construct;}
    public string address {get; construct;}
    public string country {get; construct;}
    public string country_name {get; construct;}
    public string country_emoji {get; construct;}
    public string active_penpal {get; construct;}
    public Gee.ArrayList<Litteris.MailDate> mail_sent;
    public Gee.ArrayList<int> mail_sent_years;
    public Gee.ArrayList<Litteris.MailDate> mail_received;
    public Gee.ArrayList<int> mail_received_years;
    private string errmsg;
    private Sqlite.Database db;
    private Litteris.CountryCodes countries_api;

    public Penpal (string penpal ) {
        Object (
            active_penpal: penpal
        );
    }

    construct {
        Application.database.open_database (out db);
        countries_api = new Litteris.CountryCodes ();

        mail_sent = new Gee.ArrayList<Litteris.MailDate> ();
        mail_sent_years = new Gee.ArrayList<int> ();
        mail_received = new Gee.ArrayList<Litteris.MailDate> ();
        mail_received_years = new Gee.ArrayList<int> ();

        load_penpal ();
        load_dates ();
    }

    public void load_penpal () {
        var query = """
            SELECT rowid, *
                FROM penpals
                WHERE name LIKE '""" + active_penpal + """';
            """;

        var exec_query = db.exec (query, (n, v, c) => {
                for (int i = 0; i < n; i++) {
                    set_property (c[i], v[i]);
                }
                return 0;
            }, out errmsg);

        if (exec_query != 0) {
            stdout.printf ("Querry error: %s\n", errmsg);
        }

        set_property ("country-name", countries_api.get_country_name (country));
        set_property ("country-emoji", countries_api.get_country_emoji (country));
    }

    public void load_dates () {
        if (rowid != null) {
            var query = """
                SELECT rowid, date, type, direction
                    FROM dates
                    WHERE penpal = """ + rowid + """
                    ORDER BY date DESC;
                """;

            var exec_query = db.exec (query, (n, v, c) => {
                    var mail = new Litteris.MailDate ();
                        mail.rowid = v[0];
                        mail.date = int64.parse (v[1]);
                        mail.mail_type = (int.parse (v[2]) == 0) ? Litteris.MailDate.MailType.LETTER
                                                                : Litteris.MailDate.MailType.POSTCARD;
                        mail.direction = (int.parse (v[3]) == 0) ? Litteris.MailDate.Direction.SENT
                                                                : Litteris.MailDate.Direction.RECEIVED;
                    add_mail (mail);
                    return 0;
                }, out errmsg);

            if (exec_query != 0) {
                stdout.printf ("Querry error: %s\n", errmsg);
            }

        } else {
            print ("Error: No penpal set.\n");
        }
    }

    private void add_mail (Litteris.MailDate mail) {
        var date = new DateTime.from_unix_utc (mail.date);

        if (mail.direction == Litteris.MailDate.Direction.SENT) {
            if (! mail_sent_years.contains (date.get_year ())) {
                mail_sent_years.add (date.get_year ());
            }
            mail_sent.add (mail);
        } else {
            if (! mail_received_years.contains (date.get_year ())) {
                mail_received_years.add (date.get_year ());
            }
            mail_received.add (mail);
        }
    }

}
