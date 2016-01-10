unit URvb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmRvb = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label12: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRvb: TfmRvb;

implementation

uses UTab, UnitFiSet;

{$R *.DFM}

procedure TfmRvb.FormShow(Sender: TObject);
 var
 i:integer;
begin
 ListBox1.Items.Clear;
 for i:=1 to 13 do ListBox1.Items.Add(Str3[i]);
 ComboBox1.ItemIndex:=0;
 ListBox1.ItemIndex:=0;
 Label3.Caption:=FloatToStr(R[ListBox1.ItemIndex+1,ComboBox1.ItemIndex+1]/1000);
end;

procedure TfmRvb.ListBox1Click(Sender: TObject);
begin
 Label3.Caption:=FloatToStr(R[ListBox1.ItemIndex+1,ComboBox1.ItemIndex+1]/1000);
end;

procedure TfmRvb.ComboBox1Change(Sender: TObject);
begin
 Label3.Caption:=FloatToStr(R[ListBox1.ItemIndex+1,ComboBox1.ItemIndex+1]/1000);
end;

procedure TfmRvb.BitBtn2Click(Sender: TObject);
begin
 Close;
end;

procedure TfmRvb.BitBtn1Click(Sender: TObject);
begin
 Form9.Edit3.Text:=Label3.Caption;
 UnitFiSet.Form9.Edit3Exit(Sender);
 fmRvb.Visible:=false;
end;

 procedure TfmRvb.FormHide(Sender: TObject);
begin
 Form9.Edit3.SetFocus;
end;

end.
