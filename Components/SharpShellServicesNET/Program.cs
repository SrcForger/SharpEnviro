using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using Microsoft.Win32;

namespace SharpEnviro.ShellServices
{
    // IOleCommandTarget definition
    [ComImport]
    [Guid("B722BCCB-4E68-101B-A2BC-00AA00404770")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IOleCommandTarget
    {
        int QueryStatus([In, MarshalAs(UnmanagedType.Struct)] ref Guid pguidCmdGroup, [MarshalAs(UnmanagedType.U4)] int cCmds, IntPtr prgCmds, IntPtr pCmdText);
        int Exec(ref Guid pguidCmdGroup, int nCmdID, int nCmdExecOpt, ref object pvaIn, ref object pvaOut);
    }

    // Vista shell service objects
    [ComImport]
    [Guid("35CEC8A3-2BE6-11D2-8773-92E220524153")]
    class SSOVista
    {
    }

    class ShellServiceObjects
    {
        // Import GetMessage function from user32.dll
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax);

        // Window Message declaration
        public const int WM_ENDSESSION = 0x0016;
        public const int WM_CLOSE = 0x0010;
        public const int WM_QUIT = 0x0012;

        private static Guid CGID_ShellServiceObject = new Guid("000214D2-0000-0000-C000-000000000046");

        // Load Shell Services on Vista and Win7
        static void LoadShellServicesVista()
        {
            SSOVista pSSOVista = new SSOVista();
            IOleCommandTarget pCmdTarget = (IOleCommandTarget)pSSOVista;
            Object o = new object();
            pCmdTarget.Exec(ref CGID_ShellServiceObject, 2, 0, ref o, ref o);
        }

        // Load Shell Services the old (XP and before) way
        static void LoadShellServiceObjectsXP()
        {
            RegistryKey key = Registry.LocalMachine;
            key = key.OpenSubKey("Software\\Microsoft\\Windows\\CurrentVersion\\ShellServiceObjectDelayLoad");
            if (key != null)
            {
                // get all shell service objects from the registry key
                foreach (string valueName in key.GetValueNames())
                {
                    // get guid and remove possible { } characters
                    String regguid = key.GetValue(valueName).ToString();
                    regguid = regguid.Replace("{", "");
                    regguid = regguid.Replace("}", "");

                    // load the sso
                    Guid regsso = new Guid(regguid);
                    Type regssoType = Type.GetTypeFromCLSID(regsso, false);
                    if (regssoType.IsCOMObject)
                    {
                        object regssoObj = Activator.CreateInstance(regssoType);
                        IOleCommandTarget pCmdTarget = (IOleCommandTarget)regssoObj;
                        Object o = new object();
                        pCmdTarget.Exec(ref CGID_ShellServiceObject, 2, 0, ref o, ref o);
                    }
                }
            }
        }

        static void Main(string[] args)
        {
            // check Operating system version
            OperatingSystem osInfo = Environment.OSVersion;
            if (osInfo.Platform == System.PlatformID.Win32NT)
            {
                if (osInfo.Version.Major >= 6)
                    LoadShellServicesVista();
                LoadShellServiceObjectsXP();

                // Loop through message until a quit message is received
                MSG lpMsg;
                while (GetMessage(out lpMsg, IntPtr.Zero, 0, 0) == true)
                {
                    if ((lpMsg.message == WM_ENDSESSION) || (lpMsg.message == WM_CLOSE) || (lpMsg.message == WM_QUIT))
                    {
                        break;
                    }
                }
            }
        }
    }
}
