unit UnitTArm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UnitTMyPanel, UnitCommon, UnitTMyObject;

type
  TArm = class
  private
    FArmVertical: TMyPanel;
    FArmHorizon: TMyPanel;
    FArmHand: TMyPanel;
    FHorizonLen: cardinal;
    FVerticalLen: cardinal;
    FHandLen: cardinal;
    FPosition: cardinal;
    FParent: TWinControl;
    FInterval: cardinal;
    FHorizonColor: TColor;
    FVerticalColor: TColor;
    FHandColor: TColor;
    FX: integer;
    FY: integer;
    FMyObject: TMyObject;
    FFlag: boolean;
    procedure SetHandLen(const Value: cardinal);
    procedure SetHorizonLen(const Value: cardinal);
    procedure SetVerticalLen(const Value: cardinal);
    procedure SetPosition(const Value: cardinal);
    procedure SetInterval(const Value: cardinal);
    procedure SetHandColor(const Value: TColor);
    procedure SetHorizonColor(const Value: TColor);
    procedure SetVerticalColor(const Value: TColor);
    procedure SetX(const Value: integer);
    procedure SetY(const Value: integer);
    procedure SetMyObject(const Value: TMyObject);
    procedure SetFlag(const Value: boolean);
    procedure RefreshArm();
  public
    constructor Create(const tmpParent: TWinControl; const tmpPosition: cardinal; const tmpVerticalLen: cardinal; const tmpHorizonLen: cardinal; const tmpHandLen: cardinal; const tmpVerticalColor: TColor; const tmpHorizonColor: TColor; const tmpHandColor: TColor); overload;
    constructor Create(const tmpParent: TWinControl; const tmpStartX, tmpStartY, tmpX, tmpY: integer; const tmpVerticalColor: TColor; const tmpHorizonColor: TColor; const tmpHandColor: TColor); overload;
    destructor Destroy(); override;
    procedure MoveTo(const tmpVerticalLen: integer; const tmpHorizonLen: integer; const tmpHandLen: integer);
    property VerticalLen: cardinal read FVerticalLen write SetVerticalLen;
    property HorizonLen: cardinal read FHorizonLen write SetHorizonLen;
    property HandLen: cardinal read FHandLen write SetHandLen;
    property Position: cardinal read FPosition write SetPosition;
    property Interval: cardinal read FInterval write SetInterval;
    property VerticalColor: TColor read FVerticalColor write SetVerticalColor;
    property HorizonColor: TColor read FHorizonColor write SetHorizonColor;
    property HandColor: TColor read FHandColor write SetHandColor;
    property X: integer read FX write SetX;
    property Y: integer read FY write SetY;
    property MyObject: TMyObject read FMyObject write SetMyObject;
    property Flag: boolean read FFlag write SetFlag;
    procedure VerticalMove(const tmpLen: integer);
    procedure HorizonMove(const tmpLen: integer);
    procedure HandMove(const tmpLen: integer);
    procedure MoveToXY(const tmpX, tmpY: integer);
    procedure HandGoBack();
    procedure HandGoY(const tmpY: integer);
    procedure HorizonGoBack();
    procedure HorizonGoX(const tmpX: integer);
    procedure HorizonGoXDirectly(const tmpX: integer);
    procedure HandGoYDirectly(const tmpY: integer);
    procedure MoveToXYDirectly(const tmpX, tmpY: integer);
  end;

implementation

{ TArm }

constructor TArm.Create(const tmpParent: TWinControl; const tmpPosition: cardinal; const tmpVerticalLen: cardinal; const tmpHorizonLen: cardinal; const tmpHandLen: cardinal; const tmpVerticalColor: TColor; const tmpHorizonColor: TColor; const tmpHandColor: TColor);
begin
  FParent := tmpParent;

  FArmVertical := TMyPanel.Create(nil);
  FArmVertical.Parent := FParent;
  FArmVertical.Left := tmpPosition;
  FArmVertical.Width := LEN;
  FArmVertical.Height := tmpVerticalLen;
  FArmVertical.Top := STARTY div 7;
  FArmVertical.Show;
  FVerticalLen := tmpVerticalLen;
  FInterval := 5;

  FArmHorizon := TMyPanel.Create(nil);
  FArmHorizon.Parent := FParent;
  FArmHorizon.Left := FArmVertical.Left + FArmVertical.Width;
  FArmHorizon.Top := FArmVertical.Top;
  FArmHorizon.Width := tmpHorizonLen;
  FArmHorizon.Height := LEN;
  FArmHorizon.Show;
  FHorizonLen := tmpHorizonLen;

  FArmHand := TMyPanel.Create(nil);
  FArmHand.Parent := FParent;
  FArmHand.Width := LEN;
  FArmHand.Left := FArmHorizon.Left + FArmHorizon.Width - FArmHand.Width;
  FArmHand.Height := tmpHandLen;
  FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
  FHandLen := tmpHandLen;
  FArmHand.Show;

  FArmVertical.SelfColor := tmpVerticalColor;
  FArmHorizon.SelfColor := tmpHorizonColor;
  FArmHand.SelfColor := tmpHandColor;

  Self.Flag := false;
  Self.MyObject := nil;
