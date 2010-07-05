using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace SharpEnviro.Interop.Structs
{
    [StructLayout(LayoutKind.Sequential)]
    public struct MinimizedMetrics
    {
        public uint cbSize;
        public int iWidth;
        public int iHorzGap;
        public int iVertGap;
        public SharpEnviro.Interop.Enums.MinimizedMetricsArrangement iArrange;
    }
}
