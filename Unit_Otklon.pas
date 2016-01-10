unit Unit_Otklon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TForm6 = class(TForm)
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    Label3: TLabel;
    ListBox2: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    ListBox3: TListBox;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form6: TForm6;
  Kval: string;

Const
  KO1: array [0..16] of string =
             ('H7','JS7','K7','N7','P7','F8','H8','E9','H9','C10','D10','H10',
              'A11','B11','C11','D11','H11');
  {KO2: array [0..58] of string =
             (H0,JS0,H1,JS1,K7,N7,P7,F8,H8,E9,H9,C10,D10,H10,A11,B11,C11,D11,H11);
  KO3: array [0..55] of string =
             (H7,JS7,K7,N7,P7,F8,H8,E9,H9,C10,D10,H10,A11,B11,C11,D11,H11);}
  KV1: array [0..15] of string =
             ('g6','h6','js6','k6','n6','p6','r6','s6','f7','h7','e8','h8',
              'd9','h9','d11','h11');
  KD1: array [0..6] of string =
             ('js6','js7','js8','js9','js10','js12','js14');

implementation
uses UnitAiSet;
{$R *.dfm}



procedure TForm6.FormShow(Sender: TObject);
var i:integer;
begin
//Временное
Groupbox1.Height:=145;
Form6.Height:=182;
//Временное
case Form4.RadioGroup1.ItemIndex of
  0: begin
     Listbox1.Items.Clear;
     for i:=0 to 15 do begin
      Listbox1.ItemIndex:=i;
      Listbox1.Items.Add(KV1[i]);
      end;
     Listbox1.ItemIndex:=-1;
     end;
  1: begin
     Listbox1.Items.Clear;
     for i:=0 to 16 do begin
      Listbox1.ItemIndex:=i;
      Listbox1.Items.Add(KO1[i]);
      end;
     Listbox1.ItemIndex:=-1;
     end;
  2: begin
     Listbox1.Items.Clear;
     for i:=0 to 6 do begin
      Listbox1.ItemIndex:=i;
      Listbox1.Items.Add(KD1[i]);
      end;
     Listbox1.ItemIndex:=-1;
     end;
end;
end;

procedure TForm6.BitBtn1Click(Sender: TObject);
var i,j:integer;
begin
Form6.Visible:=false;
UnitAiSet.Form4.Enabled:=true;
j:=Listbox1.ItemIndex;
i:=Form4.RadioGroup1.ItemIndex;
case i of
  0: Kval:=KV1[j];
  1: Kval:=KO1[j];
  2: Kval:=KD1[j];
end;
UnitAiSet.Form4.Edit5.Text:=Kval;
UnitAiSet.Form4.Edit5Exit(Sender);
end;


procedure TForm6.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
Form6.Visible:=false;
UnitAiSet.Form4.Enabled:=true;
end;

end.
