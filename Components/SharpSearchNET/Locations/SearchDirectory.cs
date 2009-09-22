using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Runtime.InteropServices;
using SharpLinkLauncherNET.Interop;
using System.Threading;

namespace SharpSearchNET.Locations
{
    public class SearchDirectory : ISearchLocation
    {
        string name;
        string description;
        string path;
        string searchQuery;

        public string Name
        {
            get { return name; }
        }

        public string Description
        {
            get { return description; }
        }

        public void DoSearch(string query, List<SearchResult> list, ISearchCallback searchCallback)
        {
            searchQuery = query.ToLower();
            if (!Directory.Exists(path))
                return;

            Stack<string> stack = new Stack<string>();
            List<string> files = new List<string>();
            stack.Push(path);

            while (stack.Count > 0)
            {
                string currentDirectory = stack.Pop();

                try
                {
                    files.Clear();
                    files.AddRange(Directory.GetFiles(currentDirectory, "*.exe"));
                    files.AddRange(Directory.GetFiles(currentDirectory, "*.lnk"));
                    foreach (string file in files) 
                    {
                        try
                        {
                            if ((File.GetAttributes(file) & FileAttributes.Hidden) != FileAttributes.Hidden)
                            {
                                string fileName = Path.GetFileName(file);
                                string filePath = file;

                                if (Path.GetExtension(filePath).CompareTo(".lnk") == 0) 
                                {   // Resolve if it's a shortcut
                                    string resolvedFilePath = COM.ResolveShortcut(filePath);
                                    if (File.Exists(resolvedFilePath))
                                    {   // Resolved Path seems valid, use it instead
                                        filePath = resolvedFilePath;
                                    }
                                }
                                FileVersionInfo info = FileVersionInfo.GetVersionInfo(filePath);
                                if ((fileName.ToLower().Contains(searchQuery)) || info.FileDescription.ToLower().Contains(searchQuery))
                                {   // Search if filename or filedescription contain the search query
                                    SearchResult item = new SearchResult(Path.GetFileNameWithoutExtension(fileName), info.FileDescription, file);
                                    list.Add(item);
                                    if (searchCallback != null)
                                        searchCallback.NewResult(item);
                                }
                            }
                        }
                        catch
                        {
                            // Error opening file
                        }
                    }

                    foreach (string dir in Directory.GetDirectories(currentDirectory))
                    {
                        stack.Push(dir);
                    }
                }
                catch
                {
                    // Error when opening directory (acccess rights, etc.)
                }
            }
        }

        [DllImport("shell32.dll")]
        static extern bool SHGetSpecialFolderPath(IntPtr hwndOwner, StringBuilder lpszPath, CSIDL nFolder, bool fCreate);

        enum CSIDL
        {
            COMMON_STARTMENU = 0x0016,
            COMMON_DESKTOPDIRECTORY = 0x0019
        }

        public static string ParseEnvironmentVars(string input)
        {
            StringBuilder allUsersStartMenu = new StringBuilder(255);
            StringBuilder allUsersDesktop = new StringBuilder(255);
            SHGetSpecialFolderPath(IntPtr.Zero, allUsersStartMenu, CSIDL.COMMON_STARTMENU, false);
            SHGetSpecialFolderPath(IntPtr.Zero, allUsersDesktop, CSIDL.COMMON_DESKTOPDIRECTORY, false);
         
            input = input.Replace("{UserStartMenu}",Environment.GetFolderPath(Environment.SpecialFolder.StartMenu));
            input = input.Replace("{UserDesktop}", Environment.GetFolderPath(Environment.SpecialFolder.Desktop));
            input = input.Replace("{AllUsersStartMenu}", allUsersStartMenu.ToString());
            input = input.Replace("{AllUsersDestop}", allUsersDesktop.ToString());
            

            return input;
        }

        public SearchDirectory(string name, string description, string path)
        {
            this.name = name;
            this.description = description;
            this.path = ParseEnvironmentVars(path);
        }

        public string SearchQuery
        {
            get
            {
                return searchQuery;
            }
            set
            {
                searchQuery = value;
            }
        } 

        public void FilterList(List<SearchResult> list, ISearchCallback searchCallback)
        {
            List<SearchResult> remove = new List<SearchResult>();   
            foreach (SearchResult searchResult in list)
            {
                if ((!searchResult.Name.ToLower().Contains(searchQuery)) && (!searchResult.Description.ToLower().Contains(searchQuery)))
                    remove.Add(searchResult);
            }
            foreach (SearchResult searchResult in remove)
            {
                list.Remove(searchResult);
                if (searchCallback != null)
                    searchCallback.RemoveResult(searchResult);
            }
        }
    }
}
