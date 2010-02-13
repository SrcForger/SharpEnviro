using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

public class NativeWindowEx : NativeWindow
{
    public delegate void MessageReceived(ref Message m);
    public event MessageReceived msgReceived;

    public ClassParams ClassParams;
    public CreateParamsEx CreateParams;

    protected override void WndProc(ref Message m)
    {
        base.WndProc(ref m);
        if (msgReceived != null)
            msgReceived(ref m);
    }

    public NativeWindowEx(ClassParams classParams, CreateParamsEx createParams)
    {
        this.ClassParams = classParams;
        this.CreateParams = createParams;
        RegisterClass();
        CreateHandle();
    }

    ~NativeWindowEx()
    {
        if (Handle.ToInt64() != 0)
            PInvoke.DestroyWindow(this.Handle);
        UnregisterClass();
    }

    private void RegisterClass()
    {
        WNDCLASSEX wndclass = new WNDCLASSEX();
        wndclass.cbSize = Marshal.SizeOf(typeof(WNDCLASSEX));
        wndclass.lpszClassName = ClassParams.Name;
        wndclass.lpfnWndProc = ClassParams.WindowProc;
        wndclass.hInstance = CreateParams.HInstance;
        if (PInvoke.RegisterClassEx(ref wndclass) == 0)
            throw new System.ComponentModel.Win32Exception();
    }

    private void UnregisterClass()
    {
        PInvoke.UnregisterClass(ClassParams.Name, CreateParams.HInstance);
    }

    public override void CreateHandle(CreateParams cp)
    {
        base.CreateHandle(cp);
    }

    public void CreateHandle()
    {
        IntPtr h;
        h = PInvoke.CreateWindowEx((uint)CreateParams.ExStyle,
                                                 CreateParams.ClassName,
                                                 CreateParams.Caption,
                                                 (uint)CreateParams.Style,
                                                 CreateParams.X,
                                                 CreateParams.Y,
                                                 CreateParams.Width,
                                                 CreateParams.Height,
                                                 CreateParams.Parent,
                                                 (IntPtr)0,
                                                 CreateParams.HInstance,
                                                 (IntPtr)0); // no idea how to convert 'object param' properly
        this.AssignHandle(h);
    }
}

#region Enums
[Flags]
public enum ClassStyles : uint
{
    CS_VREDRAW = 0x0001,
    CS_HREDRAW = 0x0002,
    CS_DBLCLKS = 0x0008,
    CS_OWNDC = 0x0020,
    CS_CLASSDC = 0x0040,
    CS_PARENTDC = 0x0080,
    CS_NOCLOSE = 0x0200,
    CS_SAVEBITS = 0x0800,
    CS_BYTEALIGNCLIENT = 0x1000,
    CS_BYTEALIGNWINDOW = 0x2000,
    CS_GLOBALCLASS = 0x4000,
    CS_IME = 0x00010000,
    CS_DROPSHADOW = 0x00020000
}
#endregion

#region Structs
public delegate IntPtr WndProc(IntPtr hWnd, uint uMsgm, IntPtr wParam, IntPtr lParam);

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
public struct WNDCLASSEX
{
    [MarshalAs(UnmanagedType.U4)]
    public int cbSize;
    [MarshalAs(UnmanagedType.U4)]
    public int style;
    public WndProc lpfnWndProc;
    public int cbClsExtra;
    public int cbWndExtra;
    public IntPtr hInstance;
    public IntPtr hIcon;
    public IntPtr hCursor;
    public IntPtr hbrBackground;
    public string lpszMenuName;
    public string lpszClassName;
    public IntPtr hIconSm;
}
#endregion

#region PInvoke
public static class PInvoke
{
    #region CreateWindowEx and Class Registration

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.U2)]
    public static extern UInt16 RegisterClassEx([In] ref WNDCLASSEX lpwcx);

    [DllImport("user32.dll")]
    public static extern bool UnregisterClass(string lpClassName, IntPtr hInstance);

    [DllImport("user32.dll")]
    public static extern IntPtr CreateWindowEx(
       uint dwExStyle,
       string lpClassName,
       string lpWindowName,
       uint dwStyle,
       int x,
       int y,
       int nWidth,
       int nHeight,
       IntPtr hWndParent,
       IntPtr hMenu,
       IntPtr hInstance,
       IntPtr lpParam);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool DestroyWindow(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern IntPtr DefWindowProc(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);

    public static int WS_EX_TOOLWINDOW = 0x00000080;

    #endregion
}
#endregion

public class CreateParamsEx : CreateParams
{
    public IntPtr HInstance;

    public CreateParamsEx()
    {
        HInstance = Marshal.GetHINSTANCE(typeof(NativeWindowEx).Module);
    }
}

public class ClassParams
{
    public ClassStyles Styles;
    public String Name;
    public WndProc WindowProc;
}
