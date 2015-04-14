

namespace LibraTimeTrack
{
  using System;
  using System.Collections.Generic;
  using System.Linq;
  using System.Text;
  using System.Windows;
  using System.Windows.Controls;
  using System.Windows.Data;
  using System.Windows.Documents;
  using System.Windows.Input;
  using System.Windows.Media;
  using System.Windows.Media.Imaging;
  using System.Windows.Navigation;
  using System.Windows.Shapes;

  /// <summary>
  /// Interaction logic for MainWindow.xaml
  /// </summary>
  public partial class MainWindow : Window
  {
    public MainWindow()
    {
      InitializeComponent();
    }

    ItemsFactory factory = null;
    //
    BindingListCollectionView blcvActivities;
    BindingListCollectionView blcvEstimations;
    //

     #region data context
     private void tabActivities_Initialized(object sender, EventArgs e)
     {
       AssignLinq2SqlDataContext();
     }

     private void tabActivities_Loaded(object sender, RoutedEventArgs e)
     {
       AssignLinq2SqlDataContext();
     }

     private void AssignLinq2SqlDataContext()
     {
       if (this.tabActivities != null && this.tabActivities.DataContext == null)
       {
         this.tabActivities.DataContext = DataSourceManager.Instance.DC.Activities;
         if (this.blcvActivities == null)
           this.blcvActivities = (BindingListCollectionView)CollectionViewSource.GetDefaultView(this.tabActivities.DataContext);
       }

       if (this.tabEstimations != null && this.tabEstimations.DataContext == null)
       {
         this.tabEstimations.DataContext = DataSourceManager.Instance.DC.Estimations;
         if (this.blcvEstimations == null)
           this.blcvEstimations = (BindingListCollectionView)CollectionViewSource.GetDefaultView(this.tabEstimations.DataContext);
       }
     }
     #endregion

    #region projects/rt/items
    private void tabItems_Loaded (object sender, RoutedEventArgs e)
    {
      AssignItemsDataContext();
    }

    private void tabItems_Initialized (object sender, EventArgs e)
    {
      AssignItemsDataContext();
    }

    private void AssignItemsDataContext ( )
    {
      if (factory == null)
      {
        factory = new ItemsFactory();
        //
        this.tabItems.DataContext = factory.GetItems();
      }
    }
    #endregion

    private void btnSave_Click(object sender, RoutedEventArgs e)
    {
      try { DataSourceManager.Instance.DC.SubmitChanges(); this.statusBarText.Content = "Saved"; }
      catch (Exception ex) { this.statusBarText.Content = ex.Message; }
    }

    private void btnAdd_Click(object sender, RoutedEventArgs e)
    {
      if (this.blcvActivities.CanAddNew)
      {
        var est = (Model.Estimation)this.blcvEstimations.AddNew();
        est.Date = System.DateTime.UtcNow;
        est.Item = DataSourceManager.Instance.DC.Items.First();
        est.Person = DataSourceManager.Instance.DC.Persons.First();
        est.NoHours = 0;
        
        // add validation
        this.blcvEstimations.CommitNew();
        this.listViewEstimations.ScrollIntoView(est);
      }
    }

    private void btnDel_Click(object sender, RoutedEventArgs e)
    {
      if (this.blcvEstimations.CurrentPosition > -1)
        this.blcvEstimations.RemoveAt(this.blcvEstimations.CurrentPosition);
    }

    private void ItemGotFocus(object sender, RoutedEventArgs e)
    {
      var lvi = sender as ListViewItem;
      this.listViewActivities.SelectedItem = lvi.DataContext;
    }

    private void TabCombos_Loaded(object sender, RoutedEventArgs e)
    {
      this.cmb1.DataContext = DataSourceManager.Instance.DC.Persons;
      this.cmb2.DataContext = DataSourceManager.Instance.DC.Items;
    }

    private void tabEstimations_GotFocus(object sender, RoutedEventArgs e)
    {
      //DataSourceManager.Instance.DC.GetChangeSet();
      //DataSourceManager.Instance.DC.Refresh(System.Data.Linq.RefreshMode.)
      this.listViewEstimations.UpdateLayout();
    }
  
   
  }
}
