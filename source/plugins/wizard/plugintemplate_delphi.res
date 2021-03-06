        ��  ��                  k  4   ��
 D P R _ P L U G I N         0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: MakeStudioplugintemplate.dpr

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard.schranz@optimeas.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard
2011/09/25  BSchranz  - preparations for external code wizard
2015/01/01  BSchranz  - makestudio reference fixed

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
library %MODULEIDENT%;

uses
  SysUtils,
  Classes,
  ComServ,
  Forms,
  makestudio_TLB,
  {$IFDEF BLOCKEXTERNALWIZARD}
  %USEVARS%,
  %USEMODULE%,
  %USEEDIT%,
  {$IFDEF BLOCKMENUACTION}
  %USEACTIONS%,
  %USEACTIONTEST%,
  {$ENDIF BLOCKMENUACTION}
  {$ENDIF BLOCKEXTERNALWIZARD}
  ActiveX;

{$E jpl}
{$R *.res}

//:Called after all plugins are loaded and registered
//could be used for initialization purpose
procedure AfterAllPluginsLoaded;
begin
end;

//:Indentifies this DLL-Version
procedure MakeStudioPlugin; stdcall;
begin
end;

//:Get name of Plugin
procedure GetName(AName: PChar); stdcall;
begin
  StrCopy(AName, PChar(struPluginName));
end;

//:Get author of Plugin
procedure GetAuthor(AName: PChar); stdcall;
begin
  StrCopy(AName, PChar(struPluginAuthor));
end;

//:Get description of Plugin
procedure GetDescription(AName: PChar); stdcall;
begin
  StrCopy(AName, PChar(struPluginHint));
end;

//:List of Required plugins separated by ";"
procedure GetRequiredPlugins(AName: PChar); stdcall;
begin
  StrCopy(AName, '');
end;

//:Register an initialize Plugin
function RegisterPlugin(AMakeStudioApp: IJApplication): Integer; stdcall;
var
 P: Picture;
begin
  Result := 0;
  MakeStudio := AMakeStudioApp;
  with MakeStudio do
  begin
    try
      {$IFDEF BLOCKMENUACTION}
      //Create form with actions
      FormActions := TFormActions.Create(nil);

      //--- add actions --------------------------------------------------------
      GetPictureFromImageList(FormActions.ImageList1, FormActions.acTestaction1.ImageIndex, P);
      //if the Caption has "\" - the action is assigned to this main menu path!
      //e.g. 'Testmenu\test\'+FormActions.acTestaction1.Caption...
      //if not, the action is assigned to the "extras" menu item
      MakeStudio.AddMenuAction(FormActions.acTestaction1.Name,
                             '%MENUACTIONPATH%' + FormActions.acTestaction1.Caption,
                             FormActions.acTestaction1.Hint,
                             P,
                             IActionCallback(FormActions));
      {$ENDIF BLOCKMENUACTION}

      //--- add modules --------------------------------------------------------
      GetPictureFromImageList(FormActions.ImageList1, 0, P);
      //Name=%COMMANDNAME%; Hint, Category
      //Extension=txt (could be more than one extension - separated by ;)
      //no compatibility - module did not exist before
      //Callback for the Moduletype
      MakeStudio.LogMessage(Application.Exename);
      Plugin%COMMANDIDENTIFIER%Callback := TPlugin%COMMANDIDENTIFIER%Callback.Create(nil);
      MakeStudio.AddCommandType('%COMMANDNAME%', '', stCategory, P, 'txt', -1,
        ICommandCallback(Plugin%COMMANDIDENTIFIER%Callback));

      //Credits
      MakeStudio.AddCreditInfo(struPluginName + ' by ' + struPluginAuthor);

      //Additional Info
      MakeStudio.AddAdditionalInfo(struPluginHint);
    except
    end;
  end;
end;

//:UnRegister an finalize Plugin
function UnregisterPlugin:Integer; stdcall;
begin
  Result := 0;
  try
    FormActions.Free;
    //Remember to Destroy your Callbacks here!
    Plugin%COMMANDIDENTIFIER%Callback.Free;
  except
  end;
end;

//:Version of plugin
function GetMinorVersion: Integer; stdcall;
begin
  Result := 0;
end;

//:Version of plugin
function GetMajorVersion: Integer; stdcall;
begin
  Result := 1;
end;

//:Return the GUID of the Plugins Options-DLG
function GetOptionsPageGUID: TGUID; stdcall;
begin
  //not used yet
  Result := GUID_NULL;
end;

exports
  GetName,
  GetAuthor,
  GetDescription,
  GetRequiredPlugins,
  RegisterPlugin,
  UnregisterPlugin,
  GetMinorVersion,
  GetMajorVersion,
  AfterAllPluginsLoaded,
  GetOptionsPageGUID,
  MakeStudioPlugin;

begin
end.
 �
  4   ��
 P A S _ A C T I O N S       0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Actions.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard.schranz@optimeas.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, makestudio_TLB, ActiveX, AxCtrls;

