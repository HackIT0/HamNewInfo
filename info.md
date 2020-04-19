
# **HamNewInfo**

Allgemeines
-----------

Immer wieder hat man sich beim Abholen von EMails und Newsgruppen mit
Hamster [1] gefragt, wieviele EMail in den einzelnen Postfächern
<code>(Accounts - <Hamsterverzeichnis>/Mails/<Account>)</code> hinzugekommen sind.
Dies trifft auch für Newsgruppen zu <code>(<Hamsterverzeichnis>/Groups/<Newsgruppe>)</code>.  
Dieses Problem erledigt nun HamNewInfo. Es erfasst den aktuellen Datenbestand für EMails und Newsgruppen
und speichert diese als Information ab. Bei nächsten Aufruf von HamNewInfo wird der neue
Datenbestand an Emails und Newsgruppen erfasst und mit den alten,
gespeicherten Stand verglichen und nun eine Infonachricht erstellt.  
Die Nachricht wird als Textdatei einen Account bei Hamster, also
in den entsprechenden Verzeichnis abgespeichert.

Das Programm selbst ist mit Borland Delphi 7 - Personaleditionerstellt wurden und benötigt keine Laufzeitbibilotheken  
oder ActiveX-Steuerelemente.
