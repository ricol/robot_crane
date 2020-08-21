unit Common;

interface

const
  STARTX = 10;
  STARTY = 10;
  MULX = 30;
  MULY = 30;
  LEN = 30;
  MAXI = 16;
  MAXJ = 13;
  INITARMI = 2;  //should>=1
  INITARMJ = 3;  //should>=3
  DATASTARTI = 2;
  DATAENDI = MAXI div 2;
  DATASTARTJ = MAXJ div 2 + 4;
  DATAENDJ = MAXJ;
//  DATASTARTI = 1;
//  DATAENDI = MAXI;
//  DATASTARTJ = 1;
//  DATAENDJ = MAXJ;
  DATATARGETSTARTI = 2 + DATAENDI;
  DATATARGETENDI = DATAENDI - DATASTARTI + DATAENDI + 2;
  DATATARGETSTARTJ = 5;
  DATATARGETENDJ = DATAENDJ;

function XToLeft(x: integer): integer;
function YToTop(y: integer): integer;
function XToRealX(x: integer): integer;
function YToRealY(y: integer): integer;
function RealXToX(x: integer): integer;
function RealYToY(y: integer): integer;

implementation

function XToLeft(x: integer): integer;
begin
  result := x * MULX + STARTX;
end;

function YToTop(y: integer): integer;
begin
  result := y * MULY + STARTY;
end;

function XToRealX(x: integer): integer;
begin
  result := x;
end;

function YToRealY(y: integer): integer;
begin
  result := y + 2;
end;

function RealXToX(x: integer): integer;
begin
  result := x;
end;

function RealYToY(y: integer): integer;
begin
  result := y - 2;
end;

end.
