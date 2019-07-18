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

public class Litteris.DataBase {
    public File get_database () {
        return File.new_for_path (get_database_path ());
    }

    public string get_database_path () {
        return Path.build_filename (Environment.get_user_data_dir (), "litteris", "litteris.db");
    }

    public void verify_database () {
        try {
            var path = File.new_build_filename (Environment.get_user_data_dir (), "litteris");
            if (! path.query_exists () ) {
                path.make_directory_with_parents ();
            }
            assert (path.query_exists ());

            var database = get_database ();
            if (! database.query_exists () ) {
                database.create (FileCreateFlags.PRIVATE);
                assert (database.query_exists ());
                initialize_database ();
            }
        } catch (Error e) {
             stderr.printf ("Error: %s\n", e.message);
        }
    }

    public void open_database (out Sqlite.Database database) {
        var connexion = Sqlite.Database.open (get_database_path (), out database);
        if (connexion != Sqlite.OK) {
            stderr.printf ("Can't open database: %d: %s\n", database.errcode (), database.errmsg ());
        }
    }

    public void initialize_database () {
        Sqlite.Database db;
        open_database (out db);

        string create_tables = """
            CREATE TABLE `dates` (
              `date` TEXT NOT NULL,
              `penpal` INTEGER NOT NULL,
              `type` INT NOT NULL,
              `direction` INT NOT NULL
            );
            CREATE TABLE `penpals` (
              `name` TEXT NOT NULL,
              `nickname` TEXT NULL,
              `notes` TEXT NULL,
              `address` TEXT NULL,
              `country` TEXT NOT NULL
            );
            CREATE TABLE `starred` (
              `penpal` INTEGER NOT NULL
            );
        """;

        var query = db.exec (create_tables);
        if (query != Sqlite.OK) {
            print ("Couldn't initialize database...\n");
            return;
        }
    }

}