type
  TFormActions = class(TForm, IActionCallback)
    ActionList1: TActionList;
    ImageList1: TImageList;
    acTestaction1: TAction;
    procedure acTestaction1Execute(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure Execute(const Action: WideString); safecall;
  end;

var
  FormActions: TFormActions;

procedure GetPictureFromImageList(AImages: TImageList; AIndex: Integer; out APic: Picture);

implementation

{$R *.dfm}

uses
  %FILESPREFIX%Actiontest;

procedure GetPictureFromImageList(AImages: TImageList; AIndex: Integer; out APic: Picture);
var
  pic: TPicture;
begin
  APic := nil;
  pic := TPicture.Create;
  try
    AImages.GetBitmap(AIndex, pic.Bitmap);
    GetOlePicture(pic, APic);
  finally
    pic.Free;
  end;
end;                 

procedure TFormActions.Execute(const Action: WideString);
var
  I: Integer;
begin
  for I := 0 to ActionList1.ActionCount - 1 do
    if CompareText(Action, ActionList1.Actions[I].Name) = 0 then
    begin
      ActionList1.Actions[I].Execute;
    end;
end;

procedure TFormActions.acTestaction1Execute(Sender: TObject);
begin
  with TFormActionTest.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

end.
  C)  4   ��
 D F M _ A C T I O N S       0         object FormActions: TFormActions
  Left = 700
  Top = 181
  Width = 246
  Height = 201
  Caption = 'FormActions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ActionList1: TActionList
    Images = ImageList1
    Left = 48
    Top = 24
    object acTestaction1: TAction
      Caption = 'Action aus dem Testplugin'
      ImageIndex = 1
      OnExecute = acTestaction1Execute
    end
  end
  object ImageList1: TImageList
    Left = 88
    Top = 24
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000268D0000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF000A70D800FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000267CF00056BD2000369
      D100076DD4002A8FF1003A9FF8000268D000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00076DD400197EE400076DD400076DD4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000B71D7000E74D9002A8FF1003A9F
      F8003A9FF800258BED000268D000FF00FF00FF00FF00FF00FF0018CEF60019CB
      F700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00076D
      D4002A94F3002BACF900076DD400FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000268D0003A9FF8002287E9003A9F
      F8003A9FF800369BF7000268D000FF00FF00FF00FF00FF00FF00FF00FF0018CE
      F60019CBF700FF00FF00FF00FF00076DD400076DD400076DD400076DD4002790
      F0002CA4F900076DD400FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000268D0003A9FF800197E
      E2002086E8003398F6000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF000A70D8000E73DB002790F0004FCBF3004FCBF300238B
      EE00076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000268D000369B
      F7001177DC001C81E5000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010635D001176DE002CA4F9001F86E9002E9EF8002BACF9002E9E
      F800076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00898D8C0055555600FF00FF00FF00FF00FF00FF000268
      D0003398F6000E74D9000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF000B8813001A9A2A0010635D002790F0004FCBF300197EE4001F86E9002D98
      F600076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000C85
      1300016D0100898D8C0055555600FF00FF00898D8C00898D8C00FF00FF00FF00
      FF000268D0000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000674
      080012911E004EB47A002EBB520010635D001F86E9002E9EF8001176DE001C82
      E700076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF0006730900178A
      2300629F6F00016D0100FF00FF00898D8C0055555600FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000A79
      0D0033C25D001FA3340037C2660012911E0011635C00197EE4002D98F6000E73
      DB00076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF000B740F003E9E
      4C002C9239004E9E5C00016D010055555600FF00FF00898D8C0055555600FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000A79
      0D0033C25D001C9D2E000B881300057F08000279030011635C001176DE00076D
      D400FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF000B740F003E9E
      4C001E8E2B000C85130005820600016D0100898D8C0055555600FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000A79
      0D002AB749001C9D2E0006810B00037B0500027903000279030011635C00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF000B740F003E9E
      4C001E8E2B0007800900027B0300037F0400016D0100FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001291
      1E000E8B170009851000037B0500037B0500016E0100016C0100FF00FF0018CE
      F60019CBF700FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00178A23000D86
      16000A830F00037F0400027B0300016F0200016D0100FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001C9D2E0033C2
      5D000674080001690200016902000169020001690200FF00FF00FF00FF00FF00
      FF0018CEF60019CBF700FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF001E8E2B003E9E4C000571
      0700016D0100016D0100016D0100016D0100FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00137C160033C25D000985
      100001690200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000012871B003E9E4C0009820D00016D
      0100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00026B0300036F0500027702000169
      0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000470060002770300016D0100FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0015952200026B0300FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
 i  <   ��
 P A S _ A C T I O N T E S T         0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Actiontest.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard.schranz@optimeas.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormActionTest = class(TForm)
    Label1: TLabel;
    Button1: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormActionTest: TFormActionTest;

implementation

{$R *.dfm}

end.
   H  <   ��
 D F M _ A C T I O N T E S T         0         object FormActionTest: TFormActionTest
  Left = 300
  Top = 113
  Width = 360
  Height = 340
  Caption = 'FormActionTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 64
    Width = 159
    Height = 37
    Caption = 'Testaction'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 112
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
end
�  0   ��
 P A S _ E D I T         0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Edit.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard.schranz@optimeas.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormEdit%COMMANDCOMPONENTNAME% = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormEdit%COMMANDCOMPONENTNAME%: TFormEdit%COMMANDCOMPONENTNAME%;

implementation

{$R *.dfm}

end.
   �  0   ��
 D F M _ E D I T         0         object FormEdit%COMMANDCOMPONENTNAME%: TFormEdit%COMMANDCOMPONENTNAME%
  Left = 440
  Top = 305
  Width = 346
  Height = 136
  Caption = 'FormEdit%COMMANDCOMPONENTNAME%'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 305
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 64
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 144
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
   �&  4   ��
 P A S _ M O D U L E         0         {$IFDEF BLOCKHEADER}
(*------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Module.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard.schranz@optimeas.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

------------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

{$I jedi.inc}

{$IFDEF DELPHI6_UP}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF DELPHI6_UP}

