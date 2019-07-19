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
    public string active_penpal {get; construct;}
    public Gee.ArrayList<Litteris.MailDate> mail_sent;
    public Gee.ArrayList<Litteris.MailDate> mail_received;
    private string errmsg;
    private Sqlite.Database db;

    public Penpal (string penpal ) {
        Object (
            active_penpal: penpal
        );
    }

    construct {
        Application.database.open_database (out db);

        mail_sent = new Gee.ArrayList<Litteris.MailDate> ();
        mail_received = new Gee.ArrayList<Litteris.MailDate> ();

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

    }

    public void load_dates () {
        if (rowid != null) {
            var query = """
                SELECT *
                    FROM dates
                    WHERE penpal = """ + rowid + """
                    ORDER BY date ASC;
                """;

            var exec_query = db.exec (query, (n, v, c) => {
                    var mail = new Litteris.MailDate ();
                        mail.date = v[0];
                        mail.mail_type = (int.parse (v[2]) == 0) ? Litteris.MailDate.MailType.LETTER
                                                                : Litteris.MailDate.MailType.POSTCARD;
                        mail.direction = (int.parse (v[3]) == 0) ? Litteris.MailDate.Direction.SENT
                                                                : Litteris.MailDate.Direction.RECEIVED;
                    if (mail.direction == Litteris.MailDate.Direction.SENT) {
                        mail_sent.add (mail);
                    } else {
                        mail_received.add (mail);
                    }

                    return 0;
                }, out errmsg);

            if (exec_query != 0) {
                stdout.printf ("Querry error: %s\n", errmsg);
            }

        } else {
            print ("Error: No penpal set.\n");
        }

    }

}
