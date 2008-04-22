#tag ClassProtected Class AppInherits Application	#tag Event		Sub Open()		  // Remove the separator under the help item if we're not on a Mac (no separator needed in Help menu on Windows and Linux)		  #if not TargetMacOS		    HelpAboutSeparator.Close		  #endif		  		  // Initialise the Preferences object		  pPreferences = new Preferences()		  		  // For now, just get the last X-Plane folder the user accessed.  We will need to provide a user interface		  // onto multiple X-Plane folders one day.		  dim lastXPlaneFolder as String = pPreferences.getLastXPlaneFolder()		  if (lastXPlaneFolder <> "") then pXPlaneFolder = new XPlaneFolderItem(getFolderItem(lastXPlaneFolder, FolderItem.PathTypeAbsolute))		  		  if (pXPlaneFolder = nil _		    or not pXPlaneFolder.exists() _		    or not pXPlaneFolder.directory _		    or not CustomSceneryPackage.getRootFolder().exists() _		    or not Aircraft.getRootFolder().exists() _		    or not Plugin.getRootFolder().exists()) then		    dim result as Boolean = requestXPlaneFolder(true)		  end if		  		  initialiseXPlaneFolder()		  		  wndDebug.show()		End Sub	#tag EndEvent	#tag Event		Sub Close()		  // The preferences object will automatically save in its destructor method		End Sub	#tag EndEvent#tag MenuHandler		Function HelpAbout() As Boolean Handles HelpAbout.Action			wndAbout.show			Return True					End Function#tag EndMenuHandler#tag MenuHandler		Function HelpUserGuide() As Boolean Handles HelpUserGuide.Action			showURL(kURLUserGuide)			Return True					End Function#tag EndMenuHandler	#tag Method, Flags = &h0		Function requestXPlaneFolder(require as Boolean) As boolean		  // Returns true if the user chose a new folder (and require is false)		  		  dim dialog as SelectFolderDialog = new SelectFolderDialog()		  dim xPlanePath as String		  dim xPlaneFolder as FolderItem		  		  dialog.title = kLocateXPlaneFolder		  dialog.promptText = kLocateXPlaneFolder		  		  #if TargetWin32		    dialog.initialDirectory = Volume(0).Child("Program Files")		  #elseif TargetMacOS		    dialog.initialDirectory = Volume(0).Child("Applications")		  #elseif TargetLinux		    dialog.initialDirectory = Volume(0)		  #endif		  		  while true		    xPlaneFolder = dialog.showModal()		    if (xPlaneFolder = nil) then		      if (require) then		        dim result as Integer = displayMessage(kErrorNoXPlaneFolderSelected, "", MessageDialog.GraphicCaution, App.kOk, "", "", nil)		        quit		      else		        return false		      end if		    end if		    		    if (not Aircraft.checkXPlaneFolder(xPlaneFolder) _		      or not CustomSceneryPackage.checkXPlaneFolder(xPlaneFolder) _		      or not Plugin.checkXPlaneFolder(xPlaneFolder)) then		      dim result as Integer = displayMessage(kErrorNotXPlaneFolder, "", MessageDialog.GraphicCaution, App.kOk, "", "", nil)		    else		      pXPlaneFolder = new XPlaneFolderItem(xPlaneFolder)		      return true		    end if		  wend		  		  		End Function	#tag EndMethod	#tag Method, Flags = &h0		Function processParameterizedString(str as String, parameters() as String) As String		  if ubound(parameters) > -1 then		    dim i as integer		    for i = 0 to ubound(parameters)		      str = str.ReplaceAll("${" + str(i+1) + "}", parameters(i))		    next		  end if		  		  return str		  		exception err as NilObjectException		  // Will throw exception if no second parameter passed		  return str		End Function	#tag EndMethod	#tag Method, Flags = &h0		Sub Debug(message as String)		  if wndDebug.visible then		    wndDebug.fldDebug.text = wndDebug.fldDebug.text + endofline + message		  end if		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Sub checkVersion(version as String)		  if (App.shortVersion <> version) then		    wndNewVersion.setTitle(shortVersion, version)		    wndNewVersion.show		  end if		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Function displayMessage(message as String, explanation as String, icon as Integer, actionButtonCaption as String, alternateActionButtonCaption as String, cancelButtonCaption as String, parentWindow as Window) As Integer		  // Icon is one of MessageDialog.GraphicNone | MessageDialog.GraphicNote | MessageDialog.GraphicCaution | MessageDialog.GraphicStop | MessageDialog.GraphicQuestion		  dim messageDialog as new MessageDialog		  dim result as MessageDialogButton		  		  if (icon <> -1) then messageDialog.icon = icon		  if (message <> "") then messageDialog.message = message		  if (explanation <> "") then messageDialog.explanation = explanation		  		  if (actionButtonCaption <> "") then		    messageDialog.ActionButton.Caption = actionButtonCaption		  end if		  if (cancelButtonCaption <> "") then		    messageDialog.CancelButton.Caption = cancelButtonCaption		    messageDialog.CancelButton.Visible = true		  end if		  if (alternateActionButtonCaption <> "") then		    messageDialog.AlternateActionButton.Caption = alternateActionButtonCaption		    messageDialog.AlternateActionButton.Visible = true		  end if		  		  if (parentWindow <> nil) then		    result = messageDialog.ShowModalWithin(parentWindow)		  else		    result = messageDialog.ShowModal()		  end if		  		  select case result		  case messageDialog.ActionButton		    return 1		  case messageDialog.AlternateActionButton		    return 2		  case messageDialog.CancelButton		    return 0		  end select		End Function	#tag EndMethod	#tag Method, Flags = &h0		Sub initialiseXPlaneFolder()		  Aircraft.initialiseXPlaneFolder()		  CustomSceneryPackage.initialiseXPlaneFolder()		  Plugin.initialiseXPlaneFolder()		  CSL.initialiseXPlaneFolder()		End Sub	#tag EndMethod	#tag Property, Flags = &h0		pPreferences As Preferences	#tag EndProperty	#tag Property, Flags = &h0		pXPlaneFolder As XPlaneFolderItem	#tag EndProperty	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"	#tag EndConstant	#tag Constant, Name = kFileQuit, Type = String, Dynamic = True, Default = \"&Quit", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Salir"		#Tag Instance, Platform = Windows, Language = es, Definition  = \"&Salir"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Quitter"		#Tag Instance, Platform = Windows, Language = fr, Definition  = \"&Quitter"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Surt"		#Tag Instance, Platform = Windows, Language = ca, Definition  = \"&Surt"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&Chiudi"		#Tag Instance, Platform = Windows, Language = it, Definition  = \"&Esci"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Verlassen"		#Tag Instance, Platform = Windows, Language = de, Definition  = \"&Verlassen"	#tag EndConstant	#tag Constant, Name = kEditClear, Type = String, Dynamic = True, Default = \"&Delete", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Borrar"		#Tag Instance, Platform = Windows, Language = es, Definition  = \"&Borrar"		#Tag Instance, Platform = Linux, Language = es, Definition  = \"&Borrar"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Effacer"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Esborra"		#Tag Instance, Platform = Windows, Language = ca, Definition  = \"&Esborra"		#Tag Instance, Platform = Linux, Language = ca, Definition  = \"&Esborra"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&Elimina"		#Tag Instance, Platform = Windows, Language = it, Definition  = \"&Elimina"		#Tag Instance, Platform = Linux, Language = it, Definition  = \"&Elimina"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&L\xC3\xB6schen"		#Tag Instance, Platform = Windows, Language = de, Definition  = \"&L\xC3\xB6schen"		#Tag Instance, Platform = Linux, Language = de, Definition  = \"&L\xC3\xB6schen"	#tag EndConstant	#tag Constant, Name = kApplicationName, Type = String, Dynamic = False, Default = \"XAddonManager", Scope = Public	#tag EndConstant	#tag Constant, Name = kLocateXPlaneFolder, Type = String, Dynamic = True, Default = \"Please locate your X-Plane\xC2\xAE folder", Scope = Public		#Tag Instance, Platform = Any, Language = es, Definition  = \"Por favor localice su carpeta de X-Plane\xC2\xAE"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Indiquer le chemin de votre installation X-Plane\xC2\xAE"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"Trieu la carpeta de l\'X-Plane\xC2\xAE"		#Tag Instance, Platform = Any, Language = it, Definition  = \"Per favore localizza la tua cartella principale di X-Plane\xC2\xAE"		#Tag Instance, Platform = Any, Language = de, Definition  = \"Orten sie bitte ihren X-Plane\xC2\xAE Ordner"	#tag EndConstant	#tag Constant, Name = kErrorNoXPlaneFolderSelected, Type = String, Dynamic = True, Default = \"This program cannot work without knowing where your X-Plane\xC2\xAE folder is located and will now quit.", Scope = Public		#Tag Instance, Platform = Any, Language = es, Definition  = \"Este instalador no puede operar sin saber donde est\xC3\xA1 ubicada su carpeta de X-Plane\xC2\xAE y dejar\xC3\xA1 de ejecutarse."		#Tag Instance, Platform = Any, Language = fr, Definition  = \"L\'installeur ne peut pas fonctionner sans X-Plane\xC2\xAE et va maintenant \xC3\xAAtre ferm\xC3\xA9."		#Tag Instance, Platform = Any, Language = ca, Definition  = \"Aquest insta\xC5\x80lador no pot continuar sense saber on \xC3\xA9s la vostra carpeta de l\'X-Plane\xC2\xAE i ara s\'acabar\xC3\xA0."		#Tag Instance, Platform = Any, Language = it, Definition  = \"Questo programma non pu\xC3\xB2 funzionare senza sapere dove \xC3\xA8 posizionata la cartella di X-Plane\xC2\xAE e verr\xC3\xA0 terminato."		#Tag Instance, Platform = Any, Language = de, Definition  = \"Dieses programm funtioniert ohne validen X-Plane Ordner nicht und wird jetzt abgebrochen."	#tag EndConstant	#tag Constant, Name = kErrorNotXPlaneFolder, Type = String, Dynamic = True, Default = \"The folder you selected is not a valid X-Plane\xC2\xAE folder\x2C please try again.", Scope = Public		#Tag Instance, Platform = Any, Language = ca, Definition  = \"La carpeta triada \xC3\xA9s una carpeta no v\xC3\xA0lida de l\'X-Plane\xC2\xAE\x2C torneu-ho a provar."		#Tag Instance, Platform = Any, Language = it, Definition  = \"La cartella che hai selezionato non \xC3\xA8 di X-Plane\xC2\xAE\x2C riprova per favore."		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Le dossier que vous avez selectionn\xC3\xA9 n\'est pas un dossier X-Plane\xC2\xAE valide. Reessayez SVP."		#Tag Instance, Platform = Any, Language = de, Definition  = \"Der vo ihnen ausgew\xC3\xA4hlte Ordner ist kein valider X-Plane\xC2\xAE Ordner\x2C versuchen sie es bitte eneut."	#tag EndConstant	#tag Constant, Name = kFile, Type = String, Dynamic = True, Default = \"&File", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Fichier"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Archivo"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Fitxer"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&Archivio"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Datei"	#tag EndConstant	#tag Constant, Name = kEdit, Type = String, Dynamic = True, Default = \"&Edit", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Editer"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Editar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Edita"		#Tag Instance, Platform = Any, Language = it, Definition  = \"Composizion&e"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Bearbeiten"	#tag EndConstant	#tag Constant, Name = kEditUndo, Type = String, Dynamic = True, Default = \"&Undo", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Annuler"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Deshacer"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Desf\xC3\xA9s"		#Tag Instance, Platform = Any, Language = it, Definition  = \"Ann&ulla"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Undo"	#tag EndConstant	#tag Constant, Name = kEditCut, Type = String, Dynamic = True, Default = \"Cu&t", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Co&uper"		#Tag Instance, Platform = Any, Language = es, Definition  = \"C&ortar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"Re&talla"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&Taglia"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Schneiden"	#tag EndConstant	#tag Constant, Name = kEditPaste, Type = String, Dynamic = True, Default = \"&Paste", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Coller"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Pegar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Enganxa"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&Incolla"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Kleben"	#tag EndConstant	#tag Constant, Name = kEditCopy, Type = String, Dynamic = True, Default = \"&Copy", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Co&pier"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Copiar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Copia"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&Copia"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Kopieren"	#tag EndConstant	#tag Constant, Name = kEditSelectAll, Type = String, Dynamic = True, Default = \"Select &All", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Tout s\xC3\xA9lectionner"		#Tag Instance, Platform = Any, Language = es, Definition  = \"Seleccionar &Todo"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Selecciona-ho tot"		#Tag Instance, Platform = Any, Language = it, Definition  = \"Selezion&a Tutto"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Alles ausw\xC3\xA4hlen"	#tag EndConstant	#tag Constant, Name = kHelp, Type = String, Dynamic = True, Default = \"&Help", Scope = Public		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Ajuda"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&Aiuto"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"A&ide"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&Hilfe"	#tag EndConstant	#tag Constant, Name = kHelpAbout, Type = String, Dynamic = True, Default = \"&About XAddonManager", Scope = Public		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Quan a XAddonManager"		#Tag Instance, Platform = Any, Language = it, Definition  = \"&A proposito di XAddonManager"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"A &propos de XAddonManager"		#Tag Instance, Platform = Any, Language = de, Definition  = \"&\xC3\x9Cber XAddonManager"	#tag EndConstant	#tag Constant, Name = kURLVersion, Type = String, Dynamic = False, Default = \"http://xaddonmanager.googlecode.com/svn/trunk/VersionInfo/version.txt", Scope = Public	#tag EndConstant	#tag Constant, Name = kURLReleaseNotes, Type = String, Dynamic = False, Default = \"http://xaddonmanager.googlecode.com/svn/trunk/VersionInfo/releasenotes.html", Scope = Public	#tag EndConstant	#tag Constant, Name = kURLWebsite, Type = String, Dynamic = False, Default = \"http://xaddonmanager.googlecode.com", Scope = Public	#tag EndConstant	#tag Constant, Name = kURLUserGuide, Type = String, Dynamic = False, Default = \"http://code.google.com/p/xaddonmanager/wiki/UserGuide", Scope = Public	#tag EndConstant	#tag Constant, Name = kOk, Type = String, Dynamic = True, Default = \"Ok", Scope = Public	#tag EndConstant	#tag Constant, Name = kCancel, Type = String, Dynamic = True, Default = \"Cancel", Scope = Public	#tag EndConstant	#tag Constant, Name = kDelete, Type = String, Dynamic = True, Default = \"Delete", Scope = Public	#tag EndConstant	#tag Constant, Name = kDontDelete, Type = String, Dynamic = True, Default = \"Don\'t Delete", Scope = Public	#tag EndConstant	#tag ViewBehavior	#tag EndViewBehaviorEnd Class#tag EndClass