unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, ImgList, ToolWin;

type
  TFormMain = class(TForm)
    PanelMain: TPanel;
    MainMenu1: TMainMenu;
    MenuArm: TMenuItem;
    MenuProduct: TMenuItem;
    MenuGame: TMenuItem;
    MenuHelp: TMenuItem;
    MenuArmCreate: TMenuItem;
    MenuArmDestroy: TMenuItem;
    MenuProductCreate: TMenuItem;
    MenuProductDestroy: TMenuItem;
    MenuGameCreateAll: TMenuItem;
    MenuHelpAbout: TMenuItem;
    MenuGameDestroyAll: TMenuItem;
    MenuGameFromLeftToRight: TMenuItem;
    MenuGameFromRightToLeft: TMenuItem;
    MenuGameAutoDecide: TMenuItem;
    MenuGameReset: TMenuItem;
    MenuGameRun: TMenuItem;
    MenuGameRearrange: TMenuItem;
    N20: TMenuItem;
    MenuGameExit: TMenuItem;
    N3: TMenuItem;
    N11: TMenuItem;
    StatusBar1: TStatusBar;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuGameCreateAllClick(Sender: TObject);
    procedure MenuArmCreateClick(Sender: TObject);
    procedure MenuArmDestroyClick(Sender: TObject);
    procedure MenuProductCreateClick(Sender: TObject);
    procedure MenuProductDestroyClick(Sender: TObject);
    procedure MenuGameFromLeftToRightClick(Sender: TObject);
    procedure MenuGameFromRightToLeftClick(Sender: TObject);
    procedure MenuGameAutoDecideClick(Sender: TObject);
    procedure MenuGameResetClick(Sender: TObject);
    procedure MenuGameRunClick(Sender: TObject);
    procedure MenuGameRearrangeClick(Sender: TObject);
    procedure MenuGameDestroyAllClick(Sender: TObject);
    procedure MenuGameExitClick(Sender: TObject);
    procedure MenuHelpAboutClick(Sender: TObject);
  private
    function GetNextIJ(var tmpI, tmpJ: integer): boolean;
    function GetNextTargetIJ(var tmpI, tmpJ: integer): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitTArm, UnitCommon, UnitTMyObject, UnitTMyPanel;

{$R *.dfm}

type
  TData = array[1..MAXI] of array[1..MAXJ] of TMyObject;
  TDirection = (ATRIGHT, ATLEFT);
var
  GArm: TArm = nil;
  GMyObjectArray: TData;
  GObjectFlag: boolean = false;
  GFlag: TDirection = ATLEFT;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  randomize;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
var
  i: Integer;
  j: Integer;
begin
  FreeAndNil(GArm);
  for i := 1 to MAXI do
    for j := 1 to MAXJ do
      FreeAndNil(GMyObjectArray[i, j]);
end;

function TFormMain.GetNextIJ(var tmpI, tmpJ: integer): boolean;
var
  i, j: Integer;
begin
  result := false;
  for i := DATASTARTI to DATAENDI do
    for j := DATASTARTJ to DATAENDJ do
    begin
      if GMyObjectArray[i, j] <> nil then
      begin
        tmpI := i;
        tmpJ := j;
        result := true;
        exit;
      end;
    end;
end;

function TFormMain.GetNextTargetIJ(var tmpI, tmpJ: integer): boolean;
var
  i: Integer;
  j: Integer;
begin
  result := false;
  for i := DATATARGETENDI downto DATATARGETSTARTI do
    for j := DATATARGETENDJ downto DATATARGETSTARTJ do
    begin
      if GMyObjectArray[i, j] = nil then
      begin
        tmpI := i;
        tmpJ := j;
        result := true;
        exit;
      end;
    end;
end;

procedure TFormMain.MenuArmCreateClick(Sender: TObject);
begin
  if GArm = nil then
    GArm := TArm.Create(PanelMain, STARTX, STARTY, INITARMI, INITARMJ, clRed, clGreen, clBlue);
  GArm.Interval := 0;
end;

procedure TFormMain.MenuArmDestroyClick(Sender: TObject);
begin
  FreeAndNil(GArm);
end;

procedure TFormMain.MenuGameAutoDecideClick(Sender: TObject);
begin
  if GArm = nil then exit;
  if GFlag = ATLEFT then
    MenuGameFromLeftToRightClick(Sender)
  else if GFlag = ATRIGHT then
    MenuGameFromRightToLeftClick(Sender);
end;

procedure TFormMain.MenuGameCreateAllClick(Sender: TObject);
begin
  MenuProductCreateClick(Sender);
  MenuArmCreateClick(Sender);
end;

