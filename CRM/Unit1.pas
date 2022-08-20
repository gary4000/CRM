//https://www.sqlite.org/download.html
//https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Connect_to_SQLite_database_(FireDAC)
//TFDConnection用于创建数据库连接，TFDQuery、TDataSource、TDBGrid用来呈现数据。
//另外还有添加上TFDPhysSQLiteDriverLink和TFDGUIxWaitCursor两个组件，不然容易报错
//TFDPhysSQLiteDriverLink为sqlite驱动，加入这个组件就行了
//https://blog.csdn.net/ooooh/article/details/50551053
//https://www.runoob.com/sqlite/sqlite-tutorial.html
//https://www.cnblogs.com/zach0812/p/16159960.html
//https://blog.csdn.net/weixin_42486509/article/details/110422870
//https://www.cnblogs.com/del/archive/2008/03/05/1091588.html
//https://www.cnblogs.com/GhostHorse/archive/2012/12/01/sort.html

//StringGrid1没有ShowClearButton的属性，日期没有关闭按钮，问题
//https://blog.csdn.net/SanBaDao/article/details/122839348

//TFDConnection            数据连接
//TFDQuery                 数据查询
//TDataSource              数据源
//TDBGrid                  数据显示

// uses FireDAC.Phys.SQLite 之后, 可不用添加 TFDPhysSQLiteDriverLink           //访问SQLite  文件数据库

unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Grid, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.TreeView, FMX.Layouts, FMX.Edit, FMX.Menus, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.Comp.Client, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Data.Bind.Controls,
  Fmx.Bind.Navigator, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    ScrollBox1: TScrollBox;
    TreeView1: TTreeView;
    TreeViewItem1: TTreeViewItem;
    TreeViewItem2: TTreeViewItem;
    TreeViewItem3: TTreeViewItem;
    TreeViewItem4: TTreeViewItem;
    TreeViewItem5: TTreeViewItem;
    TreeViewItem6: TTreeViewItem;
    Edit1: TEdit;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindNavigator1: TBindNavigator;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1CellClick(const Column: TColumn; const Row: Integer);
    procedure BindNavigator1Click(Sender: TObject; Button: TNavigateButton);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure TreeViewItem1Click(Sender: TObject);
    procedure TreeViewItem2Click(Sender: TObject);
    procedure TreeViewItem6Click(Sender: TObject);
    procedure TreeViewItem3Click(Sender: TObject);
    procedure TreeViewItem4Click(Sender: TObject);
    procedure TreeViewItem5Click(Sender: TObject);
    procedure StringGrid1HeaderClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Unit2, Unit3, Unit4;

procedure TForm1.BindNavigator1Click(Sender: TObject; Button: TNavigateButton);
var
  SQL: string;
  MaxID: Integer;
begin
  if Button = nbInsert then
  begin
    if FDConnection1.ExecSQLScalar('SELECT MAX(ID) FROM CRM') <> NULL then
    begin
//      返回最大ID,为什么ExecSQL不行，execute这个可以试一下，问题
      MaxID := FDConnection1.ExecSQLScalar('SELECT MAX(ID) FROM CRM') + 1;
      StringGrid1.Cells[0,StringGrid1.Row] := IntToStr(MaxID);
      SQL := 'INSERT INTO CRM(ID) VALUES(' + IntToStr(MaxID)+')';
      FDConnection1.ExecSQL(SQL);
//    FDQuery1.ExecSQL(SQL);
//    FDConnection1.ExecSQLScalar(sql);
    end else begin
      MaxID := 1;
      StringGrid1.Cells[0,StringGrid1.Row] := IntToStr(MaxID);
      SQL := 'INSERT INTO CRM(ID) VALUES(' + IntToStr(MaxID)+')';
      FDConnection1.ExecSQL(SQL);
    end;
//    这个肯定不是最好方法，问题
    BindNavigator1.BtnClick(nbRefresh);
  end;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var
  SQL: string;
  keyword: string;
begin
  keyword := Edit1.Text;
  SQL := 'select * from crm where 客户名称 LIKE '+'''%'+keyword+'%''' + ' or 备注 LIKE '+'''%'+keyword+'%''';
  if Key = 13 then
    FDQuery1.Open(SQL);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileName: string;
  SQL: string;
begin
//  取消登录提示框
  FDConnection1.LoginPrompt := False;
  FileName := GetCurrentDir + '\data.db';
  if not FileExists(FileName) then
  begin
    FDConnection1.Connected := True;
    FDConnection1.Params.Database := FileName;
    SQL := 'CREATE TABLE CRM(ID INTEGER PRIMARY KEY NOT NULL,客户名称 TEXT(20), 最后联系日期 DATE, 下次联系日期 DATE, 备注 TEXT)';
    FDConnection1.ExecSQL(SQL);

