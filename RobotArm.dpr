program RobotArm;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitTArm in 'UnitTArm.pas',
  UnitTMyPanel in 'UnitTMyPanel.pas',
  UnitTMyObject in 'UnitTMyObject.pas',
  UnitCommon in 'UnitCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
