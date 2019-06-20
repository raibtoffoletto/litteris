public class Litteris.PenpalList : Granite.Widgets.SourceList {
	public PenpalList () {

        var favorites = new Granite.Widgets.SourceList.ExpandableItem (_("  Starred"));
            favorites.collapsible = false;
        var fav1 = new Granite.Widgets.SourceList.Item ("My PenPal");
            favorites.add (fav1);
        root.add(favorites);

        var pal = new Granite.Widgets.SourceList.ExpandableItem (_("  Penpals"));
            pal.expand_all ();

	}
}
