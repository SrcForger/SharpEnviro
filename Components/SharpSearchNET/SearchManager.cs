using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Xml;
using SharpSearchNET.Locations;
using System.Threading;
using System.Data.SQLite;

namespace SharpSearchNET
{
    public class SearchManager
    {
        public List<ISearchLocation> Locations;
        public SQLiteConnection SqlConnection;

        public static Object HoldForQueryUpdate = "";

        void LoadDatabase()
        {
            string databaseFile = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            databaseFile += "\\Settings\\User\\" + Environment.UserName + "\\Search\\";
            System.IO.Directory.CreateDirectory(databaseFile);
            databaseFile += "Database.db3";
            string connectionString = "Data Source=" + databaseFile;
            connectionString = connectionString + ";Pooling=true;FailIfMissing=false";

            try
            {
                SqlConnection = new SQLiteConnection(connectionString);
                SqlConnection.Open();
            }
            catch
            {
                Environment.Exit((int)ExitCode.DatabaseConnectionFailed);
            }
        }
        
        void LoadLocations()
        {
            Locations.Clear();
            string settingsFile = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            settingsFile = settingsFile + "\\Settings\\User\\" + Environment.UserName + "\\Search\\Locations.xml";
            bool validSettingsFile = false;

            if (System.IO.File.Exists(settingsFile))
            {
				// load settings if file exists
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
                                        string tableID = "dir0";
                                        if (xmlNode.Attributes["TableID"] != null)
                                            tableID = xmlNode.Attributes["TableID"].Value;
                                        SearchDirectory item = new SearchDirectory(xmlNode.Attributes["Name"].Value,
                                                                                   xmlNode.Attributes["Description"].Value,
                                                                                   xmlNode.Attributes["Path"].Value,
                                                                                   tableID);
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
            {
				// settings file doesn't exist or there was an error reading it, use default values
                Locations.Clear();
                SearchDirectory item = new SearchDirectory("Start Menu",
                                                           "Windows Start Menu",
                                                           "{AllUsersStartMenu}",
                                                           "dir1");
                Locations.Add(item);
                item = new SearchDirectory("Start Menu",
                                           "Windows Start Menu",
                                           "{UserStartMenu}",
                                           "dir2");
                Locations.Add(item);
            }
        }

        // The reason why Database search and normal search are seperated is because the database search will in most cases be
        // significantly faster. For all search locations a quick database search will be done first. The normal search of each
        // search location will be started after all database searches are done
        private bool DoDatabaseSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, BackgroundWorker SearchBw)
        {
            foreach (ISearchLocation searchLocation in Locations)
            {
                searchLocation.SearchQuery = query;

                if (searchCallback != null)
                    searchCallback.StartLocation(searchLocation);
                if (!searchLocation.DoDatabaseSearch(searchLocation.SearchQuery, list, searchCallback, SqlConnection, SearchBw))
                    break;
                if (searchCallback != null)
                    searchCallback.FinishLocation(searchLocation);
            }

            if (searchCallback != null)
                searchCallback.FinishSearch();

            return !(SearchBw.CancellationPending);
        }

        public bool DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, BackgroundWorker SearchBw)
        {
            DoDatabaseSearch(query, list, searchCallback, SearchBw);

            foreach (ISearchLocation searchLocation in Locations)
            {
                searchLocation.SearchQuery = query;

                if (searchCallback != null)
                    searchCallback.StartLocation(searchLocation);
                if (!searchLocation.DoSearch(searchLocation.SearchQuery, list, searchCallback, SqlConnection, SearchBw))
                    break;
                if (searchCallback != null)
                    searchCallback.FinishLocation(searchLocation);
            }

            if (searchCallback != null)
                searchCallback.FinishSearch();

            return !(SearchBw.CancellationPending);
        }

        public bool UpdateSearch(string newQuery, List<SearchResult> list, ISearchCallback searchCallback, BackgroundWorker SearchBw)
        {
            foreach (ISearchLocation searchLocation in Locations)
            {
                searchLocation.SearchQuery = newQuery;
                if (!searchLocation.FilterList(list, searchCallback, SearchBw))
                    break;
            }

            if (searchCallback != null)
                searchCallback.FinishSearch();

            return !(SearchBw.CancellationPending);
        }

        ~SearchManager()
        {
            if (SqlConnection != null)
                SqlConnection.Close();
        }

        public SearchManager()
        {
            Locations = new List<ISearchLocation>();
            LoadLocations();
            LoadDatabase();
        }
    }
}