interface

uses
  ComObj, ActiveX, StdVCL, Graphics, makestudio_TLB,
  Classes, Windows, Dialogs, Controls, SysUtils;

type
  TPlugin%COMMANDIDENTIFIER% = class(TComponent, ICommand2)
  private
    FCaption: string;
    {$IFDEF BLOCKSAMPLEVAR}
    FTestValue: string;
    {$ENDIF BLOCKSAMPLEVAR}
  protected
    //ICommand Interface
    function MeasureItem(Handle: Integer; BriefView: WordBool): Integer; safecall;
    function EditItem: WordBool; safecall;
    function ExecuteItem: WordBool; safecall;
    function DrawItem(Handle: Integer; Left: Integer; Top: Integer; Right: Integer;
      Bottom: Integer; Selected: WordBool; BriefView: WordBool; BkColor: OLE_COLOR): WordBool; safecall;
    procedure SetFilename(const Filename: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_ParamValues(const ParamName: WideString): WideString; safecall;
    procedure Set_ParamValues(const ParamName: WideString; const Value: WideString); safecall;
    function Get_ParamNames(Index: Integer): WideString; safecall;
    function Get_ParamCount: Integer; safecall;
    property Caption: WideString read Get_Caption write Set_Caption;
    property ParamValues[const ParamName: WideString]: WideString read Get_ParamValues write Set_ParamValues;
    property ParamNames[Index: Integer]: WideString read Get_ParamNames;
    property ParamCount: Integer read Get_ParamCount;

    //ICommand2 Interface
    function Get_OwnerDraw: WordBool; safecall;
    function Get_PreviewText: WideString; safecall;
    function Notify(const Notification: WideString; Parameter: OleVariant): OleVariant; safecall;
    function Get_Properties: IDispatch; safecall;
    property OwnerDraw: WordBool read Get_OwnerDraw;
    property PreviewText: WideString read Get_PreviewText;
    property Properties: IDispatch read Get_Properties;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  //Callback to create an instance of the ICommand
  TPlugin%COMMANDIDENTIFIER%Callback = class(TComponent, ICommandCallback)
    function CreateCommand: IDispatch; safecall;
    procedure SetCanceled(aCanceled: WordBool); safecall;
    function GetIdentifier: WideString; safecall;
  end;

var
  Plugin%COMMANDIDENTIFIER%Callback: TPlugin%COMMANDIDENTIFIER%Callback;

const
  IDPlugin%COMMANDIDENTIFIER% = '%PLUGINIDENTIFIER%.%COMMANDIDENTIFIER%';

{
  Example code to register the command. 
  To be used in the "RegisterPlugin" funktion of the project file.
  
      //--- add then command: %COMMANDNAME%
	  // 1. Get the image from an image list
      GetPictureFromImageList(FormActions.ImageList1, 0, P);
	  
	  // 2. Create the global command callback
      Plugin%COMMANDIDENTIFIER%Callback := TPlugin%COMMANDIDENTIFIER%Callback.Create(nil);

	  // 3. Register the command itsel
      //Name=%COMMANDNAME%; Hint, Category
      //Extension=txt (could be more than one extension - separated by ;)
      //no compatibility - module did not exist before
      MakeStudio.AddCommandType('%COMMANDNAME%', 'Your Hint here!', stCategory, P, 'txt', -1,
        ICommandCallback(Plugin%COMMANDIDENTIFIER%Callback));
  
}  
implementation

uses
  ComServ, %PLUGINIDENTIFIER%Vars, %EDITUNIT%;

function TPlugin%COMMANDIDENTIFIER%Callback.CreateCommand: IDispatch;
begin
  Result := ICommand2(TPlugin%COMMANDIDENTIFIER%.Create(nil));
end;

procedure TPlugin%COMMANDIDENTIFIER%Callback.SetCanceled(aCanceled: WordBool);
begin
  FCanceled := aCanceled; //set by the server if the user press "Cancel" oder "Stop"
end;

constructor TPlugin%COMMANDIDENTIFIER%.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := '%COMMANDNAME%';
  {$IFDEF BLOCKSAMPLEVAR}
  FTestValue := '%SAMPLEVARVALUE%';
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.EditItem: WordBool;
begin
  Result := False;
  with TFormEdit%COMMANDCOMPONENTNAME%.Create(nil) do
  try
    {$IFDEF BLOCKSAMPLEVAR}
    Edit1.Text := FTestValue;
    {$ENDIF BLOCKSAMPLEVAR}
    if ShowModal = mrOk then
    begin
      {$IFDEF BLOCKSAMPLEVAR}
      FTestValue := Edit1.Text;
      {$ENDIF BLOCKSAMPLEVAR}
      Result := True;
    end;
  finally
    Free;
  end;
end;

function TPlugin%COMMANDIDENTIFIER%.ExecuteItem: WordBool;
begin
  FCanceled := False;
  {$IFDEF BLOCKSAMPLEVAR}
  MakeStudio.LogMessage(FCaption + ' ' + FTestValue);
  {$ENDIF BLOCKSAMPLEVAR}
  MakeStudio.LogMessage('Executing %COMMANDNAME%...');
  Result := True;
end;

function TPlugin%COMMANDIDENTIFIER%.MeasureItem(Handle: Integer; BriefView: WordBool): Integer;
{$IFDEF BLOCKSAMPLEPAINTCODE}
var
  Canvas: TCanvas;
{$ENDIF BLOCKSAMPLEPAINTCODE}
begin
  {$IFNDEF BLOCKSAMPLEPAINTCODE}
  Result := -1; //auto
  {$ELSE}
  //----------------------------- Example ------------------------
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := Handle;
    Result := 2;
    Canvas.Font.Style := [fsBold];
    Result := Result + Canvas.TextHeight(FCaption) + 2;
    if not BriefView then
    begin
      Canvas.Font.Style := [];
      Result := Result + Canvas.TextHeight(FCaption) + 2;
    end;
  finally
    Canvas.Free;
  end;
  {$ENDIF ~BLOCKSAMPLEPAINTCODE}
end;

function TPlugin%COMMANDIDENTIFIER%.DrawItem(Handle: Integer; Left: Integer; Top: Integer; Right: Integer;
  Bottom: Integer; Selected: WordBool; BriefView: WordBool; BkColor: OLE_COLOR): WordBool;
{$IFDEF BLOCKSAMPLEPAINTCODE}
var
  Offset: Integer;
  Canvas: TCanvas;
  aRect: TRect;
{$ENDIF BLOCKSAMPLEPAINTCODE}  
begin
  {$IFNDEF BLOCKSAMPLEPAINTCODE}
  Result := True; //auto
  {$ELSE}
  //----------------------------- Example ------------------------
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := Handle;
    aRect := Rect(Left, Top, Right, Bottom);
    if Selected then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.FillRect(aRect);
    end
    else
    begin
      Canvas.Brush.Color := clWindow;
      Canvas.FillRect(aRect);
    end;
    Offset := 2;
    Canvas.Font.Style := [fsBold];
    {$IFDEF BLOCKSAMPLEVAR}
    Canvas.TextOut(aRect.Left + 2, aRect.Top + Offset, FCaption + ' ' + FTestValue);
    {$ENDIF BLOCKSAMPLEVAR}    
    if not BriefView then
    begin
      Offset := Canvas.TextHeight(FCaption) + 2;
      Canvas.Font.Style := [];
      Canvas.Font.Color := clBlue;
      Canvas.TextOut(aRect.Left + 10, aRect.Top + Offset, 'only for testing');
    end;
  finally
    Canvas.Free;
  end;
  {$ENDIF ~BLOCKSAMPLEPAINTCODE}
end;

procedure TPlugin%COMMANDIDENTIFIER%.SetFilename(const Filename: WideString);
begin
  //Setting the Filename - used by the host at drag&drop
  //enter your code here
end;

function TPlugin%COMMANDIDENTIFIER%.Get_Caption: WideString;
begin
  Result := FCaption;
end;

procedure TPlugin%COMMANDIDENTIFIER%.Set_Caption(const Value: WideString);
begin
  FCaption := Value;
end;

function TPlugin%COMMANDIDENTIFIER%.Get_ParamValues(const ParamName: WideString): WideString;
begin
  Result := '';
  {$IFDEF BLOCKSAMPLEVAR}
  if SameText(ParamName, '%SAMPLEVARNAME%') then
    Result := FTestValue;
  {$ENDIF BLOCKSAMPLEVAR}
end;

procedure TPlugin%COMMANDIDENTIFIER%.Set_ParamValues(const ParamName: WideString; const Value: WideString);
begin
  {$IFDEF BLOCKSAMPLEVAR}
  if SameText(ParamName, '%SAMPLEVARNAME%') then
    FTestValue := Value;
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.Get_ParamNames(Index: Integer): WideString;
begin
  {$IFDEF BLOCKSAMPLEVAR}
  Result := '%SAMPLEVARNAME%';
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.Get_ParamCount: Integer;
begin
  {$IFDEF BLOCKSAMPLEVAR}
  Result := 1;
  {$ELSE}
  Result := 0;
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.Get_OwnerDraw: WordBool;
begin
  Result := false;
end;

function TPlugin%COMMANDIDENTIFIER%.Get_PreviewText: WideString;
begin
  Result := '';
end;

function TPlugin%COMMANDIDENTIFIER%.Notify(const Notification: WideString;
  Parameter: OleVariant): OleVariant;
begin
  Result := varEmpty;
end;

function TPlugin%COMMANDIDENTIFIER%.Get_Properties: IDispatch;
begin
  Result := nil;
end;


function TPlugin%COMMANDIDENTIFIER%Callback.GetIdentifier: WideString;
begin
  Result := IDPlugin%COMMANDIDENTIFIER%;
end;





end.
   0   ��
 P A S _ V A R S         0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Vars.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard.schranz@optimeas.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  makestudio_TLB;

var
  MakeStudio: IJApplication;
  FCanceled: Boolean = False;

resourcestring
  struPluginName = '%PLUGINNAME%';
  struPluginAuthor = '%PLUGINAUTHOR%';
  struPluginHint = '%PLUGINHINT%';
  stCategory = '%PLUGINCATEGORY%';

implementation

end.
   �c  ,   ��
 P A S _ T L B       0         unit makestudio_TLB;

// ************************************************************************ //
// WARNUNG
// -------
// Die in dieser Datei deklarierten Typen wurden aus Daten einer Typbibliothek
// generiert. Wenn diese Typbibliothek explizit oder indirekt (�ber eine
// andere Typbibliothek) reimportiert wird oder wenn der Befehl
// 'Aktualisieren' im Typbibliotheks-Editor w�hrend des Bearbeitens der
// Typbibliothek aktiviert ist, wird der Inhalt dieser Datei neu generiert und
// alle manuell vorgenommenen �nderungen gehen verloren.
// ************************************************************************ //

// $Rev: 52393 $
// Datei am 27.12.2014 18:48:10 erzeugt aus der unten beschriebenen Typbibliothek.

// ************************************************************************  //
// Typbib.: V:\public\makestudio\trunk\source\framework\makestudio (1)
// LIBID: {09828B26-2D82-4B16-90D1-517D298B3612}
// LCID: 0
// Hilfedatei:
// Hilfe-String: Makestudio Library
// Liste der Abh�ng.:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit muss ohne Typ�berpr�fung f�r Zeiger compiliert werden.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;

// *********************************************************************//
// In der Typbibliothek deklarierte GUIDS. Die folgenden Pr�fixe werden verwendet:
//   Typbibliotheken      : LIBID_xxxx
//   CoClasses            : CLASS_xxxx
//   DISPInterfaces       : DIID_xxxx
//   Nicht-DISP-Interfaces: IID_xxxx
// *********************************************************************//
const
  // Haupt- und Nebenversionen der Typbibliothek
  makestudioMajorVersion = 1;
  makestudioMinorVersion = 0;

  LIBID_makestudio: TGUID = '{09828B26-2D82-4B16-90D1-517D298B3612}';

  IID_IJApplication: TGUID = '{2B09765A-9813-4C0C-B5A2-B8D250F7D006}';
  CLASS_JApplication: TGUID = '{7F8F8634-63D3-460A-BA05-4CED8E2A4CAD}';
  IID_IActionCallback: TGUID = '{D1697D20-4E2F-4B3C-B39C-C6B96C78D55B}';
  IID_ICommand: TGUID = '{59CD4BBC-FC46-4361-9C3A-A22A02FAF63E}';
  IID_ICommandCallback: TGUID = '{B9BFA24F-B70B-4FA2-AF6E-8BB796A0AE3E}';
  IID_IVars: TGUID = '{08E22200-8DFB-4F72-A339-DB2DDB258FE8}';
  IID_IExecCallback: TGUID = '{9722F0A3-D7EC-4DD6-880C-3C2DDE25259D}';
  IID_IPlugin: TGUID = '{584C09E1-6443-4181-87E3-2ED1248A7217}';
  IID_IJApplication2: TGUID = '{0073C47F-0B26-4D9B-9035-53ECF1C2E70F}';
  IID_ICommand2: TGUID = '{BA02E57D-A446-44AE-827B-35E275C80271}';

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten Aufz�hlungen
// *********************************************************************//
// Konstanten f�r enum varBaseType
type
  varBaseType = TOleEnum;
const
  varBaseString = $00000000;
  varBaseBool = $00000001;
  varBaseInteger = $00000002;
  varBaseFloat = $00000003;
  varBaseIDispatch = $00000004;

// Konstanten f�r enum EMakeKind
type
  EMakeKind = TOleEnum;
const
  mkGUI = $00000000;
  mkCommandLine = $00000001;
  mkServer = $00000002;

// Konstanten f�r enum EResultType
type
  EResultType = TOleEnum;
const
  jerOK = $00000000;
  jerWarning = $00000001;
  jerError = $00000002;

type

// *********************************************************************//
// Forward-Deklaration von in der Typbibliothek definierten Typen
// *********************************************************************//
  IJApplication = interface;
  IJApplicationDisp = dispinterface;
  IActionCallback = interface;
  IActionCallbackDisp = dispinterface;
  ICommand = interface;
  ICommandDisp = dispinterface;
  ICommandCallback = interface;
  ICommandCallbackDisp = dispinterface;
  IVars = interface;
  IVarsDisp = dispinterface;
  IExecCallback = interface;
  IExecCallbackDisp = dispinterface;
  IPlugin = interface;
  IPluginDisp = dispinterface;
  IJApplication2 = interface;
  IJApplication2Disp = dispinterface;
  ICommand2 = interface;
  ICommand2Disp = dispinterface;

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten CoClasses
// (HINWEIS: Hier wird jede CoClass ihrem Standard-Interface zugewiesen)
// *********************************************************************//
  JApplication = IJApplication;


// *********************************************************************//
// Interface: IJApplication
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B09765A-9813-4C0C-B5A2-B8D250F7D006}
// *********************************************************************//
  IJApplication = interface(IDispatch)
    ['{2B09765A-9813-4C0C-B5A2-B8D250F7D006}']
    function LoadFromFile(const Filename: WideString): WordBool; safecall;
    procedure Run; safecall;
    procedure AddCommandType(const CommandName: WideString; const CommandHint: WideString;
                             const CommandCategory: WideString; const Bitmap: IPictureDisp;
                             const DragDropFileExtensions: WideString; CompatibilityIndex: Integer;
                             const Callback: IDispatch); safecall;
    procedure AddMenuAction(const ActionName: WideString; const Caption: WideString;
                            const Hint: WideString; const Bitmap: IPictureDisp;
                            const Callback: IDispatch); safecall;
    procedure LogMessage(const Value: WideString); safecall;
    procedure AddAdditionalInfo(const Value: WideString); safecall;
    procedure AddCreditInfo(const Value: WideString); safecall;
    function Get_ApplicationRegKey: WideString; safecall;
    function Get_ApplicationDataFolder: WideString; safecall;
    procedure AddCommandCategory(const aCaption: WideString; const aPicture: IPictureDisp); safecall;
    function Get_Variables: IVars; safecall;
    function ExecCmdLine(const App: WideString; const Args: WideString; const Dir: WideString;
                         const Callback: IExecCallback): Integer; safecall;
    procedure ShowHelp(const Topic: WideString); safecall;
    procedure SetStatus(const Text: WideString); safecall;
    procedure AddCommandByFile(const Filename: WideString); safecall;
    procedure AddCommand(const CommandID: WideString); safecall;
    property ApplicationRegKey: WideString read Get_ApplicationRegKey;
    property ApplicationDataFolder: WideString read Get_ApplicationDataFolder;
    property Variables: IVars read Get_Variables;
  end;

