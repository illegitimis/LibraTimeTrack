
namespace LibraTimeTrack
{
  using System;
  using System.Windows;
  using System.Windows.Controls;
 
  public class ItemDataTemplateSelector : DataTemplateSelector
   {
      public override DataTemplate SelectTemplate(object item, DependencyObject container)
      {
         if (item != null && item is Model.Item)
         {
            Window window = Application.Current.MainWindow;

            Model.Item book = item as Model.Item;
            if (book.RTId.HasValue)
            {
              if (book.PMId.HasValue)
                throw new Exception ("Cannot be PM and RT");


              switch (book.RT.ItemType)
              {
                case 100:
                default:
                  return window.FindResource("RTNormalTemplate") as DataTemplate;
                case 101:
                  return window.FindResource("RTShortlistedNoPMTemplate") as DataTemplate;
              }

            }
            else if (book.PMId.HasValue)
            {
              switch (book.PM.ItemType)
              {
                case 0:
                default:
                  return window.FindResource("PMNormalTemplate") as DataTemplate;
                case 1:
                  return window.FindResource("PMMaintenanceTemplate") as DataTemplate;
                case 2:
                  return window.FindResource("PMNothingTemplate") as DataTemplate;
              }
            }
            else
            {
              throw new Exception ("Item should be PM or RT");
            }

               

         }
         return null;
      }
   }
}
