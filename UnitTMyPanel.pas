unit UnitTMyPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, UnitCommon;

type
  TMyPanel = class(TPanel)
  private
    FSelfColor: TColor;
    procedure SetSelfColor(const Value: TColor);
  published
  public
    constructor Create(tmpOwner: TComponent); reintroduce;
    procedure ProcessMessage_WM_PAINT(var tmpMsg: TMessage); message WM_PAINT;
    property SelfColor: TColor read FSelfColor write SetSelfColor;
  end;

implementation

{ TMyPanel }

constructor TMyPanel.Create(tmpOwner: TComponent);
begin
  inherited Create(tmpOwner);
end;

procedure TMyPanel.ProcessMessage_WM_PAINT(var tmpMsg: TMessage);
begin
  inherited;
//  Self.Canvas.Brush.Color := FSelfColor;
//  Self.Canvas.Pen.Color := clRed;
//  Self.Canvas.Rectangle(1, 1, Self.Width - 1, Self.Height - 1);
end;

procedure TMyPanel.SetSelfColor(const Value: TColor);
begin
  FSelfColor := Value;
  Color := Value;
end;

end.
