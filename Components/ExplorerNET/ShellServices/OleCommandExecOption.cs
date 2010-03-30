using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Explorer.ShellServices
{
	/// <summary>
	/// Ole command execution options.
	/// </summary>
	enum OleCommandExecOption
	{
		/// <summary>
		/// Prompt the user for input or not, whichever is the default behavior.
		/// </summary>
		DoDefault = 0,

		/// <summary>
		/// Execute the command after obtaining user input.
		/// </summary>
		PromptUser = 1,

		/// <summary>
		/// Execute the command without prompting the user. For example, clicking the Print toolbar button causes a document to be immediately printed without user input.
		/// </summary>
		DontPromptUser = 2,

		/// <summary>
		/// Show help for the corresponding command, but do not execute.
		/// </summary>
		ShowHelp = 3
	}
}
