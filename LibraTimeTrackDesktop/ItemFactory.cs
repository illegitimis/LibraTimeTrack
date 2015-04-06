
namespace LibraTimeTrack
{
  using System;
  using System.Collections.Generic;
  using System.Text;
  using System.Collections.ObjectModel;
  using System.Linq;

  public class ItemsFactory
  {

    static ItemsFactory()
    {
     
    }

  

    public ItemsFactory()
    {

    }

    public void AddItem(Model.Item item)
    {
      DataSourceManager.Instance.Items.Add(item);
    }


    public IEnumerable<Model.Item> GetItems()
    {
      return DataSourceManager.Instance.Items.OrderBy(i => i.InternalId);
    }

    public IEnumerable<Model.Item> GetItemsFiltered(string titleToken)
    {
      return (GetItems()).Where(b =>
        (b.PMId.HasValue && b.PM.Name.Contains(titleToken))
        ||
        (b.RTId.HasValue && b.RT.Name.Contains(titleToken))
        );
    }
  }

}