// *********************************************************************//
// DispIntf:  IJApplicationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B09765A-9813-4C0C-B5A2-B8D250F7D006}
// *********************************************************************//
  IJApplicationDisp = dispinterface
    ['{2B09765A-9813-4C0C-B5A2-B8D250F7D006}']
    function LoadFromFile(const Filename: WideString): WordBool; dispid 201;
    procedure Run; dispid 202;
    procedure AddCommandType(const CommandName: WideString; const CommandHint: WideString;
                             const CommandCategory: WideString; const Bitmap: IPictureDisp;
                             const DragDropFileExtensions: WideString; CompatibilityIndex: Integer;
                             const Callback: IDispatch); dispid 212;
    procedure AddMenuAction(const ActionName: WideString; const Caption: WideString;
                            const Hint: WideString; const Bitmap: IPictureDisp;
                            const Callback: IDispatch); dispid 207;
    procedure LogMessage(const Value: WideString); dispid 204;
    procedure AddAdditionalInfo(const Value: WideString); dispid 205;
    procedure AddCreditInfo(const Value: WideString); dispid 206;
    property ApplicationRegKey: WideString readonly dispid 208;
    property ApplicationDataFolder: WideString readonly dispid 209;
    procedure AddCommandCategory(const aCaption: WideString; const aPicture: IPictureDisp); dispid 210;
    property Variables: IVars readonly dispid 211;
    function ExecCmdLine(const App: WideString; const Args: WideString; const Dir: WideString;
                         const Callback: IExecCallback): Integer; dispid 203;
    procedure ShowHelp(const Topic: WideString); dispid 213;
    procedure SetStatus(const Text: WideString); dispid 214;
    procedure AddCommandByFile(const Filename: WideString); dispid 215;
    procedure AddCommand(const CommandID: WideString); dispid 216;
  end;

