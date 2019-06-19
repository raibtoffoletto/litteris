public class Litteris.ContactList : Granite.Widgets.SourceList {
	public ContactList () {

        var favorites = new Granite.Widgets.SourceList.ExpandableItem ("  Starred");
            favorites.collapsible = false;
        var fav1 = new Granite.Widgets.SourceList.Item ("My PenPal");
            favorites.add (fav1);
        root.add(favorites);

        var pal = new Granite.Widgets.SourceList.ExpandableItem ("  Penpals");
            pal.expand_all ();

	}
}