procedure TFormMain.MenuGameDestroyAllClick(Sender: TObject);
begin
  MenuArmDestroyClick(Sender);
  MenuProductDestroyClick(Sender);
end;

procedure TFormMain.MenuGameExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuGameFromLeftToRightClick(Sender: TObject);
var
  i, j: integer;
begin
  if GArm = nil then exit;
  if GFlag = ATRIGHT then exit;
  MenuGameCreateAll.Enabled := false;
  MenuGameFromLeftToRight.Enabled := false;
  MenuGameFromRightToLeft.Enabled := false;
  MenuGameReset.Enabled := false;
  MenuGameDestroyAll.Enabled := false;
  MenuGameAutoDecide.Enabled := false;
  MenuGameRun.Enabled := false;
  MenuGameRearrange.Enabled := false;
  MenuArmCreate.Enabled := false;
  MenuArmDestroy.Enabled := false;
  MenuProductCreate.Enabled := false;
  MenuProductDestroy.Enabled := false;
  for i := DATASTARTI to DATAENDI do
    for j := DATASTARTJ to DATAENDJ do
    begin
      if GMyObjectArray[i, j] <> nil then
      begin
        GArm.MoveToXYDirectly(i, j - 1);
        GArm.Flag := true;
        GArm.MyObject := GMyObjectArray[i, j];
        GArm.MoveToXYDirectly(i + DATAENDI, j - 1);
        GMyObjectArray[i + DATAENDI, j] := GMyObjectArray[i, j];
        GMyObjectArray[i, j] := nil;
        GArm.Flag := false;
        GArm.MyObject := nil;
        Application.ProcessMessages;
      end;
    end;
  GArm.MoveToXYDirectly(INITARMI, INITARMJ);
  Application.ProcessMessages;
  MenuGameCreateAll.Enabled := true;
  MenuGameFromLeftToRight.Enabled := true;
  MenuGameFromRightToLeft.Enabled := true;
  MenuGameReset.Enabled := true;
  MenuGameDestroyAll.Enabled := true;
  MenuGameAutoDecide.Enabled := true;
  MenuGameRun.Enabled := true;
  MenuGameRearrange.Enabled := true;
  MenuArmCreate.Enabled := true;
  MenuArmDestroy.Enabled := true;
  MenuProductCreate.Enabled := true;
  MenuProductDestroy.Enabled := true;
  GFlag := ATRIGHT;
end;

procedure TFormMain.MenuGameFromRightToLeftClick(Sender: TObject);
var
  i, j: integer;
begin
  if GArm = nil then exit;
  if GFlag = ATLEFT then exit;
  MenuGameCreateAll.Enabled := false;
  MenuGameFromLeftToRight.Enabled := false;
  MenuGameFromRightToLeft.Enabled := false;
  MenuGameReset.Enabled := false;
  MenuGameDestroyAll.Enabled := false;
  MenuGameAutoDecide.Enabled := false;
  MenuGameRun.Enabled := false;
  MenuGameRearrange.Enabled := false;
  MenuArmCreate.Enabled := false;
  MenuArmDestroy.Enabled := false;
  MenuProductCreate.Enabled := false;
  MenuProductDestroy.Enabled := false;
  for i := DATASTARTI + DATAENDI to DATAENDI + DATAENDI do
    for j := DATASTARTJ to DATAENDJ do
    begin
      if GMyObjectArray[i, j] <> nil then
      begin
        GArm.MoveToXYDirectly(i, j - 1);
        GArm.Flag := true;
        GArm.MyObject := GMyObjectArray[i, j];
        GArm.MoveToXYDirectly(i - DATAENDI, j - 1);
        GMyObjectArray[i - DATAENDI, j] := GMyObjectArray[i, j];
        GMyObjectArray[i, j] := nil;
        GArm.Flag := false;
        GArm.MyObject := nil;
        Application.ProcessMessages;
      end;
    end;
  GArm.MoveToXYDirectly(INITARMI, INITARMJ);
  Application.ProcessMessages;
  MenuGameCreateAll.Enabled := true;
  MenuGameFromLeftToRight.Enabled := true;
  MenuGameFromRightToLeft.Enabled := true;
  MenuGameReset.Enabled := true;
  MenuGameDestroyAll.Enabled := true;
  MenuGameAutoDecide.Enabled := true;
  MenuGameRun.Enabled := true;
  MenuGameRearrange.Enabled := true;
  MenuArmCreate.Enabled := true;
  MenuArmDestroy.Enabled := true;
  MenuProductCreate.Enabled := true;
  MenuProductDestroy.Enabled := true;
  GFlag := ATLEFT;
end;

procedure TFormMain.MenuGameRearrangeClick(Sender: TObject);
var
  i, j, tmpI, tmpJ: Integer;
