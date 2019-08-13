%% This is an -*- erlang -*- file.
%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2010-2016. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%
%% %CopyrightEnd%

{application, wx,
 [{description, "Yet another graphics system"},
  {vsn, "1.8.6"},
  {modules,
   [
    %% Generated modules
  wxBrush, wxAuiNotebookEvent, wxMaximizeEvent, wxStaticBoxSizer, wxUpdateUIEvent, wxIcon, wxBitmapButton, wxImage, wxGraphicsContext, wxPreviewFrame, wxColourData, wxFileDialog, wxFlexGridSizer, wxPrintDialogData, wxFocusEvent, wxAuiNotebook, wxMouseCaptureChangedEvent, wxDCOverlay, wxClipboardTextEvent, wxChoicebook, wxSystemOptions, wxGridCellFloatRenderer, wxWindowDC, wxStatusBar, wxInitDialogEvent, wxEvent, wxTaskBarIconEvent, wxGraphicsObject, wxPrintout, wxDateEvent, wxSysColourChangedEvent, wxGraphicsPath, wxLocale, wxGraphicsMatrix, wxBitmap, wxRegion, wxCalendarCtrl, wxSizerItem, wxFrame, wxNavigationKeyEvent, wxGraphicsRenderer, wxGridCellBoolRenderer, wxMouseCaptureLostEvent, wxTextEntryDialog, wxIdleEvent, wxStyledTextCtrl, wxListItem, wxSpinCtrl, wxGLCanvas, wxMDIClientWindow, wxMDIChildFrame, wxStdDialogButtonSizer, wxPrintPreview, wxPrintData, wxDirPickerCtrl, wxKeyEvent, wxEraseEvent, wxRadioBox, wxCalendarDateAttr, wxGridCellEditor, wxPalette, wxTreebook, wxSizeEvent, wxLogNull, wx_misc, wxPreviewCanvas, wxTextAttr, wxButton, wxScrollWinEvent, wxGraphicsBrush, wxWindowDestroyEvent, wxSetCursorEvent, wxFontDialog, wxMenuItem, wxChoice, wxControl, wxActivateEvent, wxGraphicsFont, wxStaticText, wxIconizeEvent, wxJoystickEvent, wxPrinter, wxStaticBitmap, wxGridBagSizer, wxGridSizer, wxScrollEvent, wxWindowCreateEvent, wxSashLayoutWindow, wxGridCellFloatEditor, wxStyledTextEvent, wxPrintDialog, wxStaticBox, wxBufferedDC, wxListCtrl, wxCalendarEvent, wxGauge, wxGridCellTextEditor, wxDataObject, wxShowEvent, wxBitmapDataObject, wxFindReplaceDialog, wxGridCellStringRenderer, wxTextDataObject, wxStaticLine, wxMiniFrame, wxListEvent, wxDialog, wxTopLevelWindow, wxPaintDC, wxTreeCtrl, wxScreenDC, wxPopupWindow, wxChildFocusEvent, wxColourPickerCtrl, wxFilePickerCtrl, wxPostScriptDC, wxGrid, wxAuiSimpleTabArt, wxSashEvent, wxScrolledWindow, wxSizerFlags, wxMask, wxFontData, wxSplitterEvent, wxScrollBar, wxMenuEvent, wxCheckBox, wxQueryNewPaletteEvent, wxListItemAttr, wxMirrorDC, wxAuiManager, wxFileDirPickerEvent, wxBoxSizer, wxClipboard, wxMouseEvent, wxMenu, wxAuiPaneInfo, wxPaintEvent, wxSplitterWindow, wxProgressDialog, wxGridCellNumberEditor, wxListBox, wxNotebookEvent, wxColourPickerEvent, wxCursor, wxMessageDialog, wxFontPickerCtrl, wxDisplayChangedEvent, wxToggleButton, wxToolBar, wxGraphicsPen, wxGridCellNumberRenderer, wxPaletteChangedEvent, wxArtProvider, wxHtmlEasyPrinting, wxFindReplaceData, wxListView, wxMoveEvent, wxSashWindow, wxEvtHandler, wxAcceleratorEntry, wxBufferedPaintDC, wxGridCellAttr, wxContextMenuEvent, wxLayoutAlgorithm, wxCheckListBox, wxGridCellBoolEditor, wxMultiChoiceDialog, wxOverlay, wxTaskBarIcon, wxAuiDockArt, wxDropFilesEvent, wxColourDialog, wxHtmlWindow, wxComboBox, wxCommandEvent, wxCloseEvent, wxGridCellRenderer, wxDatePickerCtrl, wxXmlResource, wxGridCellChoiceEditor, wxListbook, wxImageList, wxNotifyEvent, wxToolTip, wxSlider, wxPanel, wxSizer, wxSingleChoiceDialog, wxPageSetupDialogData, wxGBSizerItem, wxPen, wxSplashScreen, wxMenuBar, wxMemoryDC, wxToolbook, wxPopupTransientWindow, wxFileDataObject, wxRadioButton, wxPickerBase, wxTextCtrl, wxNotebook, wxDC, wxCaret, wxPasswordEntryDialog, wxAcceleratorTable, wxMDIParentFrame, wxPreviewControlBar, wxHelpEvent, wxGenericDirCtrl, wxFont, wxControlWithItems, wxSystemSettings, wxWindow, wxHtmlLinkEvent, wxTreeEvent, wxSpinEvent, wxFontPickerEvent, wxAuiTabArt, wxIconBundle, wxClientDC, wxSpinButton, wxAuiManagerEvent, wxPageSetupDialog, wxDirDialog, wxGridEvent, glu, gl,
    %% Handcrafted modules
    wx,
    wx_object,
    wxe_master,
    wxe_server,
    wxe_util
   ]},
  {registered, []},
  {applications, [stdlib, kernel]},
  {env, []},
  {runtime_dependencies, ["stdlib-2.0","kernel-3.0","erts-6.0"]}
 ]}.
