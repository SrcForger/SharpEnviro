using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;

namespace SharpSearchNET
{
    public class SearchResultData : DependencyObject
    {
        public SearchResultData(string name, string description, string location)
        {
            Name = name;
            Description = description;
            Location = location;
        }

        public static DependencyProperty NameProperty = DependencyProperty.Register("Name", typeof(string), typeof(SearchResult));
        public static DependencyProperty DescriptionProperty = DependencyProperty.Register("Description", typeof(string), typeof(SearchResult));
        public static DependencyProperty LocationProperty = DependencyProperty.Register("Location", typeof(string), typeof(SearchResult));

        public string Name
        {
            get { return (string)GetValue(NameProperty); }
            set { SetValue(NameProperty, value); }
        }

        public string Description
        {
            get { return (string)GetValue(DescriptionProperty); }
            set { SetValue(DescriptionProperty, value); }
        }
        
        public string Location
        {
            get { return (string)GetValue(LocationProperty); }
            set { SetValue(LocationProperty, value); }
        }
    }    
}