end;

constructor TArm.Create(const tmpParent: TWinControl; const tmpStartX, tmpStartY, tmpX, tmpY: integer; const tmpVerticalColor: TColor; const tmpHorizonColor: TColor; const tmpHandColor: TColor);
begin
  FParent := tmpParent;

  FArmVertical := TMyPanel.Create(nil);
  FArmVertical.Parent := FParent;
  FArmVertical.Left := tmpStartX;
  FArmVertical.Width := LEN;
  FArmVertical.Top := tmpStartY + LEN * 2;
  FArmVertical.Height := LEN * MAXJ - LEN;
  FArmVertical.Show;
  FVerticalLen := LEN * MAXJ;

  FArmHorizon := TMyPanel.Create(nil);
  FArmHorizon.Parent := FParent;
  FArmHorizon.Left := FArmVertical.Left + FArmVertical.Width;
  FArmHorizon.Top := FArmVertical.Top;
  FArmHorizon.Width := LEN * (tmpX);
  FArmHorizon.Height := LEN;
  FArmHorizon.Show;
  FHorizonLen := LEN * 2;

  FArmHand := TMyPanel.Create(nil);
  FArmHand.Parent := FParent;
  FArmHand.Width := LEN;
  FArmHand.Left := FArmHorizon.Left + FArmHorizon.Width - FArmHand.Width;
  FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
  FArmHand.Height := LEN * tmpY;
  FHandLen := LEN;
  FArmHand.Show;

  Self.X := (tmpX);
  Self.Y := (tmpY);

  FArmVertical.SelfColor := tmpVerticalColor;
  FArmHorizon.SelfColor := tmpHorizonColor;
  FArmHand.SelfColor := tmpHandColor;

  Self.Interval := 0;
  Self.MoveToXYDirectly(tmpX, tmpY);
end;

destructor TArm.Destroy;
begin
  FArmVertical.Free;
  FArmHorizon.Free;
  FArmHand.Free;
  inherited;
end;

procedure TArm.HandGoBack;
begin
  if Y = 1 then exit;
  Self.HandMove(-(Y - 1)* LEN);
  Y := 1;
end;

procedure TArm.HandGoY(const tmpY: integer);
begin
  HandGoBack;
  if Y = tmpY then exit;
  Self.HandMove((tmpY - Y)* LEN);
  Y := tmpY;
end;

procedure TArm.HandGoYDirectly(const tmpY: integer);
begin
  if Y = tmpY then exit;
  Self.HandMove((tmpY - Y) * LEN);
  Y := tmpY;
end;

procedure TArm.HandMove(const tmpLen: integer);
var
  tmpCurrentHeight, tmpNewHeight, i: integer;
begin
  tmpCurrentHeight := FArmHand.Height;
  if tmpLen > 0 then
  begin
    tmpNewHeight := tmpCurrentHeight + abs(tmpLen);
    for i := tmpCurrentHeight to tmpNewHeight do
    begin
      sleep(FInterval);
      FArmHand.Height := i;
      if flag then
      begin
        MyObject.Top := FArmHand.Height + FArmHand.Top;
      end;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(3000, 10);
  end else begin
    tmpNewHeight := tmpCurrentHeight - abs(tmpLen);
    for i := tmpCurrentHeight downto tmpNewHeight do
    begin
      sleep(FInterval);
      FArmHand.Height := i;
      if flag then
      begin
        MyObject.Top := FArmHand.Height + FArmHand.Top;
      end;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(3500, 10);
  end;
end;

procedure TArm.HorizonGoBack;
begin
  if X = 1 then exit;
  Self.HorizonMove(-LEN * (X - 1));
  X := 1;
end;

procedure TArm.HorizonGoX(const tmpX: integer);
begin
  HorizonGoBack;
  if X = tmpX then exit;
  Self.HorizonMove(LEN * (tmpX - X));
  X := tmpX;
end;

procedure TArm.HorizonGoXDirectly(const tmpX: integer);
begin
  if X = tmpX then exit;
  Self.HorizonMove((tmpX - X) * LEN);
  X := tmpX;
end;

