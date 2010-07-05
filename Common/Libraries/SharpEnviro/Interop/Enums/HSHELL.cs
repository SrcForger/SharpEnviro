using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpEnviro.Interop.Enums
{
    /// <summary>
    /// wParam of a WM_SHELLHOOK message describing the type of the shell message
    /// </summary>
    public enum HSHELL
    {
        /// <summary>
        /// New window created
        /// </summary>
        WINDOWCREATED = 1,

        /// <summary>
        /// Window destroyed
        /// </summary>
        WINDOWDESTROYED = 2,

        ACTIVATESHELLWINDOW = 3,

        /// <summary>
        /// A window is being activated
        /// </summary>
        WINDOWACTIVATED = 4,

        /// <summary>
        /// Window is minimized or restored, not that the associated lParam given with the message
        /// is NOT the window handle. It Points to a shellhookinfo struct.
        /// </summary>
        GETMINRECT = 5,

        /// <summary>
        /// Window caption is changed
        /// </summary>
        REDRAW = 6,

        TASKMAN = 7,
        LANGUAGE = 8,
        ACCESSIBILITYSTATE = 11,

        /// <summary>
        /// AppCommand message (such as multimedia keys on a keyboard pressed)
        /// </summary>
        APPCOMMAND = 12,

        WINDOWREPLACED = 13,

        HIGHBIT = 0x8000,

        /// <summary>
        /// The taskbar item of a window is flashing
        /// </summary>
        FLASHING = REDRAW | HIGHBIT,

        RUDEAPPACTIVATED = WINDOWACTIVATED | HIGHBIT
    }
}
