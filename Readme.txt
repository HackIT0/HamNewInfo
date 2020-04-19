Readme.txt

HamNewInfo Version 0.1.0.4
OpenSource - Unter GUN GPL-Licenc V2

Allgemeines
===========
Immer wieder hat man sich beim Abholen von EMails und Newsgruppen mit
Hamster [1] gefragt, wieviele EMail in den einzelnen Postf�chern
(Accounts - <Hamsterverzeichnis>/Mails/<Account>) hinzugekommen sind.
Dies trifft auch f�r Newsgruppen zu (<Hamsterverzeichnis>/Groups/
<Newsgruppe>).
Dieses Problem erledigt nun HamNewInfo. Es erfasst den aktuellen
Datenbestand f�r EMails und Newsgruppen und speichert diese als
Information ab. Bei n�chsten Aufruf von HamNewInfo wird der neue
Datenbestand an Emails und Newsgruppen erfasst und mit den alten,
gespeicherten Stand verglichen und nun eine Infonachricht erstellt.
Die Nachricht wird als Textdatei einen Account bei Hamster, also
in den entsprechenden Verzeichnis abgespeichert.

Das Programm selbst ist mit Borland Delphi 7 - Personaledition
erstellt wurden und ben�tigt keine Laufzeitbibilotheken oder
ActiveX-Steuerelemente.
Der Quellcode des Programms kann bei Anfrage zugestellt werden.

Installation
============
Dieses Programm ben�tigt keine Laufzeitbibilotheken, DLL-Dateien oder
ActiveX-Steuerelemente. Zur Nutzungs des Programms kopieren Sie
einfach die Datei "Hamnewinfo.exe" und die Datei "Hamnewinfo.ini" in
ein Verzeichnis Ihrer Wahl, da Sie ja den Pfad zum Programm in einen
Skript angeben m�ssen.

1. Funktionsweise
=================
HamNewInfo setzt Hamster vorraus. Dieses Programm mu� eingerichtet
und funktionsf�hig sein. HamNewInfo wird �ber die Befehlszeile
aufgerufen. Der Aufruf selbst erfolgt in einen Hamster-Script
(*.hsc). Alle Einstellungen zu HamNewInfo werden in der INI-Datei
"HamNewInfo.ini" vorgenommen.


1.1 Aktuellen Status erfassen
=============================
Bevor ein Hamsterscript die neuen EMails und Newsgruppen abholt,
sollte der aktuelle Status (Anzahl an EMails pro Account und
Anzahl der Nachrichten in den einzelnen Newsgruppen) ermittelt
werden.


Hierzu ruft man das Programm "HamNewInfo" �ber die Kommandozeile 
mit den Start-Befehl auf:

.-----------------------------------------------------------------.     
|                     HamNewInfo.exe /start                       |
`-----------------------------------------------------------------'     

In einen Hamster-Skript:
     
execute( "E:\internet\hamster\tools\HamNewInfo.exe /start", "", 0, false ) 
     
Hierbei werden die Einstellungen in der HamNewInfo.ini ausgelesen. 
Genauer gesagt der Pfad, zum Hamsterverzeichnis wird ausgelesen. 

.-- [ HamNewInfo.ini ]-----------------------------------------------.
|  [Einstellungen]                                                   |
|  Hamster=E:\internet\hamster\                                      |
`--------------------------------------------------------------------'

Nun werden die Benutzer unter Hamster erfasst und deren Emails in der 
Datei "mail.dat" (Im Programmverzeichnis von HamNewInfo) abgespeichert.
Bei den Newsgruppen werden auch erfasst und die Anzahl der News in der 
Datei "news.dat" gespeichert.


