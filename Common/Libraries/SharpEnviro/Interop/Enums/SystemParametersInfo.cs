using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpEnviro.Interop.Enums
{
    [Flags]
    public enum MinimizedMetricsArrangement
    {
        BottomLeft = 0,
        BottomRight = 1,
        TopLeft = 2,
        TopRight = 3,
        Left = 0,
        Right = 0,
        Up = 4,
        Down = 4,
        Hide = 8
    }
}
