unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Objects;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1ApplyStyleLookup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    X, Y: Integer;
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses Unit1;

{ TForm2 }



procedure TForm2.Button1Click(Sender: TObject);
var
  SQL: string;
  ID: string;
begin
//按键属性cancel为真，按esc执行本方法
  Form1.StringGrid1.Cells[Y, X] := Form2.Memo1.Text;

//如果ID列不是第一列，会出问题
  ID := Form1.StringGrid1.Cells[0,X];
  if ID <> '' then
  begin
    SQL := 'UPDATE CRM SET ''备注'' = '+ ''''+ Form2.Memo1.Text + '''' +' WHERE ID =' + ID;
    Form1.FDConnection1.ExecSQL(SQL);
  end;

  Close;
  Memo1.SetFocus;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Memo1.SetFocus;
end;

procedure TForm2.FormDeactivate(Sender: TObject);
begin
//失去焦点，最好是窗体置顶
  Form1.StringGrid1.Cells[Y, X] := Form2.Memo1.Text;
end;

//让TMemo控件高亮部分内容
//https://qa.1r1g.com/sf/ask/1331685841/
procedure TForm2.Memo1ApplyStyleLookup(Sender: TObject);
var Obj: TFmxObject;
    Rectangle1: TRectangle;
begin
//     Obj := Memo1.FindStyleResource('background');
//     if Obj <> nil then
//     begin
//          TControl(Obj).Margins   := TBounds.Create(TRectF.Create(-, -, -, -));
//          Rectangle1              := TRectangle.Create(Obj);
//          Obj.AddObject(Rectangle1);
//          Rectangle1.Align        := TAlignLayout.Client;
//          Rectangle1.Fill.Color   := Black;
//          Rectangle1.Stroke.Color := Black;
//          Rectangle1.HitTest      := False;
//          Rectangle1.SendToBack;
//     end;
end;

end.
