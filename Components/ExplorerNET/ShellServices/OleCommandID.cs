using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Explorer.ShellServices
{
	/// <summary>
	/// Specifies which standard command is to be executed.
	/// A single value from this enumeration is passed in the nCmdID argument of IOleCommandTarget::Exec. 
	/// </summary>
	enum OleCommandID
	{
		/// <summary>
		/// File menu, Open command
		/// </summary>
		Open = 1,

		/// <summary>
		/// File menu, New command
		/// </summary>
		New = 2,

		/// <summary>
		/// File menu, Save command
		/// </summary>
		Save = 3,

		/// <summary>
		/// File menu, Save As command
		/// </summary>
		SaveAs = 4,

		/// <summary>
		/// File menu, Save Copy As command
		/// </summary>
		SaveCopyAs = 5,

		/// <summary>
		/// File menu, Print command
		/// </summary>
		Print = 6,

		/// <summary>
		/// File menu, Print Preview command
		/// </summary>
		PrintPreview = 7,

		/// <summary>
		/// File menu, Page Setup command
		/// </summary>
		PageSetup = 8,

		/// <summary>
		/// Tools menu, Spelling command
		/// </summary>
		Spell = 9,

		/// <summary>
		/// File menu, Properties command
		/// </summary>
		Properties = 10,

		/// <summary>
		/// Edit menu, Cut command
		/// </summary>
		Cut = 11,

		/// <summary>
		/// Edit menu, Copy command
		/// </summary>
		Copy = 12,

		/// <summary>
		/// Edit menu, Paste command
		/// </summary>
		Paste = 13,

		/// <summary>
		/// Edit menu, Paste Special command
		/// </summary>
		PasteSpecial = 14,

		/// <summary>
		/// Edit menu, Undo command
		/// </summary>
		Undo = 15,

		/// <summary>
		/// Edit menu, Redo command
		/// </summary>
		Redo = 16,

		/// <summary>
		/// Edit menu, Select All command
		/// </summary>
		SelectAll = 17,

		/// <summary>
		/// Edit menu, Clear command
		/// </summary>
		ClearSelection = 18,

		/// <summary>
		/// View menu, Zoom command (see below for details.)
		/// </summary>
		Zoom = 19,

		/// <summary>
		/// Retrieves zoom range applicable to View Zoom (see below for details.)
		/// </summary>
		GetZoomRange = 20,

		/// <summary>
		/// Informs the receiver, usually a frame, of state changes. The receiver can then query the status of the commands whenever convenient.
		/// </summary>
		UpdateCommands = 21,

		/// <summary>
		/// Asks the receiver to refresh its display. Implemented by the document/object.
		/// </summary>
		Refresh = 22,

		/// <summary>
		/// Stops all current processing. Implemented by the document/object.
		/// </summary>
		Stop = 23,

		/// <summary>
		/// View menu, Toolbars command. Implemented by the document/object to hide its toolbars. 
		/// </summary>
		HideToolbars = 24,

		/// <summary>
		/// Sets the maximum value of a progress indicator if one is owned by the receiving object, usually a frame. The minimum value is always zero. 
		/// </summary>
		SetProgressMax = 25,

		/// <summary>
		/// Sets the current value of a progress indicator if one is owned by the receiving object, usually a frame. 
		/// </summary>
		SetProgressPos = 26,

		/// <summary>
		/// Sets the text contained in a progress indicator if one is owned by the receiving object, usually a frame.
		/// If the receiver currently has no progress indicator, this text should be displayed in the status bar (if one exists) as with IOleInPlaceFrame::SetStatusText.
		/// </summary>
		SetProgressText = 27,

		/// <summary>
		/// Sets the title bar text of the receiving object, usually a frame.
		/// </summary>
		SetTitle = 28,

		/// <summary>
		/// Called by the object when downloading state changes.
		/// Takes a VT_BOOL parameter, which is TRUE if the object is downloading data and FALSE if it not.
		/// Primarily implemented by the frame.
		/// </summary>
		SetDownloadState = 29,

		/// <summary>
		/// Stops the download when executed.
		/// Typically, this command is propagated to all contained objects.
		/// When queried, sets MSOCMDF_ENABLED. Implemented by the document/object.
		/// </summary>
		StopDownload = 30,

		/// <summary>
		/// Edit menu, Find command
		/// </summary>
		Find = 32,

		/// <summary>
		/// Edit menu, Delete command
		/// </summary>
		Delete = 33,

		/// <summary>
		/// File menu, updated Print command
		/// </summary>
		Print2 = 49,

		/// <summary>
		/// File menu, updated Print Preview command
		/// </summary>
		PrintPreview2 = 50,

		/// <summary>
		/// Indicates that a page action has been blocked.
		/// PageActionBlocked is designed for use with applications that host the Internet Explorer WebBrowser control to implement their own UI.
		/// </summary>
		PageActionBlocked = 55,

		/// <summary>
		/// Specifies which actions are displayed in the Internet Explorer notification band.
		/// </summary>
		PageActionUIQuery = 56,

		/// <summary>
		/// Causes the Internet Explorer WebBrowser control to focus its default notification band. Hosts can send this command at any time.
		/// The return value is S_OK if the band is present and is in focus, or S_FALSE otherwise.
		/// </summary>
		FocusViewControls = 57,

		/// <summary>
		/// This notification event is provided for applications that display Internet Explorers default notification band implementation.
		/// By default, when the user presses the ALT-N key combination, Internet Explorer treats it as a request to focus the notification band.
		/// </summary>
		FocusViewControlsQuery = 58,

		/// <summary>
		/// Causes the Internet Explorer WebBrowser control to show the Information Bar menu.
		/// </summary>
		ShowPageActionMenu = 59,

		/// <summary>
		/// Causes the Internet Explorer WebBrowser control to create an entry at the current Travel Log offset.
		/// The Docobject should implement ITravelLogClient  and IPersist  interfaces, which are used by the Travel Log
		/// as it processes this command with calls to GetWindowData and GetPersistID, respectively.
		/// </summary>
		AddTravelEntry = 60,

		/// <summary>
		/// Called when LoadHistory is processed to update the previous Docobject state.
		/// For synchronous handling, this command can be called before returning from the LoadHistory call.
		/// For asynchronous handling, it can be called later.
		/// </summary>
		UpdateTravelEntry = 61,

		/// <summary>
		/// Updates the state of the browser's Back and Forward buttons.
		/// </summary>
		UpdateBackForwardState = 62,

		/// <summary>
		/// Windows Internet Explorer 7 and later.
		/// Sets the zoom factor of the browser.
		/// Takes a VT_I4 parameter in the range of 10 to 1000 (percent).
		/// </summary>
		Optical_Zoom = 63,

		/// <summary>
		/// Windows Internet Explorer 7 and later.
		/// Retrieves the minimum and maximum browser zoom factor limits.
		/// Returns a VT_I4 parameter; the LOWORD is the minimum zoom factor, the HIWORD is the maximum.
		/// </summary>
		Optical_GetZoomRange = 64,

		/// <summary>
		/// Windows Internet Explorer 7 and later.
		/// Notifies the Internet Explorer WebBrowser control of changes in window states, such as losing focus, or becoming hidden or minimized.
		/// The host indicates what has changed by setting OLECMDID_WINDOWSTATE_FLAG option flags in nCmdExecOpt.
		/// </summary>
		WindowStateChanged = 65,

		/// <summary>
		/// Windows Internet Explorer 8 with Windows Vista.
		/// Has no effect with Windows Internet Explorer 8 with Windows XP.
		/// Notifies Trident to use the indicated Install Scope to install the ActiveX Control specified by the indicated Class ID.
		/// For more information, see the Remarks section.
		/// </summary>
		ActiveXInstallScope = 66,

		/// <summary>
		/// Internet Explorer 8.
		/// Unlike OLECMDID_UPDATETRAVELENTRY, this updates a Travel Log entry that is not initialized from a previous Docobject state.
		/// While this command is not called from IPersistHistory::LoadHistory, it can be called separately to save browser state that can be used later to recover from a crash.
		/// </summary>
		UpdateTravelEntry_DataRecovery = 67 
	}
}
