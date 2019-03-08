public class Litteris.ContactList : Granite.Widgets.SourceList {
	public ContactList () {

        var favorites = new Granite.Widgets.SourceList.ExpandableItem ("  Starred");
            favorites.collapsible = false;
        var fav1 = new Granite.Widgets.SourceList.Item ("My PenPal");
            favorites.add (fav1);
        root.add(favorites);

        var pal = new Granite.Widgets.SourceList.ExpandableItem ("  Penpals");
            pal.expand_all ();
        var pal_1 = new Granite.Widgets.SourceList.Item ("Armando");
            pal.add (pal_1);
        var pal_2 = new Granite.Widgets.SourceList.Item ("Armenio");
            pal.add (pal_2);
        var pal_3 = new Granite.Widgets.SourceList.Item ("Artando");
            pal.add (pal_3);
        var fav2 = new Granite.Widgets.SourceList.Item ("Jaozinn");
            pal.add (fav2);
        var fav3 = new Granite.Widgets.SourceList.Item ("John Doe");
            pal.add (fav3);
        var fav4 = new Granite.Widgets.SourceList.Item ("John Doesnt");
            pal.add (fav4);
        var fav5 = new Granite.Widgets.SourceList.Item ("John Do Nothing");
            pal.add (fav5);
        var fav6 = new Granite.Widgets.SourceList.Item ("John Dude");
            pal.add (fav6);
        var fav7 = new Granite.Widgets.SourceList.Item ("John Doente");
            pal.add (fav7);
        var fav8 = new Granite.Widgets.SourceList.Item ("John DoEee");
            pal.add (fav8);
        var fav9 = new Granite.Widgets.SourceList.Item ("John DoDo");
            pal.add (fav9);
        var favZ = new Granite.Widgets.SourceList.Item ("Zezinn");
            pal.add (favZ);
        root.add(pal);

	}
}
