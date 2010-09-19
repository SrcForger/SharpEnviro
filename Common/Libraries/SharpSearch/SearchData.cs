using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace SharpSearch
{
	/// <summary>
	/// A class for search results.
	/// </summary>
	public class SearchData :
		ISearchData,
		IDisposable
	{
		#region Constructors

		/// <summary>
		/// Constructor.
		/// </summary>
		public SearchData()
		{
		}

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
		/// The row identifier for the search data in the database.
		/// </summary>
		public Int64 RowID { get; set; }

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

		/// <summary>
		/// The number of times the item was been launched.
		/// </summary>
		public Int64 LaunchCount { get; set; }

		/// <summary>
		/// The icon associated with the location.
		/// </summary>
		public ImageSource IconImage
		{
			get
			{
				if (_icon == null)
					using (Icon ico = Icon.ExtractAssociatedIcon(Location))
					{
						_icon = Imaging.CreateBitmapSourceFromHIcon(
							ico.Handle,
							Int32Rect.Empty,
							BitmapSizeOptions.FromEmptyOptions());
					}

				return _icon;
			}
		}

		#endregion ISearchData Members

		#region privates

		private ImageSource _icon = null;

		#endregion privates

		#region IDisposable Members

		/// <summary>
		/// Disposes of the object.
		/// </summary>
		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}

		/// <summary>
		/// Disposes of the object.
		/// </summary>
		/// <param name="disposing"></param>
		protected virtual void Dispose(bool disposing)
		{
			_icon = null;
		}

		#endregion IDisposable Members
	}
}
