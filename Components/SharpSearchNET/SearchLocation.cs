using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpSearchNET
{
    public interface ISearchLocation
    {
        string Name{ get; }
        string Description { get; }

        string SearchQuery { get; set; }

        void DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback);
        void FilterList(List<SearchResult> list, ISearchCallback searchCallback);
    }
}
