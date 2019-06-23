public class Litteris.Penpal {
    public int id;
    public string name;
    public string nickname;
    public string notes;
    public string address;
    public string country;
    public Litteris.MailDate[] dates;

    public Penpal (int db_id ) {
        id = db_id;
    }
}
