using System;
using System.Collections.Generic;
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
        EventWaitHandle Waiting { get; }
        bool IsWaiting { get; }

        void LockThread(EventWaitHandle ewh);
        void UnlockThread();
        void DoDatabaseSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, SQLiteConnection sqlConnection);
        void DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback, SQLiteConnection sqlConnection);
        void FilterList(List<SearchResult> list, ISearchCallback searchCallback);
    }
}
