//希尔排序算法
//https://www.runoob.com/data-structures/shell-sort.html
//各种排序代码
//https://www.cnblogs.com/fhweixin/p/13744188.html

unit Unit3;

interface

uses
  FMX.Grid;

procedure ShellSortGrid(var StringGrid: TStringGrid);

implementation

//实现排序操作,VCL可用，FMX不可用
//Procedure GridSort(StringGrid: TStringGrid; ColumnInt:Integer);
//Var
//  Line, PosActual:Integer;
//  Row: TStrings;
//begin
//  Row := TStrings.Create;
//  for Line := 1 to StringGrid.RowCount-1 do
//  begin
//    PosActual := Line;
//    Row.Assign(TStringList(StringGrid.Rows[PosActual]));
//
//    while True do
//    begin
//      If (PosActual = 0) or (StrToInt(Row.Strings[ColumnInt-1]) >= StrToInt(StringGrid.Cells[ColumnInt-1,PosActual-1]))
//      then
//        Break;
//        StringGrid.Row[PosActual] := StringGrid.Row[PosActual-1];
//        Dec(PosActual);
//    end;
//
//    If StrToInt(Row.Strings[ColumnInt-1]) < StrToInt(StringGrid.Cells[ColumnInt-1,PosActual]) then
//      StringGrid.Row[PosActual] := Row;
//  end;
//  Row.Free;
//end;

//希尔排序
procedure ShellSortGrid(var StringGrid: TStringGrid);
var
  I,J,K,IntTemp: Integer;
  var N:array of Integer;
begin
  K := High(N) div 2;
  while K > 0 do
  begin
    for I := K to High(N) do
    begin
       J:=I;
       while (J >= K)and(N[J-K]>N[J]) do
       begin
         IntTemp:=N[J-K];
         N[J-K]:=N[J];
         N[J]:=IntTemp;
         J:=J-K;
       end;
    end;
    K:=K div 2;
  end;
end;

//希尔排序
//procedure TForm1.Button1Click(Sender: TObject);
//var
//  Arr: array of Integer;
//  I: Integer;
//begin
//  SetLength(Arr, 9);
//  Arr[0] := 21;
//  Arr[1] := 33;
//  Arr[2] := 4;
//  Arr[3] := 65;
//  Arr[4] := 77;
//  Arr[5] := 1;
//  Arr[6] := 3;
//  Arr[7] := 7;
//  Arr[8] := 9;
//
//  ShellSort(Arr);
//
//  for I := Low(Arr) to High(Arr) do
//    Memo1.Lines.Add(IntToStr(Arr[I]));
//end;

end.
