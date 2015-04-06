

namespace LibraTimeTrack
{
  using System;
  using System.Collections.Generic;
  using System.Collections.ObjectModel;
  using System.Linq;
  using System.Text;


  class DataSourceManager
  {
    Model.DataClasses1DataContext _dc = null;
    ObservableCollection<Model.Item> _items = null;

    static DataSourceManager s_instance;
    private DataSourceManager()
    {
      if (_dc == null)
        _dc = new Model.DataClasses1DataContext();
      if (_items == null)
        _items = new ObservableCollection<Model.Item>(_dc.Items);
    }

    public static DataSourceManager Instance
    {
      get
      {
        if (s_instance == null)
          s_instance = new DataSourceManager();
        return s_instance;
      }
    }

    public ObservableCollection<Model.Item> Items { get { return _items; } }
    public Model.DataClasses1DataContext DC { get { return _dc; } }

  }
}
