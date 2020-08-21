program RobotArm_XE5;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Arm in 'Arm.pas',
  MyPanel in 'MyPanel.pas',
  MyObject in 'MyObject.pas',
  Common in 'Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
