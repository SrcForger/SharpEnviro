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
            cds.cbData = module.Length + message.Length + 3;
            cds.lpData = Marshal.StringToHGlobalAnsi(a);
            try
            {
                IntPtr wnd = PInvoke.FindWindow("TSharpEDebugWnd", null);
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
            cds.cbData = module.Length + message.Length + 3;
            cds.lpData = Marshal.StringToHGlobalAnsi(a);
            try
            {
                IntPtr wnd = PInvoke.FindWindow("TSharpConsoleWnd", null);
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
            cds.cbData = module.Length + message.Length + 3;
            cds.lpData = Marshal.StringToHGlobalAnsi(a);
            try
            {
                IntPtr wnd = PInvoke.FindWindow("TSharpConsoleWnd", null);
                PInvoke.SendMessage(wnd, PInvoke.WM_COPYDATA, (IntPtr)MessageType, ref cds);
            }
            finally
            {
                Marshal.FreeHGlobal(cds.lpData);
            }
        }

        // message types to use with DebugEx
        public static int DMT_INFO = 0;
        public static int DMT_STATUS = 1;
        public static int DMT_WARN = 2;
        public static int DMT_ERROR = 3;
        public static int DMT_TRACE = 4;
        public static int DMT_NONE = -1;
    }
}
