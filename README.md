# HamNewInfo
Statistik für Hamster Classic

Allgemeines
-----------

Immer wieder hat man sich beim Abholen von EMails und Newsgruppen mit
[Hamster](https://de.wikipedia.org/wiki/Hamster_(Software)) gefragt, wie viele E-Mails in den einzelnen Postfächern
<code>(Accounts - <Hamsterverzeichnis>/Mails/<Account>)</code> hinzugekommen sind.
Dies trifft auch für Newsgruppen zu <code>(<Hamsterverzeichnis>/Groups/<Newsgruppe>)</code>.  
Dieses Problem erledigt nun HamNewInfo. Es erfasst den aktuellen Datenbestand für EMails und Newsgruppen
und speichert diese als Information ab. Bei nächsten Aufruf von HamNewInfo wird der neue
Datenbestand an E-Mails und Newsgruppen erfasst und mit den alten,
gespeicherten Stand verglichen und nun eine Infonachricht erstellt.  
Die Nachricht wird als Textdatei einen Account bei Hamster, also
in den entsprechenden Verzeichnis abgespeichert.

Das Programm selbst ist mit Borland Delphi 7 - Personaledition erstellt wurden und benötigt keine Laufzeitbibilotheken  
oder ActiveX-Steuerelemente.

Installation
-----------
Dieses Programm benötigt keine Laufzeitbibilotheken, DLL-Dateien oder ActiveX-Steuerelemente.  
Zur Nutzungs des Programms kopieren Sie einfach die Datei "<code>Hamnewinfo.exe</code>" und die Datei "<code>Hamnewinfo.ini</code>" in ein Verzeichnis Ihrer Wahl, da Sie ja den Pfad zum Programm in einen Skript angeben müssen.

Funktionsweise
-----------
HamNewInfo setzt [Hamster](https://de.wikipedia.org/wiki/Hamster_(Software)) vorraus. Dieses Programm muß eingerichtet und funktionsfähig sein. HamNewInfo wird über die Befehlszeile aufgerufen. Der Aufruf selbst erfolgt in einen Hamster-Script <code>(*.hsc)</code>. Alle Einstellungen zu HamNewInfo werden in der INI-Datei "<code>HamNewInfo.ini</code>" vorgenommen.

Aktuellen Status erfassen
-----------
Bevor ein Hamsterscript die neuen EMails und Newsgruppen abholt, sollte der aktuelle Status (Anzahl an EMails pro Account und
Anzahl der Nachrichten in den einzelnen Newsgruppen) ermittelt werden.

Hierzu ruft man das Programm "HamNewInfo" über die Kommandozeile mit den Start-Befehl auf:

<code>HamNewInfo.exe /start</code>  

In einen Hamster-Skript:
     
<code>execute( "E:\internet\hamster\tools\HamNewInfo.exe /start", "", 0, false )</code>  
     
Hierbei werden die Einstellungen in der HamNewInfo.ini ausgelesen.  
Genauer gesagt der Pfad, zum Hamsterverzeichnis wird ausgelesen.  

```batch
.-- [ HamNewInfo.ini ]-----------------------------------------------.
|  [Einstellungen]                                                   |
|  Hamster=E:\internet\hamster\                                      |
`--------------------------------------------------------------------'
```
Nun werden die Benutzer unter Hamster erfasst und deren Emails in der Datei "<code>mail.dat</code>"  
(Im Programmverzeichnis von HamNewInfo) abgespeichert.  
Bei den Newsgruppen werden auch erfasst und die Anzahl der News in der Datei "<code>news.dat</code>" gespeichert.  

Veränderungen erfassen
-----------
Nachdem nun alle Übertragungen an EMails und Newsgruppen erledigt sind, muß das Programm "HamNewInfo" erneut aufgerufen werden. 
Nun wird der aktuelle Status erfasst und mit den gespeicherten Status ein Vergleich gemacht. Hierbei wird ein neuer Status mit den Veränderungen als Datei in das Accounterverzeichnis des in der <code>HamNewInfo.ini</code> unter:  

```batch
.-- [ HamNewInfo.ini ]-----------------------------------------------.
|  [User]                                                            |
|  Account=Admin                                                     |
`--------------------------------------------------------------------'
```
abgelgten Namen gespeichert. In diesen gezeigten Beispiel (Ausschnitt aus der Hamnewinfo.ini) aus der INI-Datei würde die Infonachricht unter <code>E:\internet\hamster\Admin\<Name>.msg</code> abgespeichert.  
  
