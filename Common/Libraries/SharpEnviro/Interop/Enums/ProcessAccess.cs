using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SharpEnviro.Interop.Enums
{
    [Flags()]
    public enum ProcessAccess : int
    {
        /// <summary>Specifies all possible access flags for the process object.</summary>
        AllAccess = CreateThread | DuplicateHandle | QueryInformation | SetInformation | Terminate | VMOperation | VMRead | VMWrite | Synchronize,
        /// <summary>Enables usage of the process handle in the CreateRemoteThread function to create a thread in the process.</summary>
        CreateThread = 0x2,
        /// <summary>Enables usage of the process handle as either the source or target process in the DuplicateHandle function to duplicate a handle.</summary>
        DuplicateHandle = 0x40,
        /// <summary>Enables usage of the process handle in the GetExitCodeProcess and GetPriorityClass functions to read information from the process object.</summary>
        QueryInformation = 0x400,
        /// <summary>Enables usage of the process handle in the SetPriorityClass function to set the priority class of the process.</summary>
        SetInformation = 0x200,
        /// <summary>Enables usage of the process handle in the TerminateProcess function to terminate the process.</summary>
        Terminate = 0x1,
        /// <summary>Enables usage of the process handle in the VirtualProtectEx and WriteProcessMemory functions to modify the virtual memory of the process.</summary>
        VMOperation = 0x8,
        /// <summary>Enables usage of the process handle in the ReadProcessMemory function to' read from the virtual memory of the process.</summary>
        VMRead = 0x10,
        /// <summary>Enables usage of the process handle in the WriteProcessMemory function to write to the virtual memory of the process.</summary>
        VMWrite = 0x20,
        /// <summary>Enables usage of the process handle in any of the wait functions to wait for the process to terminate.</summary>
        Synchronize = 0x100000
    }
}
