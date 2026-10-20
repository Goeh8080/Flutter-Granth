{ Standalone sample; not part of the app build. }
program GranthList;
const
  Granths: array[1..3] of string = ('Gita', 'Kabir Sagar', 'Ved');
var
  i: Integer;
begin
  for i := 1 to 3 do
    WriteLn(i, '. ', Granths[i]);
end.
{ Granth list sample — prints titles in order. }
