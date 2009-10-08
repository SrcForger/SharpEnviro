using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpSearchNET
{
    /// <summary>
    /// Exit codes for the sharpe search application
    /// </summary>
    enum ExitCode : int
    {
        /// <summary>
        /// Started and closed properly.
        /// </summary>
        Success = 0,

        /// <summary>
        /// Already Running (MuteX check failed)
        /// </summary>
        AlreadyRunning = -1,

        /// <summary>
        /// No or invalid -x and -y arguments
        /// </summary>
        InvalidPosition = -2,

        /// <summary>
        /// Connection to the database failed
        /// </summary>
        DatabaseConnectionFailed = -3,
    }
}
