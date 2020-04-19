program HamNewInfo;

{$R 'WinXP.res' 'WinXP.rc'}

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmHaupt},
  cHamNewInfo in 'cHamNewInfo.pas',
  synautil in 'synautil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HamNeuInfo';
  Application.CreateForm(TfrmHaupt, frmHaupt);
  Application.Run;
end.
