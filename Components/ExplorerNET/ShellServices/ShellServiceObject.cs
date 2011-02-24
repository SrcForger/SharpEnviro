using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace Explorer.ShellServices
{
	[ComImport]
	[Guid("35CEC8A3-2BE6-11D2-8773-92E220524153")]
    public class ShellServiceObject
	{
	}

    public class ShellServiceObjectDisposable : IDisposable
    {
        private bool disposed = false;
        private ShellServiceObject obj = null;

        public ShellServiceObject Object
        {
            get { return obj; }
            set { obj = value; }
        }

        ~ShellServiceObjectDisposable()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposeManagedResources)
        {
            // process only if mananged and unmanaged resources have
            // not been disposed of.
            if (!this.disposed)
            {
                if (disposeManagedResources)
                {
                    // dispose managed resources
                    if (obj != null)
                    {
                        Marshal.FinalReleaseComObject(obj);
                        obj = null;
                    }
                }
                // dispose unmanaged resources
                disposed = true;
            }
        }
    }
}
