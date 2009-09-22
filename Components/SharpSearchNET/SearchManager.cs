using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using SharpSearchNET.Locations;
using System.Threading;

namespace SharpSearchNET
{
    public class SearchManager
    {
        public List<ISearchLocation> Locations;

        public static Object HoldForQueryUpdate = "";

        void LoadLocations()
        {
            Locations.Clear();
            string settingsFile = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            settingsFile = settingsFile + "\\Settings\\User\\" + Environment.UserName + "\\Search\\Locations.xml";
            bool validSettingsFile = false;

            if (System.IO.File.Exists(settingsFile))
            {   // load settings if file exists
                XmlDocument xml = new XmlDocument();
                try
                {
                    xml.Load(settingsFile);
                    XmlNodeList xmlLocations = xml.GetElementsByTagName("location");
                    foreach (XmlNode xmlNode in xmlLocations)
                    {
                        if ((xmlNode.Attributes["Name"] != null) && (xmlNode.Attributes["Description"] != null) && (xmlNode.Attributes["Type"] != null))
                        {
                            switch (xmlNode.Attributes["Type"].Value)
                            {
                                case "Directory":
                                    if (xmlNode.Attributes["Path"] != null)
                                    {                                    
                                        SearchDirectory item = new SearchDirectory(xmlNode.Attributes["Name"].Value,
                                                                                   xmlNode.Attributes["Description"].Value,
                                                                                   xmlNode.Attributes["Path"].Value);
                                        Locations.Add(item);
                                    }
                                    break;
                            }
                        }
                    }
                    validSettingsFile = true;
                }
                catch
                {
                    
                }                
            }

            if (!validSettingsFile) 
            {   // settings file doesn't exist or there was an error reading it, use default values
                Locations.Clear();
            }
        }

        public void DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback)
        {
            // set the search query for all targets before starting the search (it might change while searching!)
            foreach (ISearchLocation searchLocation in Locations)
                searchLocation.SearchQuery = query;

            foreach (ISearchLocation searchLocation in Locations)
            {
                if (searchCallback != null)
                    searchCallback.StartLocation(searchLocation);
                searchLocation.DoSearch(searchLocation.SearchQuery, list, searchCallback);
                if (searchCallback != null)
                    searchCallback.FinishLocation(searchLocation);
            }

            if (searchCallback != null)
                searchCallback.FinishSearch();
        }

        public void UpdateSearch(string newQuery, List<SearchResult> list, ISearchCallback searchCallback)
        {
            foreach (ISearchLocation searchLocation in Locations)
                searchLocation.SearchQuery = newQuery;

            foreach (ISearchLocation searchLocation in Locations)
                searchLocation.FilterList(list, searchCallback);
        }

        public SearchManager()
        {
            Locations = new List<ISearchLocation>();
            LoadLocations();
        }
    }
}
