unit synautil;

interface

uses
SysUtils, Classes, Windows;


{:Returns current time in format defined in RFC-822. Useful for SMTP messages,
 but other protocols use this time format as well. Results contains the timezone
 specification. Four digit year is used to break any Y2K concerns. (Example
 'Fri, 15 Oct 1999 21:14:56 +0200')}
function Rfc822DateTime(t: TDateTime): string;

{:Return your timezone bias from UTC time in string representation like "+0200".}
function TimeZone: string;

{:Return your timezone bias from UTC time in minutes.}
function TimeZoneBias: integer;


var
  {:can be used for your own months strings for @link(getmonthnumber)}
  CustomMonthNames: array[1..12] of string;

implementation

{==============================================================================}

const
  MyDayNames: array[1..7] of AnsiString =
    ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
var
  MyMonthNames: array[0..6, 1..12] of AnsiString =
    (
    ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',  //rewrited by system locales
     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
    ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',  //English
     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
    ('jan', 'fév', 'mar', 'avr', 'mai', 'juin', //French
     'juil', 'aout', 'sep', 'oct', 'nov', 'déc'),
    ('jan', 'fev', 'mar', 'avr', 'mai', 'jui',  //French#2
     'jul', 'aout', 'sep', 'oct', 'nov', 'dec'),
    ('Jan', 'Feb', 'Mar', 'Apr', 'Mai', 'Jun',  //German
     'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'),
    ('Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',  //German#2
     'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'),
    ('Led', 'Úno', 'Bøe', 'Dub', 'Kvì', 'Èen',  //Czech
     'Èec', 'Srp', 'Záø', 'Øíj', 'Lis', 'Pro')
     );

{==============================================================================}



function Rfc822DateTime(t: TDateTime): string;
var
  wYear, wMonth, wDay: word;
begin
  DecodeDate(t, wYear, wMonth, wDay);
  Result := Format('%s, %d %s %s %s', [MyDayNames[DayOfWeek(t)], wDay,
    MyMonthNames[1, wMonth], FormatDateTime('yyyy hh:nn:ss', t), TimeZone]);
end;


{==============================================================================}


function TimeZone: string;
var
  bias: Integer;
  h, m: Integer;
begin
  bias := TimeZoneBias;
  if bias >= 0 then
    Result := '+'
  else
    Result := '-';
  bias := Abs(bias);
  h := bias div 60;
  m := bias mod 60;
  Result := Result + Format('%.2d%.2d', [h, m]);
end;
{==============================================================================}

function TimeZoneBias: integer;

var
  zoneinfo: TTimeZoneInformation;
  bias: Integer;
begin
  case GetTimeZoneInformation(Zoneinfo) of
    2:
      bias := zoneinfo.Bias + zoneinfo.DaylightBias;
    1:
      bias := zoneinfo.Bias + zoneinfo.StandardBias;
  else
    bias := zoneinfo.Bias;
  end;
  Result := bias * (-1);
end;
{==============================================================================}
end.
