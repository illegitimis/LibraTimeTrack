namespace LibraTimeTrack.Model
{
  	
    public partial class Item : System.ComponentModel.INotifyPropertyChanging, System.ComponentModel.INotifyPropertyChanged
    {
      public string Name
      {
        get
        {
          return RTId.HasValue ? RT.Name : PM.Name;
        }
      }

      public int InternalId
      {
        get
        {
          return RTId.HasValue ? RT.Id : PM.Id;
        }
      }
    }
}