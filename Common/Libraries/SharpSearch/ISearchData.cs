using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Media;

namespace SharpSearch
{
	/// <summary>
	/// The search data interface for items stored in or retrieved from the databse.
	/// </summary>
	public interface ISearchData
	{
		/// <summary>
		/// The row identifier for the search data in the database.
		/// </summary>
		Int64 RowID { get; set; }

		/// <summary>
		/// The filename for the indexed item.
		/// </summary>
		string Filename { get; set; }

		/// <summary>
		/// The description for the indexed item.
		/// </summary>
		string Description { get; set; }

		/// <summary>
		/// The location of the indexed item.
		/// </summary>
		string Location { get; set; }

		/// <summary>
		/// The number of times the item was been launched.
		/// </summary>
		Int64 LaunchCount { get; set; }

		/// <summary>
		/// The icon associated with the location.
		/// </summary>
		ImageSource IconImage { get; }
	}
}
