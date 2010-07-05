using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace SharpSearch
{
	/// <summary>
	/// A location in which we should search for items to be indexed.
	/// </summary>
	[Serializable]
	public class SearchLocation
	{
		#region Constructors

		/// <summary>
		/// Constructor.
		/// </summary>
		public SearchLocation()
		{
		}

		/// <summary>
		/// Creates a new instance using the supplied values.
		/// </summary>
		/// <param name="name"></param>
		/// <param name="description"></param>
		/// <param name="searchPath"></param>
		public SearchLocation(string name, string description, string searchPath)
		{
			Name = name;
			Description = description;
			SearchPath = searchPath;
		}

		#endregion Constructors

		#region publics

		/// <summary>
		/// The name of the location.
		/// </summary>
		[XmlAttribute]
		public string Name { get; set; }

		/// <summary>
		/// A description for the location.
		/// </summary>
		[XmlAttribute]
		public string Description { get; set; }

		/// <summary>
		/// The path that should be searched.
		/// </summary>
		[XmlAttribute]
		public string SearchPath { get; set; }

		#endregion publics
	}
}
