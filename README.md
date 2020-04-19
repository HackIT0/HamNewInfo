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

Alle notwendigen Informationen finden Sie im [Wiki](https://github.com/HackIT0/HamNewInfo/wiki).  
Die erstellte EXE-Datei steht [hier](https://github.com/HackIT0/HamNewInfo/releases) zur Verfügung.
