using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using SharpEnviro.Interop.Enums;
using SharpEnviro.Interop.Structs;

namespace SharpEnviro.Interop
{
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
}