begin
  tmpI := DATASTARTI;
  tmpJ := DATASTARTJ;
  for i := DATATARGETSTARTI to DATATARGETENDI do
    for j := DATATARGETSTARTJ to DATATARGETENDJ do
    begin
      if GMyObjectArray[i, j] <> nil then
      begin
        GMyObjectArray[tmpI, tmpJ] := GMyObjectArray[i, j];
        GMyObjectArray[i, j] := nil;
        GMyObjectArray[tmpI, tmpJ].X := tmpI;
        GMyObjectArray[tmpI, tmpJ].Y := tmpJ;
        GMyObjectArray[tmpI, tmpJ].ShowPosition;
        GMyObjectArray[tmpI, tmpJ].Caption := format('%2d-%2d', [tmpI, tmpJ]);
        inc(tmpJ);
        if tmpJ > DATAENDJ then
        begin
          tmpJ := DATASTARTJ;
          inc(tmpI);
        end;
      end;
    end;
end;

procedure TFormMain.MenuGameResetClick(Sender: TObject);
begin
  MenuProductDestroyClick(Sender);
  MenuProductCreateClick(Sender);
end;

procedure TFormMain.MenuGameRunClick(Sender: TObject);
var
  i, j, tmpI, tmpJ: integer;
  tmpSourceResult, tmpTargetResult: boolean;
begin
  if GArm = nil then exit;
  MenuGameCreateAll.Enabled := false;
  MenuGameFromLeftToRight.Enabled := false;
  MenuGameFromRightToLeft.Enabled := false;
  MenuGameReset.Enabled := false;
  MenuGameDestroyAll.Enabled := false;
  MenuGameAutoDecide.Enabled := false;
  MenuGameRun.Enabled := false;
  MenuGameRearrange.Enabled := false;
  MenuArmCreate.Enabled := false;
  MenuArmDestroy.Enabled := false;
  MenuProductCreate.Enabled := false;
  MenuProductDestroy.Enabled := false;
  tmpSourceResult := GetNextIJ(i, j);
  while tmpSourceResult do
  begin
    tmpTargetResult := GetNextTargetIJ(tmpI, tmpJ);
    if not tmpTargetResult then
    begin
      Windows.Beep(1000, 100);
      GArm.Flag := false;
      GArm.MyObject := nil;
      break;
    end;
    GArm.MoveToXYDirectly(i, j - 1);
    GArm.Flag := true;
    GArm.MyObject := GMyObjectArray[i, j];
    GArm.MoveToXYDirectly(tmpI, tmpJ - 1);
    GMyObjectArray[tmpI, tmpJ] := GMyObjectArray[i, j];
    GMyObjectArray[tmpI, tmpJ].Caption := Format('%2d-%2d', [tmpI, tmpJ]);
    GMyObjectArray[i, j] := nil;
    GArm.Flag := false;
    GArm.MyObject := nil;
    tmpSourceResult := GetNextIJ(i, j);
    Application.ProcessMessages;
  end;
  GArm.MoveToXYDirectly(INITARMI, INITARMJ);
  Application.ProcessMessages;
  MenuGameCreateAll.Enabled := true;
  MenuGameFromLeftToRight.Enabled := true;
  MenuGameFromRightToLeft.Enabled := true;
  MenuGameReset.Enabled := true;
  MenuGameDestroyAll.Enabled := true;
  MenuGameAutoDecide.Enabled := true;
  MenuGameRun.Enabled := true;
  MenuGameRearrange.Enabled := true;
  MenuArmCreate.Enabled := true;
  MenuArmDestroy.Enabled := true;
  MenuProductCreate.Enabled := true;
  MenuProductDestroy.Enabled := true;
end;

procedure TFormMain.MenuHelpAboutClick(Sender: TObject);
begin
  MessageBox(Self.Handle, '游戏开发者：RICOL' + sLineBreak + '开发日期：2010.07.22', '关于', MB_OK or MB_ICONINFORMATION);
end;

procedure TFormMain.MenuProductCreateClick(Sender: TObject);
var
  i: Integer;
  j: Integer;
begin
  if GObjectFlag then exit;
  for i := DATASTARTI to DATAENDI do
    for j := DATASTARTJ to DATAENDJ do
      GMyObjectArray[i, j] := TMyObject.Create(PanelMain, i, j, false);
  GObjectFlag := true;
end;

procedure TFormMain.MenuProductDestroyClick(Sender: TObject);
var
  i: Integer;
  j: Integer;
begin
  if not GObjectFlag then exit;
  for i := 1 to MAXI do
    for j := 1 to MAXJ do
      FreeAndNil(GMyObjectArray[i, j]);
  GObjectFlag := false;
end;

end.
