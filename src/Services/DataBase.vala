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

    public bool exec_query (string query) {
        Sqlite.Database db;
        open_database (out db);
        var exec_query = db.exec (query);

        if (exec_query != Sqlite.OK) {
            print ("Error executing query:\n%s\n", query);
            return false;
        }

        return true;
    }

    public void initialize_database () {
        Sqlite.Database db;
        open_database (out db);

        string query = """
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

            CREATE TABLE `countries_code` (
              `alpha-3` TEXT NOT NULL,
              `country` TEXT NOT NULL,
              `alpha-2` TEXT NOT NULL
            );

            INSERT INTO `countries_code` (`alpha-3`, `country`, `alpha-2`) VALUES
                ('AFG','Afghanistan','AF'),
                ('ALA','Åland','AX'),
                ('ALB','Albania','AL'),
                ('DZA','Algeria','DZ'),
                ('ASM','American Samoa','AS'),
                ('AND','Andorra','AD'),
                ('AGO','Angola','AO'),
                ('AIA','Anguilla','AI'),
                ('ATA','Antarctica','AQ'),
                ('ATG','Antigua and Barbuda','AG'),
                ('ARG','Argentina','AR'),
                ('ARM','Armenia','AM'),
                ('ABW','Aruba','AW'),
                ('AUS','Australia','AU'),
                ('AUT','Austria','AT'),
                ('AZE','Azerbaijan','AZ'),
                ('BHS','Bahamas','BS'),
                ('BHR','Bahrain','BH'),
                ('BGD','Bangladesh','BD'),
                ('BRB','Barbados','BB'),
                ('BLR','Belarus','BY'),
                ('BEL','Belgium','BE'),
                ('BLZ','Belize','BZ'),
                ('BEN','Benin','BJ'),
                ('BMU','Bermuda','BM'),
                ('BTN','Bhutan','BT'),
                ('BOL','Bolivia','BO'),
                ('BES','Bonaire','BQ'),
                ('BIH','Bosnia and Herzegovina','BA'),
                ('BWA','Botswana','BW'),
                ('BVT','Bouvet Island','BV'),
                ('BRA','Brazil','BR'),
                ('IOT','British Indian Ocean Territory','IO'),
                ('VGB','British Virgin Islands','VG'),
                ('BRN','Brunei','BN'),
                ('BGR','Bulgaria','BG'),
                ('BFA','Burkina Faso','BF'),
                ('BDI','Burundi','BI'),
                ('KHM','Cambodia','KH'),
                ('CMR','Cameroon','CM'),
                ('CAN','Canada','CA'),
                ('CPV','Cape Verde','CV'),
                ('CYM','Cayman Islands','KY'),
                ('CAF','Central African Republic','CF'),
                ('TCD','Chad','TD'),
                ('CHL','Chile','CL'),
                ('CHN','China','CN'),
                ('CXR','Christmas Island','CX'),
                ('CCK','Cocos [Keeling] Islands','CC'),
                ('COL','Colombia','CO'),
                ('COM','Comoros','KM'),
                ('COK','Cook Islands','CK'),
                ('CRI','Costa Rica','CR'),
                ('HRV','Croatia','HR'),
                ('CUB','Cuba','CU'),
                ('CUW','Curacao','CW'),
                ('CYP','Cyprus','CY'),
                ('CZE','Czech Republic','CZ'),
                ('COD','Democratic Republic of the Congo','CD'),
                ('DNK','Denmark','DK'),
                ('DJI','Djibouti','DJ'),
                ('DMA','Dominica','DM'),
                ('DOM','Dominican Republic','DO'),
                ('TLS','East Timor','TL'),
                ('ECU','Ecuador','EC'),
                ('EGY','Egypt','EG'),
                ('SLV','El Salvador','SV'),
                ('GNQ','Equatorial Guinea','GQ'),
                ('ERI','Eritrea','ER'),
                ('EST','Estonia','EE'),
                ('ETH','Ethiopia','ET'),
                ('FLK','Falkland Islands','FK'),
                ('FRO','Faroe Islands','FO'),
                ('FJI','Fiji','FJ'),
                ('FIN','Finland','FI'),
                ('FRA','France','FR'),
                ('GUF','French Guiana','GF'),
                ('PYF','French Polynesia','PF'),
                ('ATF','French Southern Territories','TF'),
                ('GAB','Gabon','GA'),
                ('GMB','Gambia','GM'),
                ('GEO','Georgia','GE'),
                ('DEU','Germany','DE'),
                ('GHA','Ghana','GH'),
                ('GIB','Gibraltar','GI'),
                ('GRC','Greece','GR'),
                ('GRL','Greenland','GL'),
                ('GRD','Grenada','GD'),
                ('GLP','Guadeloupe','GP'),
                ('GUM','Guam','GU'),
                ('GTM','Guatemala','GT'),
                ('GGY','Guernsey','GG'),
                ('GIN','Guinea','GN'),
                ('GNB','Guinea-Bissau','GW'),
                ('GUY','Guyana','GY'),
                ('HTI','Haiti','HT'),
                ('HMD','Heard Island and McDonald Islands','HM'),
                ('HND','Honduras','HN'),
                ('HKG','Hong Kong','HK'),
                ('HUN','Hungary','HU'),
                ('ISL','Iceland','IS'),
                ('IND','India','IN'),
                ('IDN','Indonesia','ID'),
                ('IRN','Iran','IR'),
                ('IRQ','Iraq','IQ'),
                ('IRL','Ireland','IE'),
                ('IMN','Isle of Man','IM'),
                ('ISR','Israel','IL'),
                ('ITA','Italy','IT'),
                ('CIV','Ivory Coast','CI'),
                ('JAM','Jamaica','JM'),
                ('JPN','Japan','JP'),
                ('JEY','Jersey','JE'),
                ('JOR','Jordan','JO'),
                ('KAZ','Kazakhstan','KZ'),
                ('KEN','Kenya','KE'),
                ('KIR','Kiribati','KI'),
                ('XKX','Kosovo','XK'),
                ('KWT','Kuwait','KW'),
                ('KGZ','Kyrgyzstan','KG'),
                ('LAO','Laos','LA'),
                ('LVA','Latvia','LV'),
                ('LBN','Lebanon','LB'),
                ('LSO','Lesotho','LS'),
                ('LBR','Liberia','LR'),
                ('LBY','Libya','LY'),
                ('LIE','Liechtenstein','LI'),
                ('LTU','Lithuania','LT'),
                ('LUX','Luxembourg','LU'),
                ('MAC','Macao','MO'),
                ('MKD','Macedonia','MK'),
                ('MDG','Madagascar','MG'),
                ('MWI','Malawi','MW'),
                ('MYS','Malaysia','MY'),
                ('MDV','Maldives','MV'),
                ('MLI','Mali','ML'),
                ('MLT','Malta','MT'),
                ('MHL','Marshall Islands','MH'),
                ('MTQ','Martinique','MQ'),
                ('MRT','Mauritania','MR'),
                ('MUS','Mauritius','MU'),
                ('MYT','Mayotte','YT'),
                ('MEX','Mexico','MX'),
                ('FSM','Micronesia','FM'),
                ('MDA','Moldova','MD'),
                ('MCO','Monaco','MC'),
                ('MNG','Mongolia','MN'),
                ('MNE','Montenegro','ME'),
                ('MSR','Montserrat','MS'),
                ('MAR','Morocco','MA'),
                ('MOZ','Mozambique','MZ'),
                ('MMR','Myanmar [Burma]','MM'),
                ('NAM','Namibia','NA'),
                ('NRU','Nauru','NR'),
                ('NPL','Nepal','NP'),
                ('NLD','Netherlands','NL'),
                ('NCL','New Caledonia','NC'),
                ('NZL','New Zealand','NZ'),
                ('NIC','Nicaragua','NI'),
                ('NER','Niger','NE'),
                ('NGA','Nigeria','NG'),
                ('NIU','Niue','NU'),
                ('NFK','Norfolk Island','NF'),
                ('PRK','North Korea','KP'),
                ('MNP','Northern Mariana Islands','MP'),
                ('NOR','Norway','NO'),
                ('OMN','Oman','OM'),
                ('PAK','Pakistan','PK'),
                ('PLW','Palau','PW'),
                ('PSE','Palestine','PS'),
                ('PAN','Panama','PA'),
                ('PNG','Papua New Guinea','PG'),
                ('PRY','Paraguay','PY'),
                ('PER','Peru','PE'),
                ('PHL','Philippines','PH'),
                ('PCN','Pitcairn Islands','PN'),
                ('POL','Poland','PL'),
                ('PRT','Portugal','PT'),
                ('PRI','Puerto Rico','PR'),
                ('QAT','Qatar','QA'),
                ('COG','Republic of the Congo','CG'),
                ('REU','Réunion','RE'),
                ('ROU','Romania','RO'),
                ('RUS','Russia','RU'),
                ('RWA','Rwanda','RW'),
                ('BLM','Saint Barthélemy','BL'),
                ('SHN','Saint Helena','SH'),
                ('KNA','Saint Kitts and Nevis','KN'),
                ('LCA','Saint Lucia','LC'),
                ('MAF','Saint Martin','MF'),
                ('SPM','Saint Pierre and Miquelon','PM'),
                ('VCT','Saint Vincent and the Grenadines','VC'),
                ('WSM','Samoa','WS'),
                ('SMR','San Marino','SM'),
                ('STP','São Tomé and Príncipe','ST'),
                ('SAU','Saudi Arabia','SA'),
                ('SEN','Senegal','SN'),
                ('SRB','Serbia','RS'),
                ('SYC','Seychelles','SC'),
                ('SLE','Sierra Leone','SL'),
                ('SGP','Singapore','SG'),
                ('SXM','Sint Maarten','SX'),
                ('SVK','Slovakia','SK'),
                ('SVN','Slovenia','SI'),
                ('SLB','Solomon Islands','SB'),
                ('SOM','Somalia','SO'),
                ('ZAF','South Africa','ZA'),
                ('SGS','South Georgia and the South Sandwich Islands','GS'),
                ('KOR','South Korea','KR'),
                ('SSD','South Sudan','SS'),
                ('ESP','Spain','ES'),
                ('LKA','Sri Lanka','LK'),
                ('SDN','Sudan','SD'),
                ('SUR','Suriname','SR'),
                ('SJM','Svalbard and Jan Mayen','SJ'),
                ('SWZ','Swaziland','SZ'),
                ('SWE','Sweden','SE'),
                ('CHE','Switzerland','CH'),
                ('SYR','Syria','SY'),
                ('TWN','Taiwan','TW'),
                ('TJK','Tajikistan','TJ'),
                ('TZA','Tanzania','TZ'),
                ('THA','Thailand','TH'),
                ('TGO','Togo','TG'),
                ('TKL','Tokelau','TK'),
                ('TON','Tonga','TO'),
                ('TTO','Trinidad and Tobago','TT'),
                ('TUN','Tunisia','TN'),
                ('TUR','Turkey','TR'),
                ('TKM','Turkmenistan','TM'),
                ('TCA','Turks and Caicos Islands','TC'),
                ('TUV','Tuvalu','TV'),
                ('UMI','U.S. Minor Outlying Islands','UM'),
                ('VIR','U.S. Virgin Islands','VI'),
                ('UGA','Uganda','UG'),
                ('UKR','Ukraine','UA'),
                ('ARE','United Arab Emirates','AE'),
                ('GBR','United Kingdom','GB'),
                ('USA','United States','US'),
                ('URY','Uruguay','UY'),
                ('UZB','Uzbekistan','UZ'),
                ('VUT','Vanuatu','VU'),
                ('VAT','Vatican City','VA'),
                ('VEN','Venezuela','VE'),
                ('VNM','Vietnam','VN'),
                ('WLF','Wallis and Futuna','WF'),
                ('ESH','Western Sahara','EH'),
                ('YEM','Yemen','YE'),
                ('ZMB','Zambia','ZM'),
                ('ZWE','Zimbabwe','ZW');
            """;

        var exec_query = db.exec (query);

        if (exec_query != Sqlite.OK) {
            print ("Couldn't initialize database...\n");
            return;
        }
    }

}