procedure TArm.HorizonMove(const tmpLen: integer);
var
  tmpCurrentWidth, tmpNewWidth, i: integer;
begin
  tmpCurrentWidth := FArmHorizon.Width;
  if tmpLen > 0 then
  begin
    tmpNewWidth := tmpCurrentWidth + abs(tmpLen);
    for i := tmpCurrentWidth to tmpNewWidth do
    begin
      sleep(FInterval);
      FArmHorizon.Width := i;
      FHorizonLen := i;
      FArmHand.Left := FArmHorizon.Left + FArmHorizon.Width - FArmHand.Width;
      if flag then
      begin
        MyObject.Left := FArmHand.Left;
      end;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(2000, 10);
  end else begin
    tmpNewWidth := tmpCurrentWidth - abs(tmpLen);
    for i := tmpCurrentWidth downto tmpNewWidth do
    begin
      sleep(FInterval);
      FArmHorizon.Width := i;
      FHorizonLen := i;
      FArmHand.Left := FArmHorizon.Left + FArmHorizon.Width - FArmHand.Width;
      if flag then
      begin
        MyObject.Left := FArmHand.Left;
      end;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(2500, 10);
  end;
end;

procedure TArm.VerticalMove(const tmpLen: integer);
var
  tmpCurrentHeight, tmpCurrentTop, tmpNewTop, i: integer;
begin
  tmpCurrentHeight := FArmVertical.Height;
  tmpCurrentTop := FArmVertical.Top;
  if tmpLen > 0 then
  begin
    tmpNewTop := tmpCurrentTop - abs(tmpLen);
    for i := tmpCurrentTop downto tmpNewTop do
    begin
      sleep(FInterval);
      FArmVertical.Top := i;
      FVerticalLen := i;
      FArmHorizon.Top := i;
      FArmVertical.Height := tmpCurrentHeight - (i - tmpCurrentTop);
      FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(1000, 10);
  end else begin
    tmpNewTop := tmpCurrentTop + abs(tmpLen);
    for i := tmpCurrentTop to tmpNewTop do
    begin
      sleep(FInterval);
      FArmVertical.Top := i;
      FVerticalLen := i;
      FArmHorizon.Top := i;
      FArmVertical.Height := tmpCurrentHeight - (i - tmpCurrentTop);
      FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(1500, 10);
  end;
end;

procedure TArm.MoveTo(const tmpVerticalLen, tmpHorizonLen,
  tmpHandLen: integer);
begin
  Self.VerticalMove(tmpVerticalLen);
  Self.HorizonMove(tmpHorizonLen);
  Self.HandMove(tmpHandLen);
end;

procedure TArm.MoveToXY(const tmpX, tmpY: integer);
begin
  Self.HorizonGoX(RealXToX(tmpX));
  Self.HandGoY(RealYToY(tmpY));
end;

procedure TArm.MoveToXYDirectly(const tmpX, tmpY: integer);
begin
  Self.HandGoBack;
  Self.HorizonGoXDirectly(RealXToX(tmpX));
  Self.HandGoYDirectly(RealYToY(tmpY));
end;

procedure TArm.RefreshArm;
begin
  FArmVertical.Repaint;
  FArmHorizon.Repaint;
  FArmHand.Repaint;
end;

procedure TArm.SetFlag(const Value: boolean);
begin
  FFlag := Value;
end;

procedure TArm.SetHandColor(const Value: TColor);
begin
  FHandColor := Value;
  FArmHand.SelfColor := FHandColor;
end;

procedure TArm.SetHandLen(const Value: cardinal);
begin
  FHandLen := Value;
end;

procedure TArm.SetHorizonColor(const Value: TColor);
begin
  FHorizonColor := Value;
  FArmHorizon.SelfColor := FHorizonColor;
end;

procedure TArm.SetHorizonLen(const Value: cardinal);
begin
  FHorizonLen := Value;
end;

procedure TArm.SetInterval(const Value: cardinal);
begin
  FInterval := Value;
end;

procedure TArm.SetMyObject(const Value: TMyObject);
begin
  FMyObject := Value;
end;

procedure TArm.SetPosition(const Value: cardinal);
begin
  FPosition := Value;
end;

procedure TArm.SetVerticalColor(const Value: TColor);
begin
  FVerticalColor := Value;
  FArmVertical.SelfColor := FVerticalColor;
end;

procedure TArm.SetVerticalLen(const Value: cardinal);
begin
  FVerticalLen := Value;
end;

procedure TArm.SetX(const Value: integer);
begin
  FX := Value;
end;

procedure TArm.SetY(const Value: integer);
begin
  FY := Value;
end;

end.