//    SQL := 'INSERT INTO CRM VALUES(''1'', ''公司名称'', ''2022-01-01'', '''', '''')';
//    FDConnection1.ExecSQL(SQL);
  end else begin
    FDConnection1.Params.Database := FileName;
    FDConnection1.Connected := True;
  end;

  SQL := 'select * from CRM where 下次联系日期=date(''now'',''0 day'')';

  FDQuery1.Connection := FDConnection1;
  DataSource1.DataSet := FDQuery1;
  FDQuery1.Open(SQL);
//  FDQuery1.Open('SELECT * FROM CRM');

//  TreeViewItem1Click(Self);

  Label1.Text := '客户数量:' + IntToStr(StringGrid1.RowCount);
end;

procedure TForm1.StringGrid1CellClick(const Column: TColumn;
  const Row: Integer);
begin
//  StringGrid1.Cells[FY, FX] := Form2.Memo1.Text;

  if StringGrid1.Columns[StringGrid1.Col].Header = '备注' then
  begin
    Form2.Memo1.Text := (StringGrid1.Cells[StringGrid1.Col,StringGrid1.Row]);
    Form2.X := StringGrid1.Row;
    Form2.Y := StringGrid1.Col;
    Form2.ShowModal;
  end;

//  if (StringGrid1.Col) = 4 then
//  begin
//    Form2.Memo1.Text := (StringGrid1.Cells[StringGrid1.Col,StringGrid1.Row]);
//    Form2.Show;
//  end;
end;

//当鼠标左键单击列标题上时立即发生
procedure TForm1.StringGrid1HeaderClick(Column: TColumn);
begin
//返回列索引
//Column.Index
//  ShellSortGrid(StringGrid1);
  SortGrid(StringGrid1, Column.Index, 0);
end;

procedure TForm1.TreeViewItem1Click(Sender: TObject);
var
//  Date: string;
  SQL: string;
begin
//应该是数据库属性问题，可能导致今天，和3天内的不显示，可是把data属性变成了string属性
//  Date := FormatDateTime('YYYY/MM/DD', Now);
//  SQL := 'SELECT * FROM CRM WHERE ID IN (SELECT ID FROM CRM WHERE 下次联系时间 = 2022/8/7)';
//SQL := 'select * from CRM where 下次联系时间=date(''now'',''start of day'')';
  SQL := 'select * from CRM where 下次联系日期=date(''now'',''0 day'')';
  FDQuery1.Open(SQL);
//  FDQuery1.Open('select * from CRM where 下次联系时间>=date(''now'', ''2022/8/7'')');
  Label1.Text := '客户数量:' + IntToStr(StringGrid1.RowCount);
end;

procedure TForm1.TreeViewItem2Click(Sender: TObject);
var
  SQL: string;
begin
//  SQL := 'select * from CRM where 下次联系时间>=date(''now'',''3 day'')';
//  SQL := 'select * from CRM where DATE(下次联系时间) BETWEEN date(''now'',''start day'') AND date(''now'',''3 day'')';
  SQL := 'select * from crm where 下次联系日期>=date(''now'',''0 day'') and 下次联系日期<=date(''now'',''2 day'')';
  FDQuery1.Open(SQL);
  Label1.Text := '客户数量:' + IntToStr(StringGrid1.RowCount);
end;

procedure TForm1.TreeViewItem3Click(Sender: TObject);
var
  SQL: string;
begin
  SQL := 'select * from crm where 最后联系日期<>''''';
  FDQuery1.Open(SQL);
  Label1.Text := '客户数量:' + IntToStr(StringGrid1.RowCount);
end;

procedure TForm1.TreeViewItem4Click(Sender: TObject);
var
  SQL: string;
begin
  SQL := 'select * from CRM where 最后联系日期=date(''now'',''0 day'')';
  FDQuery1.Open(SQL);
  Label1.Text := '客户数量:' + IntToStr(StringGrid1.RowCount);
end;

procedure TForm1.TreeViewItem5Click(Sender: TObject);
var
  SQL: string;
begin
//is null 表示建表时都是空值，NULL表示no known，即不知道，所以，它可以是任意值。
//所以使用 =null是查不到值的，因为=不知道，还是不知道。
//is null 和 = null的主要区别在于满不满足ANSISQL（SQL-92）规定
  SQL := 'select * from crm where 最后联系日期 is null';
  FDQuery1.Open(SQL);
  Label1.Text := '客户数量:' + IntToStr(StringGrid1.RowCount);
end;

procedure TForm1.TreeViewItem6Click(Sender: TObject);
begin
  FDQuery1.Open('SELECT * FROM CRM');
  Label1.Text := '客户数量:' + IntToStr(StringGrid1.RowCount);
end;

end.


