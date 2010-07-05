using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Runtime.InteropServices;

namespace SharpEnviro.Interop.Structs
{
    [Serializable, StructLayout(LayoutKind.Sequential)]
    public struct RECT
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;

        public RECT(int left_, int top_, int right_, int bottom_)
        {
            Left = left_;
            Top = top_;
            Right = right_;
            Bottom = bottom_;
        }

        public int Height { get { return Bottom - Top; } }
        public int Width { get { return Right - Left; } }
        public Size Size { get { return new Size(Width, Height); } }

        public Point Location { get { return new Point(Left, Top); } }

        // Handy method for converting to a System.Drawing.Rectangle
        public Rectangle ToRectangle()
        { return Rectangle.FromLTRB(Left, Top, Right, Bottom); }

        public static RECT FromRectangle(Rectangle rectangle)
        {
            return new RECT(rectangle.Left, rectangle.Top, rectangle.Right, rectangle.Bottom);
        }

        public override int GetHashCode()
        {
            return Left ^ ((Top << 13) | (Top >> 0x13))
              ^ ((Width << 0x1a) | (Width >> 6))
              ^ ((Height << 7) | (Height >> 0x19));
        }

        #region Operator overloads

        public static implicit operator Rectangle(RECT rect)
        {
            return rect.ToRectangle();
        }

        public static implicit operator RECT(Rectangle rect)
        {
            return FromRectangle(rect);
        }

        #endregion
    }
}
