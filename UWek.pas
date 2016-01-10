unit UWek;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmWek = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Identif (ide : Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmWek : TfmWek;
  I     : Integer = 0;



implementation

uses UTab,UnitFiSet; //UIf,UIb;

{$R *.DFM}

procedure TfmWek.FormShow(Sender: TObject);
var
 i:integer;
begin
 ListBox1.Items.Clear;
 for i:=1 to 72 do ListBox1.Items.Add(Str2[i]);
 ComboBox1.ItemIndex:=0;
 ListBox1.ItemIndex:=0;
 Label3.Caption:=FloatToStr(IT[ListBox1.ItemIndex+1,ComboBox1.ItemIndex+1]);
end;

procedure TfmWek.ListBox1Click(Sender: TObject);
begin
 Label3.Caption:=FloatToStr(IT[ListBox1.ItemIndex+1,ComboBox1.ItemIndex+1]);
end;

procedure TfmWek.ComboBox1Change(Sender: TObject);
begin
 Label3.Caption:=FloatToStr(IT[ListBox1.ItemIndex+1,ComboBox1.ItemIndex+1]);
end;

procedure TfmWek.BitBtn1Click(Sender: TObject);
begin
    Form9.Edit1.Text:=Label3.Caption;
    UnitFiSet.Form9.Edit1Exit(Sender);
    fmWek.Visible:=false;
end;

procedure TfmWek.BitBtn2Click(Sender: TObject);
begin
 fmWek.Visible:=false;
end;

procedure TfmWek.FormHide(Sender: TObject);
begin
 Form9.Edit1.SetFocus;
end;

procedure TfmWek.Identif (ide: Integer);
begin
    I := ide;
end;



end.
