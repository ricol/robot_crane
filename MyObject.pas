unit MyObject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MyPanel, Common;

type
  TMyObject = class(TPanel)
  private
    FParent: TComponent;
    FFlag: boolean;
    FInterval: cardinal;
    FX: integer;
    FY: integer;
    procedure SetFlag(const Value: boolean);
    procedure SetInterval(const Value: cardinal);
    procedure SetX(const Value: integer);
    procedure SetY(const Value: integer);
  public
    property X: integer read FX write SetX;
    property Y: integer read FY write SetY;
    property Flag: boolean read FFlag write SetFlag;
    property Interval: cardinal read FInterval write SetInterval;
    procedure ShowPosition();
    procedure MoveTo(const tmpX, tmpY: integer);
    constructor Create(Owner: TComponent; tmpX, tmpY: integer; tmpFlag: boolean); reintroduce;
    destructor Destroy(); override;
  end;

implementation

{ TMyObject }

constructor TMyObject.Create(Owner: TComponent; tmpX, tmpY: integer;
  tmpFlag: boolean);
begin
  inherited Create(Owner);
  FParent := Owner;
  Self.Parent := TWinControl(FParent);
  Self.X := tmpX;
  Self.Y := tmpY;
  Self.Flag := tmpFlag;
  Self.Interval := 10;
  Self.Width := LEN;
  Self.Height := LEN;
  Self.Caption := Format('%2d-%2d', [tmpX, tmpY]);
  Self.Color := RGB(random(255), random(255), random(255));
  Self.Show;
  Self.ShowPosition;
end;

destructor TMyObject.Destroy;
begin

  inherited;
end;

procedure TMyObject.MoveTo(const tmpX, tmpY: integer);
begin
  Self.X := tmpX;
  Self.Y := tmpY;
  Self.ShowPosition;
end;

procedure TMyObject.SetFlag(const Value: boolean);
begin
  FFlag := Value;
end;

procedure TMyObject.SetInterval(const Value: cardinal);
begin
  FInterval := Value;
end;

procedure TMyObject.SetX(const Value: integer);
begin
  FX := Value;
end;

procedure TMyObject.SetY(const Value: integer);
begin
  FY := Value;
end;

procedure TMyObject.ShowPosition;
begin
  Self.Left := XToLeft(X);
  Self.Top := YToTop(Y);
  Application.ProcessMessages;
end;

end.
