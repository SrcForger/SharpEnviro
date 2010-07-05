using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpSearch
{
	/// <summary>
	/// A class for search results.
	/// </summary>
	public class SearchData :
		ISearchData
	{
		#region Constructors

		/// <summary>
		/// Creates a new instance with the supplied values.
		/// </summary>
		/// <param name="filename"></param>
		/// <param name="description"></param>
		/// <param name="location"></param>
		public SearchData(string filename, string description, string location)
		{
			Filename = filename;
			Description = description;
			Location = location;
		}

		#endregion Constructors

		#region ISearchData Members

		/// <summary>
		/// The filename for the indexed item.
		/// </summary>
		public string Filename { get; set; }

		/// <summary>
		/// The description for the indexed item.
		/// </summary>
		public string Description { get; set; }

		/// <summary>
		/// The location of the indexed item.
		/// </summary>
		public string Location { get; set; }

		#endregion ISearchData Members
	}
}
