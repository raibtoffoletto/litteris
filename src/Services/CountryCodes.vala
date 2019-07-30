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

public class Litteris.CountryCodes {
    private void get_database (out Sqlite.Database database) {
        Application.database.open_database (out database);
    }

    public string get_country_name (string country_code) {
        Sqlite.Database db;
        string errmsg, query, country_name = "";
        get_database (out db);

        query = """SELECT country
                    FROM country_codes
                    WHERE `alpha-3` LIKE '""" + country_code + """';""";

        var exec_query = db.exec (query, (n, v, c) => {
                country_name = v[0];
                return 0;
            }, out errmsg);

        if (exec_query != 0) {
            stdout.printf ("Querry error: %s\n", errmsg);
            return "not found";
        }

        return country_name;
    }

    public string get_country_emoji (string country_code) {
        Sqlite.Database db;
        string errmsg, query, country_alpha2 = "";
        get_database (out db);

        query = """SELECT `alpha-2`
                    FROM country_codes
                    WHERE `alpha-3` LIKE '""" + country_code + """';""";

        var exec_query = db.exec (query, (n, v, c) => {
                country_alpha2 = v[0];
                return 0;
            }, out errmsg);

        if (exec_query != Sqlite.OK) {
            stdout.printf ("Querry error: %s\n", errmsg);
            return "N/A";
        }

        string country_emoji = get_letter_emoji (country_alpha2[0].to_string ());
               country_emoji += get_letter_emoji (country_alpha2[1].to_string ());

        return country_emoji;
    }

    public string get_letter_emoji (string letter) {
        switch (letter) {
            case "A":
                return "🇦";
            case "B":
                return "🇧";
            case "C":
                return "🇨";
            case "D":
                return "🇩";
            case "E":
                return "🇪";
            case "F":
                return "🇫";
            case "G":
                return "🇬";
            case "H":
                return "🇭";
            case "I":
                return "🇮";
            case "J":
                return "🇯";
            case "K":
                return "🇰";
            case "L":
                return "🇱";
            case "M":
                return "🇲";
            case "N":
                return "🇳";
            case "O":
                return "🇴";
            case "P":
                return "🇵";
            case "Q":
                return "🇶";
            case "R":
                return "🇷";
            case "S":
                return "🇸";
            case "T":
                return "🇹";
            case "U":
                return "🇺";
            case "V":
                return "🇻";
            case "W":
                return "🇼";
            case "X":
                return "🇽";
            case "Y":
                return "🇾";
            case "Z":
                return "🇿";
            default :
                return "";
        }
    }

}
