using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpEnviro.Interop.Enums
{
    /// <summary>
    /// RegisterShellHook() parameter
    /// </summary>
    public enum RSH : uint
    {
        UNREGISTER = 0,

        REGISTER = 1,

        TASKMGR = 2
    }
}
