

namespace LibraTimeTrack
{
  using System;
  using System.Collections.Generic;
  using System.Globalization;
  using System.Linq;
  using System.Text;
  using System.Windows.Data;

  [ValueConversion(typeof(Model.Person), typeof(string))]
  public class PersonNameConverter : IValueConverter
  {
    // Converts a Percent value to a new height value.
    // The data binding engine calls this method when
    // it propagates a value from the binding source to the binding target.
    public Object Convert(Object value, Type targetType, Object parameter, CultureInfo culture)
    {
      return targetType == typeof(string) 
        ? (value as Model.Person).Name
        : null;
    }
    // Converts a value. The data binding engine calls this
    // method when it propagates a value from the binding
    // target to the binding source.
    // As the binding is one-way, this is not implemented.
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
      return targetType == typeof(Model.Person)
        ? DataSourceManager.Instance.DC.Persons.FirstOrDefault(p => p.Name == (value as string))        
        : null;
    }
  }

  [ValueConversion(typeof(Model.Item), typeof(string))]
  public class ItemNameConverter : IValueConverter
  {
    // Converts a Percent value to a new height value.
    // The data binding engine calls this method when
    // it propagates a value from the binding source to the binding target.
    public Object Convert(Object value, Type targetType, Object parameter, CultureInfo culture)
    {
      return targetType == typeof(string)
        ? (value as Model.Item).Name
        : null;
    }
    // Converts a value. The data binding engine calls this
    // method when it propagates a value from the binding
    // target to the binding source.
    // As the binding is one-way, this is not implemented.
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
      return targetType == typeof(Model.Item)
        ? DataSourceManager.Instance.DC.Items.FirstOrDefault(i => i.Name == (value as string))
        : null;
    }
  }
}
