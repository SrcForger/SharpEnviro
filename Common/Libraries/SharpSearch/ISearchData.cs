using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpSearch
{
	/// <summary>
	/// The search data interface for items stored in or retrieved from the databse.
	/// </summary>
	public interface ISearchData
	{
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
	}
}
