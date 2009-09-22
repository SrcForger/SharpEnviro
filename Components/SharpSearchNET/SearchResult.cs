using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;

namespace SharpSearchNET
{
    public class SearchResult
    {
        public string Name;
        public string Description;
        public string Location;

        public SearchResult(string name, string description, string location)
        {
            Name = name;
            Description = description;
            Location = location;

            if (Name == null)
                Name = "";
            if (Description == null)
                Description = "";
            if (Location == null)
                Location = "";
        }
    }
}
