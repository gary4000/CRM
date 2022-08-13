//Create( nil ); //需要自己释放
//
//Create(Self); //当Self释放时自动触发释放
//
//Create(Application); //当Application释放时自动释放
//
//Create( nil ); //这种方式创建的对象要自己手工进行FREE才会回收内存
////其他很多内存泄漏就是忘了手工释放内存
//
//Create(Self); //由self对象负责释放创建的对象，只要self没有释放掉
////这个对象的内存就不会被释入掉，除程序员手工进行释放，他会触发很多事件。
////性能不是很好

//Create(Application);
//Create(Application . owner);  //这两就是把self具体对象罢了

//BeginUpdate EndUpdate 防止类似for循环每添加一个Item，ListView都要重绘，那么当要添加的Items很多的时候，屏幕就会闪烁的现象

unit Unit4;

interface

uses
  FMX.Grid, SysUtils;

procedure SortGrid(Grid: TStringGrid; sortcol, datatype: integer);

implementation

procedure Quicksort(Grid: TStringGrid; var List: array of integer; min, max, sortcol, datatype: Integer);
{List is a list of rownumbers in the grid being sorted}
var
  med_value: integer;
  hi, lo, i: Integer;
  function compare(val1, val2: string): integer;
  var
    int1, int2: integer;
    float1, float2: extended;
    errcode: integer;
  begin
    case datatype of
    0:
    result := ANSIComparetext(val1, val2);
    1:
    begin
      int1 := strtointdef(val1, 0);
      int2 := strtointdef(val2, 0);
    if int1 > int2 then
     result := 1
    else if int1 < int2 then
      result := -1
    else
      result := 0;
    end;
    2:
    begin
      val(val1, float1, errcode);
    if errcode <> 0 then
      float1 := 0;
    val(val2, float2, errcode);
      if errcode <> 0 then
    float2 := 0;
    if float1 > float2 then
      result := 1
    else if float1 < float2 then
      result := -1
    else
      result := 0;
    end;
    else
      result := 0;
    end;
  end;
begin
{If the list has <= 1 element, it's sorted}
  if (min >= max) then
    Exit;
{Pick a dividing item randomly}
  i := min + Trunc(Random(max - min + 1));
  med_value := List[i];
  List[i] := List[min]; { Swap it to the front so we can find it easily}
{Move the items smaller than this into the left
half of the list. Move the others into the right}
  lo := min;
  hi := max;
  while (True) do
  begin
// Look down from hi for a value < med_value.
    while compare(Grid.cells[sortcol, List[hi]], grid.cells[sortcol, med_value]) >= 0 do
(*ANSIComparetext(Grid.cells[sortcol,List[hi]]
,grid.cells[sortcol,med_value])>=0 do*)
    begin
      hi := hi - 1;
      if (hi <= lo) then
        Break;
    end;
    if (hi <= lo) then
    begin {We're done separating the items}
      List[lo] := med_value;
      Break;
    end;
// Swap the lo and hi values.
    List[lo] := List[hi];
    inc(lo); {Look up from lo for a value >= med_value}
    while Compare(grid.cells[sortcol, List[lo]], grid.cells[sortcol, med_value]) < 0 do
    begin
      inc(lo);
      if (lo >= hi) then
        break;
    end;
    if (lo >= hi) then
    begin {We're done separating the items}
      lo := hi;
      List[hi] := med_value;
      break;
    end;
    List[hi] := List[lo];
  end;
{Sort the two sublists}
  Quicksort(Grid, List, min, lo - 1, sortcol, datatype);
  Quicksort(Grid, List, lo + 1, max, sortcol, datatype);
end;
//datatype 0：按字符排序 1：按整型排序 2：按浮点型排序
procedure SortGrid(Grid: TStringGrid; sortcol, datatype: integer);
var
  i: integer;
  tempgrid: tstringGrid;
  list: array of integer;
  j: Integer; //zero 添加，2016-3-17
begin
//screen.cursor:=crhourglass; //zero注释掉 2016-3-17
  tempgrid := TStringgrid.create(nil);
  tempgrid.BeginUpdate;
  with tempgrid do
  begin
//colcount:=grid.colcount; //zero 改，设定列数
    for I := 0 to grid.ColumnCount - 1 do
    begin
      TStringColumn.Create(tempgrid).Parent := tempgrid;
    end;
    rowcount := grid.rowcount;
//colcount:=grid.colcount; //
//fixedrows:=grid.fixedrows;
//zero注释掉,FMX 的stringgrid没有fixedrows,所以直接从0行开始就好了 2016-3-17
  end;

  with Grid do
  begin
//setlength(list,rowcount-fixedrows);
    setlength(list, rowcount);                               //设置数组个数与StringGrid行数一样
//for i:= fixedrows to rowcount-1 do
    for i := 0 to rowcount - 1 do
    begin
//list[i-fixedrows]:=i;
      list[i] := i;                                          //每个数组添加一个编号
//tempgrid.rows[i].assign(grid.rows[i]);
      for j := 0 to grid.ColumnCount - 1 do
        tempgrid.Cells[j, i] := grid.Cells[j, i];            //copy TStringGrid到TempGrid
//tempgrid.rows[i].assign(grid.rows[i]);
    end;
//quicksort(Grid, list,0,rowcount-fixedrows-1,sortcol,datatype);
    quicksort(Grid, list, 0, rowcount - 1, sortcol, datatype);    //快速排序
//for i:=0 to rowcount-fixedrows-1 do

    for i := 0 to rowcount - 1 do
    begin
//rows[i+fixedrows].assign(tempgrid.rows[list[i]])
      for j := 0 to tempgrid.ColumnCount - 1 do
        grid.Cells[j, i] := tempgrid.Cells[j, list[i]];         //copy TempGrid到TStringGrid
//rows[i+fixedrows].assign(tempgrid.rows[list[i]])
    end;

//row:=fixedrows;
//row:=fixedrows;
  end;
  tempgrid.EndUpdate;
  tempgrid.free;
//  tempgrid := nil;
  setlength(list, 0);
//screen.cursor:=crdefault;
end;

end.
