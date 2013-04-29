unit UnitCommon;

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

function XToLeft(tmpX: integer): integer;
function YToTop(tmpY: integer): integer;
function XToRealX(tmpX: integer): integer;
function YToRealY(tmpY: integer): integer;
function RealXToX(tmpX: integer): integer;
function RealYToY(tmpY: integer): integer;

implementation

function XToLeft(tmpX: integer): integer;
begin
  result := tmpX * MULX + STARTX;
end;

function YToTop(tmpY: integer): integer;
begin
  result := tmpY * MULY + STARTY;
end;

function XToRealX(tmpX: integer): integer;
begin
  result := tmpX;
end;

function YToRealY(tmpY: integer): integer;
begin
  result := tmpY + 2;
end;

function RealXToX(tmpX: integer): integer;
begin
  result := tmpX;
end;

function RealYToY(tmpY: integer): integer;
begin
  result := tmpY - 2;
end;

end.
