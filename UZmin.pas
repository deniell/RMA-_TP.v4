unit UZmin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmZmin = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BitBtn2: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmZmin: TfmZmin;

implementation

uses UTab, UnitZiSet;

{$R *.DFM}

procedure TfmZmin.FormCreate(Sender: TObject);
var
 i:integer;
begin
 for i:=1 to 43 do ListBox1.Items.Add (Str1[i]);
 Label3.Caption:=FloatToStr(Rzmax[1]);
 Label4.Caption:=FloatToStr(h[1]);
 Label6.Caption:=FloatToStr(h[1]+Rzmax[1]);
end;

procedure TfmZmin.ListBox1Click(Sender: TObject);
begin
 Label3.Caption:=FloatToStr(Rzmax[ListBox1.ItemIndex+1]);
 Label4.Caption:=FloatToStr(h[ListBox1.ItemIndex+1]);
 Label6.Caption:=FloatToStr(h[ListBox1.ItemIndex+1]+Rzmax[ListBox1.ItemIndex+1]);
end;

procedure TfmZmin.BitBtn2Click(Sender: TObject);
begin
 Close;
end;

procedure TfmZmin.BitBtn1Click(Sender: TObject);
begin
 Form14.Edit1.Text:=FloatToStr(StrToFloat(Label6.Caption)/1000);
 UnitZiSet.Form14.Edit1Exit(Sender);
 fmZmin.Visible:=false;
end;

procedure TfmZmin.FormHide(Sender: TObject);
begin
 Form14.Edit1.SetFocus;
end;



end.
