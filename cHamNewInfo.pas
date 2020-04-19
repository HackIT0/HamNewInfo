unit cHamNewInfo;
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

type x1 = record
        hamsterpfad: String;
        mailuser: integer;
        newscount: integer;
        maildat: boolean;
        commando: String;
        filter: integer;
        error : boolean;
  end;
  type x2 = record
        name: String;
        emails: integer;
        neumail: integer;
  end;
  type x3 = record
        name: String;
        nachrichten: integer;
        neue: integer;
  end;

function Dateienanzahl(Pfad: String): integer;
procedure SaveInfos;
procedure CreateInfos;
procedure CreateInfos2;
procedure MailVergleich;
procedure Report_Mail;
procedure HamNewInfo_End;
procedure HamNewInfo_Start;
function create_mid: String;

var myprog: x1;                //Programinterne, globale Variablen
var mailuser: array of x2;     //Liste für EMailuser
var mailuser2: array of x2;    //Liste für EMailuser zum Vergleich
var newsgroup: array of x3;    //Liste für Newsgruppen
var newsgroup2: array of x3;    //Liste für Newsgruppen zum Vergleich



implementation

uses
   Windows, inifiles, SysUtils, Classes, Forms, Math, synautil, Unit1;

{==============================================================================}
{ '----------------------------------------------------------------------}
{ | Funktion zum Suchen der Dateien (Anzahl) in einen Verzeichnis        |
  |                                                                      |
  `----------------------------------------------------------------------'}

function Dateienanzahl(Pfad: String): integer;
var
    FileAttrs, Count: Integer;
    SRec: TSearchRec;
    retval: Integer;
    oldlen: Integer;
begin

    oldlen := Length( Pfad );
      (* phase 1, look for normal files *)
      retval := FindFirst( Pfad, faAnyFile, SRec );
      While retval = 0 Do Begin
        If (SRec.Attr and (faDirectory or faVolumeID)) = 0 Then
          (* we found a file, not a directory or volume label,
             log it. Bail out if the log function returns false. *)
         Count:= Count +1;

        retval := FindNext( SRec );
      End;
      FindClose( SRec );
      Result:=Count;
end;
{ '----------------------------------------------------------------------}
{ | Alle Informationen zur Anzahl der EMails der Mailuser und            |
  | Anzahl der Nachrichten in Newsgruppen als INI-File 'mail.dat' sicher.|
  `----------------------------------------------------------------------'}

procedure SaveInfos;
var i: integer;
    ExePfad : string;
    ini: TIniFile;

begin
ExePfad := ExtractFilePath(ParamStr(0)) + 'mail.dat';
ini := TIniFile.Create(ExePfad);
ini.WriteInteger('Allgemein','Users',myprog.mailuser);

For i:=1 to myprog.mailuser do begin
ini.WriteString(IntToStr(i),'Username',mailuser[i].name );
ini.WriteInteger(IntToStr(i),'EMails',mailuser[i].emails);
end;

//Newsgroups - Info's speichern
ExePfad := ExtractFilePath(ParamStr(0)) + 'news.dat';
ini := TIniFile.Create(ExePfad);
ini.WriteInteger('Allgemein','Newsgroups',myprog.newscount);

For i:=1 to myprog.newscount do begin
ini.WriteString(IntToStr(i),'Newsgroup',newsgroup[i].name );
ini.WriteInteger(IntToStr(i),'Anzahl',newsgroup[i].nachrichten);
end;

WriteProfileString(nil, nil, nil);
ini.Free;
end;

{ '----------------------------------------------------------------------}
{ | Alle Informationen zur Anzahl der EMails der Mailuser und            |
  | Anzahl der Nachrichten in Newsgruppen >>erstellen<<.                 |
  | Der aktuelle IST-Zustand wird erfasst.                               |
  `----------------------------------------------------------------------'}

// Erstellt Infos über Mailuser
procedure CreateInfos;
var ExePfad,DataPfad, temp : string;
    Count: Integer;
    Templist: TStrings;
    ini: TIniFile;
begin
//Hamsterpfad auslesen
ExePfad := ExtractFilePath(ParamStr(0)) + 'hamnewinfo.ini';
ini := TIniFile.Create(ExePfad);
myprog.hamsterpfad := ini.ReadString('Einstellungen','Hamster','');

//Benutzerzahl auslesen
ini:=TIniFile.Create(myprog.hamsterpfad + 'Accounts.!!!');
myprog.mailuser:=ini.ReadInteger('Common','UserIDMax',0);

//Benutzervariable dimensionieren
SetLength(mailuser, myprog.mailuser +1 );

//Alle Usernamen einlesen und deren EMailsanzahl
Count:=0;
temp:='';
for Count:=1 to myprog.mailuser do begin
mailuser[Count].name := ini.ReadString(IntToStr(Count),'Username','leer');
temp:=myprog.hamsterpfad + 'mails\' + mailuser[Count].name + '\*.*';
mailuser[Count].emails:=Dateienanzahl(temp);
end;

//Newsgruppennamen auslesen (Groups.hst)
Templist:= TStringlist.Create ;
Templist.LoadFromFile(myprog.hamsterpfad + 'Groups.hst');
myprog.newscount:= templist.Count ;

//Benutzervariable dimensionieren
SetLength(newsgroup, myprog.newscount + 1);

//Newsdaten auslesen (Namen und Anzahl der Nachrichten)
Count:=0;
For Count:=0 to myprog.newscount -1 do begin
newsgroup[Count +1 ].name:= Templist.Strings[Count];
DataPfad:= myprog.hamsterpfad + 'Groups\' + newsgroup[Count +1 ].name + '\data.ini';
ini:=TIniFile.Create(DataPfad);
newsgroup[Count +1 ].nachrichten:= ini.ReadInteger('Ranges','Local.Max',0);
end;

WriteProfileString(nil, nil, nil);
ini.Free;
end;

{ '----------------------------------------------------------------------}
{ | Alle Informationen zur Anzahl der EMails der Mailuser und            |
  | Anzahl der Nachrichten in Newsgruppen >>erstellen<<.                 |
  | Der neue IST-Zustand wird erfasst.  / END   Zum Vergelich            |
  `----------------------------------------------------------------------'}

procedure CreateInfos2;
var ExePfad,DataPfad,temp : string;
    Count: Integer;
    ini: TIniFile;

begin
//Hamsterpfad auslesen
ExePfad := ExtractFilePath(ParamStr(0)) + 'hamnewinfo.ini';
ini := TIniFile.Create(ExePfad);
myprog.hamsterpfad := ini.ReadString('Einstellungen','Hamster','');

//Benutzerzahl auslesen
ExePfad := ExtractFilePath(ParamStr(0)) + 'mail.dat';
ini := TIniFile.Create(ExePfad);
myprog.mailuser:=ini.ReadInteger('Allgemein','Users',0);

//Benutzervariable dimensionieren
SetLength(mailuser2, myprog.mailuser +1 );

//Alle Usernamen einlesen und deren EMailsanzahl
Count:=0;
temp:='';
for Count:=1 to myprog.mailuser do begin
mailuser2[Count].name := ini.ReadString(IntToStr(Count),'Username','leer');
temp:=myprog.hamsterpfad + 'mails\' + mailuser2[Count].name + '\*.*';
mailuser2[Count].emails:=Dateienanzahl(temp);
end;

//Newsgruppennamen einlesen (news.dat)
ExePfad := ExtractFilePath(ParamStr(0)) + 'news.dat';
ini := TIniFile.Create(ExePfad);
myprog.newscount:=ini.ReadInteger('Allgemein','Newsgroups',0);

//Benutzervariable dimensionieren
SetLength(newsgroup2, myprog.newscount + 1);

//Newsgruppennamen einlesen aus news.dat
ExePfad := ExtractFilePath(ParamStr(0)) + 'news.dat';
ini := TIniFile.Create(ExePfad);
Count:=0;
For Count:=1 to myprog.newscount do begin
newsgroup2[Count].name:= ini.ReadString(IntToStr(Count),'Newsgroup','leer');
end;

//Newsanzahl neu erfassen
For Count:=1 to myprog.newscount do begin
DataPfad:= myprog.hamsterpfad + 'Groups\' + newsgroup2[Count].name + '\data.ini';
ini:=TIniFile.Create(DataPfad);
newsgroup2[Count].nachrichten:= ini.ReadInteger('Ranges','Local.Max',0);
end;

WriteProfileString(nil, nil, nil);
ini.Free;
end;

{ .----------------------------------------------------------------------.
  | Alten Infostand laden und mit neuen Infostand vergleichen            |
  | Der neue Status wird erfasst.  / END   Zum Vergleich                 |
  `----------------------------------------------------------------------'}

procedure MailVergleich;
var ExePfad: String;
    i: Integer;
    ini: TIniFile;

begin
//Alten EMailstand laden
ExePfad := ExtractFilePath(ParamStr(0)) + 'mail.dat';
ini := TIniFile.Create(ExePfad);
myprog.mailuser:= ini.ReadInteger('Allgemein','Users',0);

//Benutzervariable dimensionieren
SetLength(mailuser, myprog.mailuser +1 );

//Usernamen und EMailanzahl auslesen
For i:=1 to myprog.mailuser do begin
mailuser[i].name:= ini.ReadString(IntToStr(i),'Username','none');
mailuser[i].emails:= ini.ReadInteger(IntToStr(i),'Emails',0);
end;

//Alten Newsbestand laden
ExePfad := ExtractFilePath(ParamStr(0)) + 'news.dat';
ini := TIniFile.Create(ExePfad);
myprog.newscount := ini.ReadInteger('Allgemein','Newsgroups',0);

//Benutzervariable "NewsGroup" dimensionieren
SetLength(newsgroup, myprog.newscount +1 );

//Newsgroup-Namen und alte Nachrichtenzahl auslesen
For i:=1 to myprog.newscount  do begin
newsgroup[i].name := ini.ReadString(IntToStr(i),'Newsgroup','none');
newsgroup[i].nachrichten:= ini.ReadInteger(IntToStr(i),'Anzahl',0);
end;

//Neuen Status erfassen - Prozedur "CreateInfo2" aufrufen
CreateInfos2;


//Neue EMails auszählen
For i:=1 to myprog.mailuser do begin
mailuser[i].neumail := mailuser2[i].emails - mailuser[i].emails ;
end;
//Neue Newsnachrichten auszählen
For i:=1 to myprog.newscount do begin
newsgroup[i].neue := newsgroup2[i].nachrichten - newsgroup[i].nachrichten;
end;

WriteProfileString(nil, nil, nil);
ini.Free;
end;

{ .----------------------------------------------------------------------.
  | Der Report wird nun erstellt und als Datei abgespeichert.            |
  |   / END                                                              |
  `----------------------------------------------------------------------'}

procedure Report_Mail;
var TempList: TStrings;
    i,x1,x2,x3, cDatei: Integer;
    ExePfad, fuelle, saveto: String;
    ini: TIniFile;

begin
//SMTP-Einstellungen auslesen aus hamnewinfo.ini
ExePfad := ExtractFilePath(ParamStr(0)) + 'hamnewinfo.ini';
ini := TIniFile.Create(ExePfad);

//message1.From.Text :=ini.ReadString('SMTP','From','noreplay@exsample.com');
//message1.Sender.Text :=ini.ReadString('SMTP','From','test@exsample.com');
//message1.Recipients.EMailAddresses :=ini.ReadString('SMTP','To','test@exsample.com');
//message1.Subject := 'Hamster-Report: ' + DateTimeToStr(Now) ;

//Nachrichtenblock erstellen
TempList := TStringList.Create;

{Header erstellen ...}

if ini.ReadString('User','Account','Admin')='Mail.Out' then begin
Templist.Add('!MAIL FROM: <' + ini.ReadString('User','From','hamster@post.hamster') + '>');
TempList.Add('!RCPT TO: <' + ini.ReadString('User','To','postmaster@post.hamster') + '>');
end;

TempList.Add('Date: ' + Rfc822DateTime(now) );
TempList.Add('Message-ID: ' + create_mid + '@' + ini.ReadString('User','FQND','mail.hamster') );
TempList.Add('To: <' + ini.ReadString('User','To','postmaster@post.hamster') + '>' );
Templist.Add('From: <' + ini.ReadString('User','From','hamster@post.hamster') + '>');
TempList.Add('Subject: Hamster-Report: ' + DateTimeToStr(Now) );
TempList.Add(#13#10);
 
{Nachrichtentext ...}
TempList.Add('Statusbericht über neue EMails:  ' + DateTimeToStr(Now));
Templist.Add('----------------------------------------------------------------');
Templist.Add('  ');

x3:=0;

For i:=1 to myprog.mailuser do begin
  x1:= 47 - (Length(mailuser[i].name) +1)  ;
  fuelle :='';
    For x2:=1 to x1 do begin
    fuelle := fuelle + '.';
    end;

    if mailuser[i].neumail > 0 then
    begin
        Templist.Add(mailuser[i].name + ' ' + fuelle + ' ' +IntToStr(mailuser[i].neumail) + ' neue EMail(s).');
    end;
    x3:= x3 + mailuser[i].neumail;
end;

Templist.Add('  ');
Templist.Add('----------------------------------------------------------------');
Templist.Add('Insgesamt sind: ' + IntToStr(x3) + ' neue EMail(s) angekommen.');
Templist.Add('  ');
Templist.Add('  ');

// ----------------------- NEWSGRUPPEN ---------------------------------------

TempList.Add('Statusbericht über neue Beiträge in Newsgruppen:  ');
Templist.Add('----------------------------------------------------------------');
Templist.Add('  ');

x3:=0;

For i:=1 to myprog.newscount do begin
  x1:= 47 - (Length(newsgroup[i].name ) +1)  ;
  fuelle :='';
    For x2:=1 to x1 do begin
    fuelle := fuelle + '.';
    end;

    if newsgroup[i].neue > 0 then
    begin
        Templist.Add(newsgroup[i].name  + ' ' + fuelle + ' ' +IntToStr(newsgroup[i].neue) + ' neue Beiträge.');
    end;
    x3:= x3 + newsgroup[i].neue;
end;

Templist.Add('  ');
Templist.Add('----------------------------------------------------------------');
Templist.Add('Insgesamt sind: ' + IntToStr(x3) + ' Newsgruppenbeiträge angekommen.');
//message1.Body := Templist;

{Dateinamen erstellen}
cDatei:= ini.ReadInteger('User','Index',0);

saveto:= ini.ReadString('Einstellungen','Hamster','C:\') + 'Mails\';
saveto:= saveto + ini.ReadString('User','Account','Admin');
saveto:= saveto + '\00' + IntToStr(cDatei) + '.msg';

inc(cDatei);
ini.WriteInteger('User','Index',cDatei);

Templist.SaveToFile(saveto);

WriteProfileString(nil, nil, nil);
Templist.Free;


end;

{ .----------------------------------------------------------------------.
  | Befehlsfolge für HamNewInfo / END                                    |
  | Procedure: HamNewInfo_End;                                           |
  `----------------------------------------------------------------------'}

procedure HamNewInfo_End;
var ExePfad : string;
begin

ExePfad := ExtractFilePath(ParamStr(0)) + 'mail.dat';
myprog.maildat:=false;

  if FileExists(ExePfad) then
  begin
    myprog.maildat:=true;
  end;

  if myprog.maildat=false then
  begin
  application.Terminate;
  end;

  if myprog.maildat=true then
  begin
  //Auswertung
  MailVergleich;
  Report_Mail;
  application.Terminate;

  end;
end;

{ .----------------------------------------------------------------------.
  | Befehlsfolge für HamNewInfo / START                                  |
  | Procedure: HamNewInfo_Start;                                         |
  `----------------------------------------------------------------------'}

procedure HamNewInfo_Start;

begin

    CreateInfos;
    SaveInfos;
    application.Terminate;
  end;


{ .----------------------------------------------------------------------.
  | XORVerschl                                                           |
  |verschlüsselt eine Zeichenkette mit einen Kennwort.                   |
  `----------------------------------------------------------------------'}

function XORverschl(const s,Passwort: String):String;
  //Damit ein Textfile wieder ein Textfile wird, werden
  //Steuerzeichen wie #13#10 nicht verschlüsselt, sondern bleiben erhalten.
  // const Passwort ='123mugg7689'; //oder Benutzer gibt es ein
  var i,q,nr :integer;
begin
  result := s;
  q:=1;
  for i:=1 to Length(result) do  Begin
    if result[i] >= ' ' then BEgin
      nr := Ord(result[i]) XOR Ord(Passwort[q]);
      if nr >= 32 then result[i]:=Chr(nr);
    ENd;
    inc(q);
   if q > length(Passwort) then q:=1;
  end;
end;

//------------------------------------------------------------------------------

{ .----------------------------------------------------------------------.
  | create_mid                                                           |
  |Generiert eine Message-ID                                             |
  `----------------------------------------------------------------------'}

function create_mid: String;

var
  Present: TDateTime;
  iJahr, iMonat, iTag : Word;
  Hour, Min, Sec, MSec: Word;
  tmp1, tmp2, tmp3, Code, x, z : String;
  i: Integer;

begin

Present:= Now;
DecodeDate(Present, iJahr, iMonat, iTag);
DecodeTime(Present, Hour, Min, Sec, MSec);

tmp1:= IntToStr(iTag) + intTostr(iMonat) + IntToStr(iJahr) + IntToStr(Hour);
tmp1:= tmp1 + IntToStr(Min) + IntToStr(Sec) + IntToStr(MSec);

tmp2:= IntToStr(RandomRange(0,300000)) + 'mQgFT';
tmp3:=XORverschl(tmp1,tmp2);
Code:='';

for i := 1 to  length(tmp3) do begin
           z := copy(tmp3,i,1);    // Zeichen lesen
            (* Zeichen tauschen *)
            x := z;

            if ((z < '0') or (z > '9')) and ((z < 'a') or (z > 'z'))  then
            // nichts machen
            else
            x:= chr(RandomRange(48,57));

            if (z = '`') or (z = '/') or (z = '_')then
            x:= chr(RandomRange(97,122));

            if (z = '[') or (z = ']') or (z = '\') or (z = '^')then
            x:= chr(RandomRange(97,100));

            Code := Code + LowerCase(x);


end;
Result:= Code;
end;

//------------------------------------------------------------------------------

{===== END cHamNewInfo.pas ============================================}




end.
