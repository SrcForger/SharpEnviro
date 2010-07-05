using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace SharpEnviro.Interop.Structs
{
    [StructLayout(LayoutKind.Sequential)]
    public struct ShellHookInfo
    {
        public IntPtr hWnd;
        public RECT rc;
    }
}