// *********************************************************************//
// Interface: IActionCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D1697D20-4E2F-4B3C-B39C-C6B96C78D55B}
// *********************************************************************//
  IActionCallback = interface(IDispatch)
    ['{D1697D20-4E2F-4B3C-B39C-C6B96C78D55B}']
    procedure Execute(const Action: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IActionCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D1697D20-4E2F-4B3C-B39C-C6B96C78D55B}
// *********************************************************************//
  IActionCallbackDisp = dispinterface
    ['{D1697D20-4E2F-4B3C-B39C-C6B96C78D55B}']
    procedure Execute(const Action: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: ICommand
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {59CD4BBC-FC46-4361-9C3A-A22A02FAF63E}
// *********************************************************************//
  ICommand = interface(IDispatch)
    ['{59CD4BBC-FC46-4361-9C3A-A22A02FAF63E}']
    function MeasureItem(Handle: Integer; BriefView: WordBool): Integer; safecall;
    function EditItem: WordBool; safecall;
    function ExecuteItem: WordBool; safecall;
    function DrawItem(Handle: Integer; Left: Integer; Top: Integer; Right: Integer;
                      Bottom: Integer; Selected: WordBool; BriefView: WordBool; BkColor: OLE_COLOR): WordBool; safecall;
    procedure SetFilename(const Filename: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_ParamValues(const ParamName: WideString): WideString; safecall;
    procedure Set_ParamValues(const ParamName: WideString; const Value: WideString); safecall;
    function Get_ParamNames(Index: Integer): WideString; safecall;
    function Get_ParamCount: Integer; safecall;
    property Caption: WideString read Get_Caption write Set_Caption;
    property ParamValues[const ParamName: WideString]: WideString read Get_ParamValues write Set_ParamValues;
    property ParamNames[Index: Integer]: WideString read Get_ParamNames;
    property ParamCount: Integer read Get_ParamCount;
  end;

// *********************************************************************//
// DispIntf:  ICommandDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {59CD4BBC-FC46-4361-9C3A-A22A02FAF63E}
// *********************************************************************//
  ICommandDisp = dispinterface
    ['{59CD4BBC-FC46-4361-9C3A-A22A02FAF63E}']
    function MeasureItem(Handle: Integer; BriefView: WordBool): Integer; dispid 201;
    function EditItem: WordBool; dispid 202;
    function ExecuteItem: WordBool; dispid 205;
    function DrawItem(Handle: Integer; Left: Integer; Top: Integer; Right: Integer;
                      Bottom: Integer; Selected: WordBool; BriefView: WordBool; BkColor: OLE_COLOR): WordBool; dispid 206;
    procedure SetFilename(const Filename: WideString); dispid 207;
    property Caption: WideString dispid 208;
    property ParamValues[const ParamName: WideString]: WideString dispid 209;
    property ParamNames[Index: Integer]: WideString readonly dispid 210;
    property ParamCount: Integer readonly dispid 211;
  end;

// *********************************************************************//
// Interface: ICommandCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9BFA24F-B70B-4FA2-AF6E-8BB796A0AE3E}
// *********************************************************************//
  ICommandCallback = interface(IDispatch)
    ['{B9BFA24F-B70B-4FA2-AF6E-8BB796A0AE3E}']
    function CreateCommand: IDispatch; safecall;
    procedure SetCanceled(aCanceled: WordBool); safecall;
    function GetIdentifier: WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICommandCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9BFA24F-B70B-4FA2-AF6E-8BB796A0AE3E}
// *********************************************************************//
  ICommandCallbackDisp = dispinterface
    ['{B9BFA24F-B70B-4FA2-AF6E-8BB796A0AE3E}']
    function CreateCommand: IDispatch; dispid 201;
    procedure SetCanceled(aCanceled: WordBool); dispid 202;
    function GetIdentifier: WideString; dispid 203;
  end;

// *********************************************************************//
// Interface: IVars
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {08E22200-8DFB-4F72-A339-DB2DDB258FE8}
// *********************************************************************//
  IVars = interface(IDispatch)
    ['{08E22200-8DFB-4F72-A339-DB2DDB258FE8}']
    function Get_Count: Integer; safecall;
    function Get_Values(const Varname: WideString): OleVariant; safecall;
    procedure Set_Values(const Varname: WideString; Value: OleVariant); safecall;
    function Get_ValuesByIdx(Index: Integer): OleVariant; safecall;
    procedure Set_ValuesByIdx(Index: Integer; Value: OleVariant); safecall;
    function Get_Names(Index: Integer): WideString; safecall;
    procedure AddVar(const Varname: WideString); safecall;
    procedure DeleteVar(const Varname: WideString); safecall;
    function IdxOfVar(const Varname: WideString): Integer; safecall;
    function VarExists(const Varname: WideString): WordBool; safecall;
    function BaseDataType(const Varname: WideString): varBaseType; safecall;
    function ReplaceVarsInString(const Value: WideString): WideString; safecall;
    property Count: Integer read Get_Count;
    property Values[const Varname: WideString]: OleVariant read Get_Values write Set_Values;
    property ValuesByIdx[Index: Integer]: OleVariant read Get_ValuesByIdx write Set_ValuesByIdx;
    property Names[Index: Integer]: WideString read Get_Names;
  end;

// *********************************************************************//
// DispIntf:  IVarsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {08E22200-8DFB-4F72-A339-DB2DDB258FE8}
// *********************************************************************//
  IVarsDisp = dispinterface
    ['{08E22200-8DFB-4F72-A339-DB2DDB258FE8}']
    property Count: Integer readonly dispid 201;
    property Values[const Varname: WideString]: OleVariant dispid 202;
    property ValuesByIdx[Index: Integer]: OleVariant dispid 203;
    property Names[Index: Integer]: WideString readonly dispid 204;
    procedure AddVar(const Varname: WideString); dispid 205;
    procedure DeleteVar(const Varname: WideString); dispid 206;
    function IdxOfVar(const Varname: WideString): Integer; dispid 207;
    function VarExists(const Varname: WideString): WordBool; dispid 208;
    function BaseDataType(const Varname: WideString): varBaseType; dispid 209;
    function ReplaceVarsInString(const Value: WideString): WideString; dispid 210;
  end;

// *********************************************************************//
// Interface: IExecCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9722F0A3-D7EC-4DD6-880C-3C2DDE25259D}
// *********************************************************************//
  IExecCallback = interface(IDispatch)
    ['{9722F0A3-D7EC-4DD6-880C-3C2DDE25259D}']
    procedure CaptureOutput(const Line: WideString; var Aborted: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExecCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9722F0A3-D7EC-4DD6-880C-3C2DDE25259D}
// *********************************************************************//
  IExecCallbackDisp = dispinterface
    ['{9722F0A3-D7EC-4DD6-880C-3C2DDE25259D}']
    procedure CaptureOutput(const Line: WideString; var Aborted: WordBool); dispid 201;
  end;

// *********************************************************************//
// Interface: IPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {584C09E1-6443-4181-87E3-2ED1248A7217}
// *********************************************************************//
  IPlugin = interface(IDispatch)
    ['{584C09E1-6443-4181-87E3-2ED1248A7217}']
    function RegisterPlugin(const AJVCSMakApp: IJApplication): Integer; safecall;
    function Get_Name: WideString; safecall;
    function Get_Author: WideString; safecall;
    function Get_Description: WideString; safecall;
    function Get_RequiredPlugins: WideString; safecall;
    function UnregisterPlugin: Integer; safecall;
    function Get_MinorVersion: Integer; safecall;
    function Get_MajorVersion: Integer; safecall;
    function Get_OptionsPageGUID: TGUID; safecall;
    procedure AfterAllPluginsLoaded; safecall;
    property Name: WideString read Get_Name;
    property Author: WideString read Get_Author;
    property Description: WideString read Get_Description;
    property RequiredPlugins: WideString read Get_RequiredPlugins;
    property MinorVersion: Integer read Get_MinorVersion;
    property MajorVersion: Integer read Get_MajorVersion;
    property OptionsPageGUID: TGUID read Get_OptionsPageGUID;
  end;

// *********************************************************************//
// DispIntf:  IPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {584C09E1-6443-4181-87E3-2ED1248A7217}
// *********************************************************************//
  IPluginDisp = dispinterface
    ['{584C09E1-6443-4181-87E3-2ED1248A7217}']
    function RegisterPlugin(const AJVCSMakApp: IJApplication): Integer; dispid 5;
    property Name: WideString readonly dispid 1;
    property Author: WideString readonly dispid 2;
    property Description: WideString readonly dispid 3;
    property RequiredPlugins: WideString readonly dispid 4;
    function UnregisterPlugin: Integer; dispid 6;
    property MinorVersion: Integer readonly dispid 7;
    property MajorVersion: Integer readonly dispid 8;
    property OptionsPageGUID: {NOT_OLEAUTO(TGUID)}OleVariant readonly dispid 9;
    procedure AfterAllPluginsLoaded; dispid 10;
  end;

// *********************************************************************//
// Interface: IJApplication2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0073C47F-0B26-4D9B-9035-53ECF1C2E70F}
// *********************************************************************//
  IJApplication2 = interface(IJApplication)
    ['{0073C47F-0B26-4D9B-9035-53ECF1C2E70F}']
    function Get_MakeKind: EMakeKind; safecall;
    function Get_ApplicationHandle: Integer; safecall;
    function Get_ApplicationLanguage: WideString; safecall;
    property MakeKind: EMakeKind read Get_MakeKind;
    property ApplicationHandle: Integer read Get_ApplicationHandle;
    property ApplicationLanguage: WideString read Get_ApplicationLanguage;
  end;

// *********************************************************************//
// DispIntf:  IJApplication2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0073C47F-0B26-4D9B-9035-53ECF1C2E70F}
// *********************************************************************//
  IJApplication2Disp = dispinterface
    ['{0073C47F-0B26-4D9B-9035-53ECF1C2E70F}']
    property MakeKind: EMakeKind readonly dispid 301;
    property ApplicationHandle: Integer readonly dispid 302;
    property ApplicationLanguage: WideString readonly dispid 303;
    function LoadFromFile(const Filename: WideString): WordBool; dispid 201;
    procedure Run; dispid 202;
    procedure AddCommandType(const CommandName: WideString; const CommandHint: WideString;
                             const CommandCategory: WideString; const Bitmap: IPictureDisp;
                             const DragDropFileExtensions: WideString; CompatibilityIndex: Integer;
                             const Callback: IDispatch); dispid 212;
    procedure AddMenuAction(const ActionName: WideString; const Caption: WideString;
                            const Hint: WideString; const Bitmap: IPictureDisp;
                            const Callback: IDispatch); dispid 207;
    procedure LogMessage(const Value: WideString); dispid 204;
    procedure AddAdditionalInfo(const Value: WideString); dispid 205;
    procedure AddCreditInfo(const Value: WideString); dispid 206;
    property ApplicationRegKey: WideString readonly dispid 208;
    property ApplicationDataFolder: WideString readonly dispid 209;
    procedure AddCommandCategory(const aCaption: WideString; const aPicture: IPictureDisp); dispid 210;
    property Variables: IVars readonly dispid 211;
    function ExecCmdLine(const App: WideString; const Args: WideString; const Dir: WideString;
                         const Callback: IExecCallback): Integer; dispid 203;
    procedure ShowHelp(const Topic: WideString); dispid 213;
    procedure SetStatus(const Text: WideString); dispid 214;
    procedure AddCommandByFile(const Filename: WideString); dispid 215;
    procedure AddCommand(const CommandID: WideString); dispid 216;
  end;

// *********************************************************************//
// Interface: ICommand2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA02E57D-A446-44AE-827B-35E275C80271}
// *********************************************************************//
  ICommand2 = interface(ICommand)
    ['{BA02E57D-A446-44AE-827B-35E275C80271}']
    function Get_OwnerDraw: WordBool; safecall;
    function Get_PreviewText: WideString; safecall;
    function Notify(const Notification: WideString; Parameter: OleVariant): OleVariant; safecall;
    function Get_Properties: IDispatch; safecall;
    property OwnerDraw: WordBool read Get_OwnerDraw;
    property PreviewText: WideString read Get_PreviewText;
    property Properties: IDispatch read Get_Properties;
  end;

// *********************************************************************//
// DispIntf:  ICommand2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA02E57D-A446-44AE-827B-35E275C80271}
// *********************************************************************//
  ICommand2Disp = dispinterface
    ['{BA02E57D-A446-44AE-827B-35E275C80271}']
    property OwnerDraw: WordBool readonly dispid 301;
    property PreviewText: WideString readonly dispid 302;
    function Notify(const Notification: WideString; Parameter: OleVariant): OleVariant; dispid 303;
    property Properties: IDispatch readonly dispid 304;
    function MeasureItem(Handle: Integer; BriefView: WordBool): Integer; dispid 201;
    function EditItem: WordBool; dispid 202;
    function ExecuteItem: WordBool; dispid 205;
    function DrawItem(Handle: Integer; Left: Integer; Top: Integer; Right: Integer;
                      Bottom: Integer; Selected: WordBool; BriefView: WordBool; BkColor: OLE_COLOR): WordBool; dispid 206;
    procedure SetFilename(const Filename: WideString); dispid 207;
    property Caption: WideString dispid 208;
    property ParamValues[const ParamName: WideString]: WideString dispid 209;
    property ParamNames[Index: Integer]: WideString readonly dispid 210;
    property ParamCount: Integer readonly dispid 211;
  end;

// *********************************************************************//
// Die Klasse CoJApplication stellt die Methoden Create und CreateRemote zur
// Verf�gung, um Instanzen des Standard-Interface IJApplication, dargestellt
// von CoClass JApplication, zu erzeugen. Diese Funktionen k�nnen
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.
// *********************************************************************//
  CoJApplication = class
    class function Create: IJApplication;
    class function CreateRemote(const MachineName: string): IJApplication;
  end;

implementation

uses System.Win.ComObj;

class function CoJApplication.Create: IJApplication;
begin
  Result := CreateComObject(CLASS_JApplication) as IJApplication;
end;

class function CoJApplication.CreateRemote(const MachineName: string): IJApplication;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_JApplication) as IJApplication;
end;

end.

  