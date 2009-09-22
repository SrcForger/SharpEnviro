using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpSearchNET
{
    public interface ISearchCallback
    {
        void NewResult(SearchResult item);
        void RemoveResult(SearchResult item);
        void StartLocation(ISearchLocation item);
        void FinishLocation(ISearchLocation item);
        void FinishSearch();
    }

    public delegate void ItemChangeHandler(SearchResult item);
    public delegate void LocationChangeHandler(ISearchLocation item);
    public delegate void SearchEventHandler();

    public class SearchCallback : ISearchCallback
    {
        public event ItemChangeHandler OnNewResult;
        public event ItemChangeHandler OnRemoveResult;
        public event LocationChangeHandler OnStartLocation;
        public event LocationChangeHandler OnFinishLocation;
        public event SearchEventHandler OnFinishSearch;

        public void FinishSearch()
        {
            if (OnFinishSearch != null)
                OnFinishSearch();
        }

        public void NewResult(SearchResult item)
        {
            if (OnNewResult != null)
                OnNewResult(item);
        }

        public void RemoveResult(SearchResult item)
        {
            if (OnRemoveResult != null)
                OnRemoveResult(item);
        }

        public void StartLocation(ISearchLocation item)
        {
            if (OnStartLocation != null)
                OnStartLocation(item);
        }

        public void FinishLocation(ISearchLocation item)
        {
            if (OnFinishLocation != null)
                OnFinishLocation(item);
        }
    }
}
