public class Litteris.MailDate {
    public enum MailType {
        LETTER,
        POSTCARD
    }
    public enum Direction {
        SENT,
        RECEIVED
    }

    public string date;
    public MailType type;
    public Direction direction;
}
