using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Data.SQLite;
using System.Threading;

namespace SharpSearchNET
{
    public interface ISearchLocation
    {
        string Name{ get; }
        string Description { get; }

        string SearchQuery { get; set; }

        bool DoDatabaseSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, SQLiteConnection sqlConnection, BackgroundWorker SearchBw);
        bool DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, SQLiteConnection sqlConnection, BackgroundWorker SearchBw);
        bool FilterList(List<SearchResult> list, ISearchCallback searchCallback, BackgroundWorker SearchBw);
    }
}
