using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

using SharpEnviro.Interop;

namespace SharpEnviro
{
    /// <summary>
    /// SharpEnviro debug
    /// </summary>
    /// 
    public static class SharpDebug
    {
        // Send message to the debug service
        public static void DebugService(string module, string message, int MessageType)
        {
            string a = string.Join("||", new string[] { module, message });

            PInvoke.COPYDATASTRUCT cds = new PInvoke.COPYDATASTRUCT();
            cds.dwData = IntPtr.Zero;
            cds.cbData = a.Length + 1;
            cds.lpData = Marshal.StringToHGlobalAnsi(a);
            try
            {
                IntPtr wnd = PInvoke.FindWindow("TSharpEDebugWnd", null);
                if (wnd != IntPtr.Zero)
                    PInvoke.SendMessage(wnd, PInvoke.WM_COPYDATA, (IntPtr)MessageType, ref cds);
            }
            finally
            {
                Marshal.FreeHGlobal(cds.lpData);
            }
        }

        // Send message to SharpConsole
        public static void Debug(string module, string message)
        {
            if (module.Length > 0)
                module += ": ";
            else
                module = ": ";

            message = "<B><FONT COLOR=$B06C48>" + module + "</FONT></B>" + message;

            string a = string.Join("||", new string[] { module, message });

            PInvoke.COPYDATASTRUCT cds = new PInvoke.COPYDATASTRUCT();
            cds.dwData = IntPtr.Zero;
            cds.cbData = a.Length + 1;
            cds.lpData = Marshal.StringToHGlobalAnsi(a);
            try
            {
                IntPtr wnd = PInvoke.FindWindow("TSharpConsoleWnd", null);
                if(wnd != IntPtr.Zero)
                    PInvoke.SendMessage(wnd, PInvoke.WM_COPYDATA, IntPtr.Zero, ref cds);
            }
            finally
            {
                Marshal.FreeHGlobal(cds.lpData);
            }
        }

        // Send message to SharpConsole with MessageType
        public static void DebugEx(string module, string message, int MessageType)
        {
            if (MessageType == DMT_ERROR)
                DebugService(module, message, MessageType);

            if (module.Length > 0)
                module += ": ";
            else
                module = ": ";

            message = "<B><FONT COLOR=$B06C48>" + module + "</FONT></B>" + message;

            string a = string.Join("||", new string[] { module, message });

            PInvoke.COPYDATASTRUCT cds = new PInvoke.COPYDATASTRUCT();
            cds.dwData = IntPtr.Zero;
            cds.cbData = a.Length + 1;
            cds.lpData = Marshal.StringToHGlobalAnsi(a);
            try
            {
                IntPtr wnd = PInvoke.FindWindow("TSharpConsoleWnd", null);
                if (wnd != IntPtr.Zero)
                    PInvoke.SendMessage(wnd, PInvoke.WM_COPYDATA, (IntPtr)MessageType, ref cds);
            }
            finally
            {
                Marshal.FreeHGlobal(cds.lpData);
            }
        }

        public static void Info(string module, string msg, int MessageType = DMT_INFO)
        {
            DebugEx(module, msg, MessageType);
        }

        public static void Exception(string module, string msg, Exception exc, int MessageType = DMT_ERROR)
        {
            DebugEx(module, msg + " - " + exc.Message, MessageType);
        }

        // message types to use with DebugEx
        public const int DMT_INFO = 0;
        public const int DMT_STATUS = 1;
        public const int DMT_WARN = 2;
        public const int DMT_ERROR = 3;
        public const int DMT_TRACE = 4;
        public const int DMT_NONE = -1;
    }
}
