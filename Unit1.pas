unit Unit1;

{
HamNewInfo (c) 2006 by Remo Müller
This program is free software. You can redistribute it and/or modify it under
the terms of the GNU General Public License - Version 2 as published by the
Free Software Foundation. GPL-Version 2

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details.
}
interface

uses
  Windows, Messages, Variants, Classes, Graphics, Controls, Forms, StdCtrls,
  cHamNewInfo, FileCtrl;

type
  TfrmHaupt = class(TForm)
    lblInfo: TLabel;
    cmdBeenden: TButton;
    lblInfo2: TLabel;
    procedure cmdBeendenClick(Sender: TObject);
    procedure OnActivate(Sender: TObject);
    procedure OnCreate(Sender: TObject);


  private
    { Private-Deklarationen }
  public

  end;


var
  frmHaupt: TfrmHaupt;




implementation

{$R *.dfm}




procedure TfrmHaupt.cmdBeendenClick(Sender: TObject);
begin
Application.Terminate;
end;

procedure TfrmHaupt.OnActivate(Sender: TObject);
begin
lblInfo.Caption := 'Dieses Programm generiert eine Info-EMail für das' + #13#10
+'Programm "Hamster".';
lblInfo2.Caption :='Version 0.1.0.4  (Freeware)';
end;

procedure TfrmHaupt.OnCreate(Sender: TObject);
begin
if ParamCount>0 then begin
    myprog.commando := ParamStr(1);
    if ParamStr(1)='/end' then begin
    HamNewInfo_End;
    end;

    if ParamStr(1)='/start' then begin
    HamNewInfo_Start;
    end;
end;
end;

end.