1.2 Ver�nderungen erfassen
==========================
Nachdem nun alle �bertragungen an EMails und Newsgruppen erledigt sind, 
mu� das Programm "HamNewInfo" erneut aufgerufen werden. 
Nun wird der aktuelle Status erfasst und mit den gespeicherten Status ein 
Vergleich gemacht. Hierbei wird ein neuer Status mit den Ver�nderungen
als Datei in das Accounterverzeichnis des in der HamNewInfo.ini unter:

.-- [ HamNewInfo.ini ]-----------------------------------------------.
|  [User]                                                            |
|  Account=Admin                                                     |
`--------------------------------------------------------------------'

abgelgten Namen gespeichert. In diesen gezeigten Beispiel (Ausschnitt
aus der Hamnewinfo.ini) aus der INI-Datei w�rde die Infonachricht unter 
E:\internet\hamster\Admin\<Name>.msg abgespeichert.

 
Der Aufruf:

.-----------------------------------------------------------------.     
|                     HamNewInfo.exe /end                         |
`-----------------------------------------------------------------'     
     
In einen Hamster-Skript:

execute( "E:\internet\hamster\tools\HamNewInfo.exe /end", "", 0, false ) 
     

2. Die Datei HamNewInfo.ini
===========================

Dies ist die Konfigurationsdatei des Programms HamNewInfo.
 
.-- [ Hinweis ]------------------------------------------------------.
|  Die INI-Datei von HamNewInfo der Version 0.1.0.1 ist nicht        |
|  f�r die aktuelle Version verwendbar.                              |
`--------------------------------------------------------------------'

Der Aufbau: (Beispiel)

[Einstellungen]
Hamster=E:\internet\hamster\

[User]
Account=Admin
From=post@mail.hamster
To=postmaster@mail.hamster
FQDN=mail.hamster
Index=0 
     

-----------------------------------------------------------------------   
Sektion           Eintrag   Wert  
[Einstellungen]   Hamster   E:\internet\hamster\  

Der Pfad zum Programm "Hamster" wird nun hier festgelegt. 
Dabei mu� am Ende das Zeichen "\" stehen.

----------------------------------------------------------------------- 
Sektion   Eintrag   Wert  
[User]    Account   Admin  

Account-Name unter Hamster. Dieser entspricht den Verzeichnis:
Laufwerk:/<Hamsterpfad>/Mails/<Account>
Wird als Account der Wert "Mail.Out" eingestellt, so kann Hamster
diese Nachricht auch an andere Mailsserver zustellen.
Alle erforderlichen Header werden automatisch erstellt. Nur sollte
in der INI-Datei die Eintr�ge "From" und "To" g�ltige EMailadressen
vorhanden sein.
-----------------------------------------------------------------------
Sektion   Eintrag   Wert  
[User]    From      post@mail.hamster

Die Absenderadresse wird festgelegt. Diese wird in der EMail im 
Header "FROM" eingetragen.
Bitte hier nur die EMailadresse angeben.
-----------------------------------------------------------------------
Sektion   Eintrag   Wert  
[User]    To        postmaster@mail.hamster  

Hier steht der Empf�nger der Info-EMail. 
Auch hier ist nur die EMailadresse anzugeben.
-----------------------------------------------------------------------
Sektion   Eintrag   Wert  
[User]    FQDN      mail.hamster 

Die FQDN zur Generierung einer Message-ID.
-----------------------------------------------------------------------
Sektion   Eintrag   Wert  
[User]    Index     0

Eintrag nicht �ndern !
Dieser Z�hler wird zur Erstellung des Dateinamens der Infomail
ben�tigt.
----------------------------------------------------------------------



3. Systemvorraussetzungen

Das Programm "HamNewInfo" d�rfte auf Windows-System ab Windows 95 
lauff�hig sein. Getestet unter Windows 2000, Windows XP.


4. Nutzungsbestimmungen

Das Programm "HamNewInfo" unterliegt festgelegten Nutzungsbestimmungen.
Diese Information ist der beigelegten Datei "lizenz.txt" zu entnehmen.


5. Links

[1] http://www.tglsoft.de


