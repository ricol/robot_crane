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
    constructor Create(const parentControl: TWinControl; const position: cardinal; const verticalLen: cardinal; const horizonalLen: cardinal; const handLen: cardinal; const verticalColor: TColor; const horizonalColor: TColor; const handColor: TColor); overload;
    constructor Create(const parentControl: TWinControl; const startX, startY, m, n: integer; const verticalColor: TColor; const horizonColor: TColor; const handColor: TColor); overload;
    destructor Destroy(); override;
    procedure MoveTo(const verticalLen: integer; const horizonLen: integer; const handLen: integer);
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
    procedure VerticalMove(const len: integer);
    procedure HorizonMove(const len: integer);
    procedure HandMove(const len: integer);
    procedure MoveToXY(const _x, _y: integer);
    procedure HandGoBack();
    procedure HandGoY(const _y: integer);
    procedure HorizonGoBack();
    procedure HorizonGoX(const _x: integer);
    procedure HorizonGoXDirectly(const _x: integer);
    procedure HandGoYDirectly(const _y: integer);
    procedure MoveToXYDirectly(const _x, _y: integer);
  end;

implementation

{ TArm }

constructor TArm.Create(const parentControl: TWinControl; const position: cardinal; const verticalLen: cardinal; const horizonalLen: cardinal; const handLen: cardinal; const verticalColor: TColor; const horizonalColor: TColor; const handColor: TColor);
begin
  FParent := parentControl;

  FArmVertical := TMyPanel.Create(nil);
  FArmVertical.Parent := FParent;
  FArmVertical.Left := position;
  FArmVertical.Width := LEN;
  FArmVertical.Height := verticalLen;
  FArmVertical.Top := STARTY div 7;
  FArmVertical.Show;
  FVerticalLen := verticalLen;
  FInterval := 5;

  FArmHorizon := TMyPanel.Create(nil);
  FArmHorizon.Parent := FParent;
  FArmHorizon.Left := FArmVertical.Left + FArmVertical.Width;
  FArmHorizon.Top := FArmVertical.Top;
  FArmHorizon.Width := horizonalLen;
  FArmHorizon.Height := LEN;
  FArmHorizon.Show;
  FHorizonLen := horizonalLen;

  FArmHand := TMyPanel.Create(nil);
  FArmHand.Parent := FParent;
  FArmHand.Width := LEN;
  FArmHand.Left := FArmHorizon.Left + FArmHorizon.Width - FArmHand.Width;
  FArmHand.Height := handLen;
  FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
  FHandLen := handLen;
  FArmHand.Show;

  FArmVertical.SelfColor := verticalColor;
  FArmHorizon.SelfColor := horizonalColor;
  FArmHand.SelfColor := handColor;

  Self.Flag := false;
  Self.MyObject := nil;
end;

constructor TArm.Create(const parentControl: TWinControl; const startX, startY, m, n: integer; const verticalColor: TColor; const horizonColor: TColor; const handColor: TColor);
begin
  FParent := parentControl;

  FArmVertical := TMyPanel.Create(nil);
  FArmVertical.Parent := FParent;
  FArmVertical.Left := startX;
  FArmVertical.Width := LEN;
  FArmVertical.Top := startY + LEN * 2;
  FArmVertical.Height := LEN * MAXJ - LEN;
  FArmVertical.Show;
  FVerticalLen := LEN * MAXJ;

  FArmHorizon := TMyPanel.Create(nil);
  FArmHorizon.Parent := FParent;
  FArmHorizon.Left := FArmVertical.Left + FArmVertical.Width;
  FArmHorizon.Top := FArmVertical.Top;
  FArmHorizon.Width := LEN * (m);
  FArmHorizon.Height := LEN;
  FArmHorizon.Show;
  FHorizonLen := LEN * 2;

  FArmHand := TMyPanel.Create(nil);
  FArmHand.Parent := FParent;
  FArmHand.Width := LEN;
  FArmHand.Left := FArmHorizon.Left + FArmHorizon.Width - FArmHand.Width;
  FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
  FArmHand.Height := LEN * n;
  FHandLen := LEN;
  FArmHand.Show;

  Self.X := (m);
  Self.Y := (n);

  FArmVertical.SelfColor := verticalColor;
  FArmHorizon.SelfColor := horizonColor;
  FArmHand.SelfColor := handColor;

  Self.Interval := 0;
  Self.MoveToXYDirectly(m, n);
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

procedure TArm.HandGoY(const _y: integer);
begin
  HandGoBack;
  if Y = _y then exit;
  Self.HandMove((_y - Y)* LEN);
  Y := _y;
end;

procedure TArm.HandGoYDirectly(const _y: integer);
begin
  if Y = _y then exit;
  Self.HandMove((_y - Y) * LEN);
  Y := _y;
end;

procedure TArm.HandMove(const len: integer);
var
  currentHeight, newHeight, i: integer;
begin
  currentHeight := FArmHand.Height;
  if len > 0 then
  begin
    newHeight := currentHeight + abs(len);
    for i := currentHeight to newHeight do
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
    newHeight := currentHeight - abs(len);
    for i := currentHeight downto newHeight do
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

procedure TArm.HorizonGoX(const _x: integer);
begin
  HorizonGoBack;
  if X = _x then exit;
  Self.HorizonMove(LEN * (_x - X));
  X := _x;
end;

procedure TArm.HorizonGoXDirectly(const _x: integer);
begin
  if X = _x then exit;
  Self.HorizonMove((_x - X) * LEN);
  X := _x;
end;

procedure TArm.HorizonMove(const len: integer);
var
  currentWidth, newWidth, i: integer;
begin
  currentWidth := FArmHorizon.Width;
  if len > 0 then
  begin
    newWidth := currentWidth + abs(len);
    for i := currentWidth to newWidth do
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
    newWidth := currentWidth - abs(len);
    for i := currentWidth downto newWidth do
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

procedure TArm.VerticalMove(const len: integer);
var
  currentHeight, currentTop, newTop, i: integer;
begin
  currentHeight := FArmVertical.Height;
  currentTop := FArmVertical.Top;
  if len > 0 then
  begin
    newTop := currentTop - abs(len);
    for i := currentTop downto newTop do
    begin
      sleep(FInterval);
      FArmVertical.Top := i;
      FVerticalLen := i;
      FArmHorizon.Top := i;
      FArmVertical.Height := currentHeight - (i - currentTop);
      FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(1000, 10);
  end else begin
    newTop := currentTop + abs(len);
    for i := currentTop to newTop do
    begin
      sleep(FInterval);
      FArmVertical.Top := i;
      FVerticalLen := i;
      FArmHorizon.Top := i;
      FArmVertical.Height := currentHeight - (i - currentTop);
      FArmHand.Top := FArmVertical.Top + FArmHorizon.Height;
      RefreshArm;
      Application.ProcessMessages;
    end;
//    Windows.Beep(1500, 10);
  end;
end;

procedure TArm.MoveTo(const verticalLen, horizonLen,
  handLen: integer);
begin
  Self.VerticalMove(verticalLen);
  Self.HorizonMove(horizonLen);
  Self.HandMove(handLen);
end;

procedure TArm.MoveToXY(const _x, _y: integer);
begin
  Self.HorizonGoX(RealXToX(_x));
  Self.HandGoY(RealYToY(_y));
end;

procedure TArm.MoveToXYDirectly(const _x, _y: integer);
begin
  Self.HandGoBack;
  Self.HorizonGoXDirectly(RealXToX(_x));
  Self.HandGoYDirectly(RealYToY(_y));
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
