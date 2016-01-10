unit UnitBiSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, Buttons, Unit_NewCalc, UnitPovParametrs,
  Unit_Otklon, ExtCtrls, Grids, DataUnit, SettingsUnit, MainUnit;

type
  TForm8 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StringGrid1: TStringGrid;
    Button5: TButton;
    Bevel2: TBevel;
    TabControl1: TTabControl;
    Label1: TLabel;
    Bevel1: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel3: TBevel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    GroupBox1: TGroupBox;
    Edit5: TEdit;
    RadioButton1: TRadioButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label7: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    RadioButton2: TRadioButton;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    RadioButton3: TRadioButton;
    Edit6: TEdit;
    Edit7: TEdit;
    GroupBox4: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Label10: TLabel;
    Label11: TLabel;
    Bevel4: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Edit2: TEdit;
    Label12: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7Exit(Sender: TObject);
    procedure Bi_Show;
    procedure Bi_Close;
    procedure SpeedButton2Click(Sender: TObject);

  private
    { Private declarations }
  public
  //DecimalSeparator: Char;
    { Public declarations }
  end;

var
  Form8: TForm8;
  counter: integer;
  Name, fname, Mname : string;
  forma,
  Mtype,
  NOp,                             //К-сть операцій ТП
  NZag,                            //К-сть поверхонь заготовки
  NDet,                            //К-сть поверхонь деталі
  NBi,                             //К-сть розмірів заготовки
  NAi,                             //К-сть конструкторських розмірів
  NFi,                             //К-сть технологічних розмірів
  Zn  : integer;                   //К-сть припусків
  z,z_: integer;
  adres: String; //для адреса, откуда запущена программа
  Ch : array [0..999] of integer;  //К-сть обробок і-ої поверхні
  PBi: array of TBi;               //Масив властивостей розм. заготовки

const
  Incl: array [0..9] of string =
  ('1','2','3','4','5','6','7','8','9','0');

implementation
uses ESDP,
     UnitRozmFType,
     UnitAiSet,
     UnitFiSet,
     UnitTB;
{$R *.dfm}

{..............................................................................}
procedure TForm8.Bi_Show;
var
    s:integer;
begin
    z_:=1;
    NBi:=Unit_NewCalc.NBi;
    NDet:=Unit_NewCalc.NDet;

    if MainUnit.counter<3 then
    begin
      SetLength(PBi,NBi+5);   //Задання масиву розмірів заготовки
      for s:=0 to NBi+4 do
      begin
        PBi[s].NBi:=0;
        PBi[s].N1List:=-1;
        PBi[s].N1:='';
        PBi[s].N2List:=-1;
        PBi[s].N2:='';
        PBi[s].Size:=0;
        PBi[s].ES:=0;
        PBi[s].EI:=0;
        PBi[s].T:=0;
        PBi[s].Em:=0;
        PBi[s].Bmax:=0;
        PBi[s].Bmin:=0;
        PBi[s].Bm:=0;
        PBi[s].Zagot:=-1;
        PBi[s].W:=0;
      end;
      MainUnit.counter:=3;
    end else begin
      if Length(PBi)=0 then begin
        SetLength(PBi,NBi);   //Задання масиву розмірів заготовки
        for s:=0 to NBi-1 do begin
          PBi[s].NBi:=MainUnit.PBi[s].NBi;
          PBi[s].N1List:=MainUnit.PBi[s].N1List;
          PBi[s].N1:=MainUnit.PBi[s].N1;
          PBi[s].N2List:=MainUnit.PBi[s].N2List;
          PBi[s].N2:=MainUnit.PBi[s].N2;
          PBi[s].Size:=MainUnit.PBi[s].Size;
          PBi[s].ES:=MainUnit.PBi[s].ES;
          PBi[s].EI:=MainUnit.PBi[s].EI;
          PBi[s].T:=MainUnit.PBi[s].T;
          PBi[s].Em:=MainUnit.PBi[s].Em;
          PBi[s].Bmax:=MainUnit.PBi[s].Bmax;
          PBi[s].Bmin:=MainUnit.PBi[s].Bmin;
          PBi[s].Bm:=MainUnit.PBi[s].Bm;
          PBi[s].Zagot:=MainUnit.PBi[s].Zagot;
          PBi[s].W:=MainUnit.PBi[s].W;
        end;
      finalize(MainUnit.PBi);
    end;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.FormShow(Sender: TObject);
var
  i,j,a,s : integer;
  n,p : string;
  tmp_f : TStrings;
begin
  Form8.Height:=420;
  SpeedButton1.Visible:=false;
  z_:=1;

 //в залежності від значення параметра Bi_rw в Mainunit можна чи ні повернутись

  if Mainunit.Bi_rw=true then begin
      Bitbtn2.Visible:=false;
      Bitbtn1.Caption:=' Ок ';
      UnitAiSet.Form4.Im_dialog.GetBitmap(3,Bitbtn1.Glyph);
  end else begin
    Bitbtn2.Visible:=true;
    Bitbtn2.Caption:='Назад';
    UnitAiSet.Form4.Im_dialog.GetBitmap(0,Bitbtn2.Glyph);
    Bitbtn1.Caption:='Далі';
    UnitAiSet.Form4.Im_dialog.GetBitmap(1,Bitbtn1.Glyph);
  end;

if SettingsUnit.Set1.Addings=true then Button5.Visible:=true
else Button5.Visible:=false;

label11.Caption:='Розміри заготовки';

Bi_Show;

Tabcontrol1.Tabs.Clear;
z:=1;
i:=1;
repeat
n:='B'+inttostr(i);
Tabcontrol1.TabIndex:=(i-1);
Tabcontrol1.Tabs.Add(n);
i:=i+1;
until i=(NBi+1);
Combobox1.Visible:=true;
Combobox2.Visible:=true;
Combobox1.Items.Clear;
Combobox2.Items.Clear;
// str:=Application.ExeName;
 //ls:=length(Application.ExeName);
// setlength(str,ls-15);
adres := ExtractFilePath(Application.ExeName);
 tmp_f:=TStringList.Create();
 tmp_f.LoadFromFile(adres+'shapes.dat');
 a:=tmp_f.IndexOf('[Bi]')+1;
for j:=0 to NDet-1 do begin
 p:=tmp_f.Strings[a+j];
 Combobox1.ItemIndex:=j;
 Combobox1.Items.Add(p);
 Combobox2.ItemIndex:=j;
 Combobox2.Items.Add(p);
end;
tmp_f.Free;
{---------заповнюємо форму початково}
s:=0;
 if PBi[s].NBi=0 then begin
  Label1.Caption:='Розмір B'+inttostr(s+1);
  Combobox1.ItemIndex:=-1;
  Combobox2.ItemIndex:=-1;
  Edit2.Text:='';
  Edit3.Text:='';
  Edit4.Text:='';
  Edit5.Text:='';
  Edit6.Text:='';
  Edit7.Text:='';
 end else begin
  Label1.Caption:='Розмір B'+inttostr(PBi[s].NBi);
  Combobox1.ItemIndex:=PBi[s].N1List;
  Combobox2.ItemIndex:=PBi[s].N2List;
  Edit2.Text:=floattostr(PBi[s].Size);
  Edit5.Text:=floattostr(PBi[s].T);
  Edit3.Text:=floattostr(PBi[s].ES);
  Edit4.Text:=floattostr(PBi[s].EI);
  Edit6.Text:=floattostr(PBi[s].Bmax);
  Edit7.Text:=floattostr(PBi[s].Bmin);
 end;
 if (PBi[s].Size<>0) then begin
 Radiobutton2.Checked:=true;
 RadioButton2Click(Sender);
 Groupbox4.Enabled:=false;
end else if (PBi[s].T<>0) then begin
 Radiobutton1.Checked:=true;
 RadioButton1Click(Sender);
 Groupbox4.Enabled:=true;
end else begin
 Radiobutton3.Checked:=true;
 RadioButton3Click(Sender);
 Groupbox4.Enabled:=true;
end;
case PBi[s].Zagot of
  0:begin
    Radiobutton4.Checked:=true;
    Radiobutton5.Checked:=false;
    Radiobutton6.Checked:=false;
    end;
  1:begin
    Radiobutton4.Checked:=false;
    Radiobutton5.Checked:=true;
    Radiobutton6.Checked:=false;
    end;
  2:begin
    Radiobutton4.Checked:=false;
    Radiobutton5.Checked:=false;
    Radiobutton6.Checked:=true;
    end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.TabControl1Change(Sender: TObject);
var
  s:integer;
begin
  s:=Tabcontrol1.TabIndex;
  if PBi[s].NBi=0 then
  begin
    Label1.Caption:='Розмір B'+inttostr(s+1);
    Combobox1.ItemIndex:=-1;
    Combobox2.ItemIndex:=-1;
    Edit2.Text:='';
    Edit3.Text:='';
    Edit4.Text:='';
    Edit5.Text:='';
    Edit6.Text:='';
    Edit7.Text:='';
  end
  else
  begin
    Label1.Caption:='Розмір B'+inttostr(PBi[s].NBi);
    Combobox1.ItemIndex:=PBi[s].N1List;
    Combobox2.ItemIndex:=PBi[s].N2List;
    Edit2.Text:=floattostr(PBi[s].Size);
    Edit5.Text:=floattostr(PBi[s].T);
    Edit3.Text:=floattostr(PBi[s].ES);
    Edit4.Text:=floattostr(PBi[s].EI);
    Edit6.Text:=floattostr(PBi[s].Bmax);
    Edit7.Text:=floattostr(PBi[s].Bmin);
  if (PBi[s].Size<>0) then
  begin
    Radiobutton2.Checked:=true;
    RadioButton2Click(Sender);
    Groupbox4.Enabled:=false;
  end
  else
  if (PBi[s].T<>0) then
    begin
      Radiobutton1.Checked:=true;
      RadioButton1Click(Sender);
      Groupbox4.Enabled:=true;
    end
    else
    begin
      Radiobutton3.Checked:=true;
      RadioButton3Click(Sender);
      Groupbox4.Enabled:=true;
    end;
    case PBi[s].Zagot of
      0:begin
          Radiobutton4.Checked:=true;
          Radiobutton5.Checked:=false;
          Radiobutton6.Checked:=false;
        end;
      1:begin
          Radiobutton4.Checked:=false;
          Radiobutton5.Checked:=true;
          Radiobutton6.Checked:=false;
        end;
      2:begin
          Radiobutton4.Checked:=false;
          Radiobutton5.Checked:=false;
          Radiobutton6.Checked:=true;
        end;
    end;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.RadioButton1Click(Sender: TObject);
begin
  Radiobutton1.Checked:=true;
  Edit5.Enabled:=true;
  Edit2.Enabled:=false;
  Radiobutton2.Checked:=false;
  Edit3.Enabled:=false;
  Edit4.Enabled:=false;
  Radiobutton3.Checked:=false;
  Edit6.Enabled:=false;
  Edit7.Enabled:=false;
  Groupbox4.Enabled:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.RadioButton2Click(Sender: TObject);
begin
  Radiobutton1.Checked:=false;
  Edit2.Enabled:=true;
  Edit5.Enabled:=false;
  Radiobutton2.Checked:=true;
  Edit3.Enabled:=true;
  Edit4.Enabled:=true;
  Radiobutton3.Checked:=false;
  Edit6.Enabled:=false;
  Edit7.Enabled:=false;
  Groupbox4.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.RadioButton3Click(Sender: TObject);
begin
  Radiobutton1.Checked:=false;
  Edit5.Enabled:=false;
  Edit2.Enabled:=false;
  Radiobutton2.Checked:=false;
  Edit3.Enabled:=false;
  Edit4.Enabled:=false;
  Radiobutton3.Checked:=true;
  Edit6.Enabled:=true;
  Edit7.Enabled:=true;
  Groupbox4.Enabled:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Button5Click(Sender: TObject);
var
  s:integer;
begin
  if z_=1 then
  begin
    Form8.Height:=677;
    z_:=0;
    SpeedButton1.Visible:=true;
    Button5.Caption:='Додатково <<';
  end else begin
    Form8.Height:=420;
    z_:=1;
    SpeedButton1.Visible:=false;
    Button5.Caption:='Додатково >>';
  end;
{----->>>> Інфо масиву - розміри заготовки}
  Stringgrid1.ColCount:=NBi+1;
  Stringgrid1.RowCount:=9;
  Stringgrid1.Cells[0,0]:='Позначення розм.';
  Stringgrid1.Cells[0,1]:='Розмірні зв''язки';
  Stringgrid1.Cells[0,2]:='Розмір';
  Stringgrid1.Cells[0,3]:='Допуск';
  Stringgrid1.Cells[0,4]:='ES';
  Stringgrid1.Cells[0,5]:='EI';
  Stringgrid1.Cells[0,6]:='Макс. розмір';
  Stringgrid1.Cells[0,7]:='Мін. розмір';
  Stringgrid1.Cells[0,8]:='Тип';
  for s:=1 to NBi do
  begin
    Stringgrid1.Cells[s,0]:='B'+inttostr(PBi[s-1].NBi);
    Stringgrid1.Cells[s,1]:='('+PBi[s-1].N1+' - '+PBi[s-1].N2+')';
    Stringgrid1.Cells[s,2]:=floattostr(PBi[s-1].Size);
    Stringgrid1.Cells[s,3]:=floattostr(PBi[s-1].T);
    Stringgrid1.Cells[s,4]:=floattostr(PBi[s-1].ES);
    Stringgrid1.Cells[s,5]:=floattostr(PBi[s-1].EI);
    Stringgrid1.Cells[s,6]:=floattostr(PBi[s-1].Bmax);
    Stringgrid1.Cells[s,7]:=floattostr(PBi[s-1].Bmin);
    case PBi[s-1].Zagot of
      0: Stringgrid1.Cells[s,8]:='Виливок';
      1: Stringgrid1.Cells[s,8]:='Штамповка';
      2: Stringgrid1.Cells[s,8]:='Інший';
    end;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.ComboBox1Change(Sender: TObject);
var
  s,i:integer;
begin
      s:=Tabcontrol1.TabIndex;
      PBi[s].NBi:=Tabcontrol1.TabIndex+1;
      i:=Combobox1.ItemIndex;
      PBi[s].N1List:=i;
      PBi[s].N1:=Combobox1.Text;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.ComboBox2Change(Sender: TObject);
var
  s,i:integer;
begin
      s:=Tabcontrol1.TabIndex;
      PBi[s].NBi:=Tabcontrol1.TabIndex+1;
      i:=Combobox2.ItemIndex;
      PBi[s].N2List:=i;
      PBi[s].N2:=Combobox2.Text;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit2KeyPress(Sender: TObject; var Key: Char);
var s:integer;
begin
  case Key of
    '0'..'9', #8: ; // цифры и Backspace
    ',','.'  :
      begin
        // DicimalSeparator - гробальная переменная
        // в которой находится символ "десятичный разделитель"
        Key:= DecimalSeparator;
        if pos(DecimalSeparator,Edit2.Text) <> 0
        then Key:= #0;
      end;
        else // остальные символы запрещены
        key := Chr(0);
  end;
        begin
        s:=Tabcontrol1.TabIndex;
        PBi[s].NBi:=s+1;
        if (Edit2.Text)<>'' then  begin
        PBi[s].Size:=strtofloat(Edit2.Text);
        Edit3Exit(Sender);
        Edit4Exit(Sender);
        end;
        end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit2Exit(Sender: TObject);
var
  s:integer;
begin
  s:=Tabcontrol1.TabIndex;
  PBi[s].NBi:=s+1;
  if (Edit2.Text)<>'' then begin
  PBi[s].Size:=strtofloat(Edit2.Text);
  Edit3Exit(Sender);
  Edit4Exit(Sender);
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit3KeyPress(Sender: TObject; var Key: Char);
var s:integer;
begin
 case Key of
    '0'..'9', #8: ; // цифры и Backspace
    ',','.' :
      begin
        // DicimalSeparator - гробальная переменная
        // в которой находится символ "десятичный разделитель"
        Key:= DecimalSeparator;
        if pos(DecimalSeparator,Edit3.Text) <> 0
        then Key:= #0;
      end;
      '-': if Edit3.SelStart <> 0 then Key:= #0;
      else Key:= #0; // Остальные символы не отображать
        begin
        s:=Tabcontrol1.TabIndex;
        PBi[s].NBi:=s+1;
        if (Edit3.Text<>'') and (Edit3.Text<>'-') and (Edit3.Text<>'+') then
        PBi[s].ES:=strtofloat(Edit3.Text);
        if (PBi[s].Size<>0) and (Edit3.Text<>'-') and (Edit3.Text<>'+') then
        PBi[s].Bmax:=PBi[s].Size+PBi[s].ES;
        Edit6.Text:=floattostr(PBi[s].Bmax);
        PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
        Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
        end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit3Exit(Sender: TObject);
var
  s:integer;
begin
 s:=Tabcontrol1.TabIndex;
 PBi[s].NBi:=s+1;
if (Edit3.Text<>'') and (Edit3.Text<>'-') and (Edit3.Text<>'+') then
PBi[s].ES:=strtofloat(Edit3.Text);
 if (PBi[s].Size<>0) and (Edit3.Text<>'-') and (Edit3.Text<>'+') then begin
  PBi[s].Bmax:=PBi[s].Size+PBi[s].ES;
  Edit6.Text:=floattostr(PBi[s].Bmax);
  PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
  Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit4KeyPress(Sender: TObject; var Key: Char);
var s:integer;
begin
 case Key of
    '0'..'9', #8: ; // цифры и Backspace
    ',','.' :
      begin
        // DicimalSeparator - гробальная переменная
        // в которой находится символ "десятичный разделитель"
        Key:= DecimalSeparator;
        if pos(DecimalSeparator,Edit4.Text) <> 0
        then Key:= #0;
      end;
      '-': if Edit4.SelStart <> 0 then Key:= #0;
      else Key:= #0; // Остальные символы не отображать
        begin
         s:=Tabcontrol1.TabIndex;
         PBi[s].NBi:=s+1;
         if (Edit4.Text<>'') and (Edit4.Text<>'-') and (Edit4.Text<>'+') then
         PBi[s].EI:=strtofloat(Edit4.Text);
         if (PBi[s].Size<>0) and (Edit4.Text<>'-') and (Edit4.Text<>'+') then begin
         PBi[s].Bmin:=PBi[s].Size+PBi[s].EI;
         Edit7.Text:=floattostr(PBi[s].Bmin);
         PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
         Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
          end;
        end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit4Exit(Sender: TObject);
var
s:integer;
begin
 s:=Tabcontrol1.TabIndex;
 PBi[s].NBi:=s+1;
 if (Edit4.Text<>'') and (Edit4.Text<>'-') and (Edit4.Text<>'+') then
 PBi[s].EI:=strtofloat(Edit4.Text);
 if (PBi[s].Size<>0) and (Edit4.Text<>'-') and (Edit4.Text<>'+') then begin
 PBi[s].Bmin:=PBi[s].Size+PBi[s].EI;
 Edit7.Text:=floattostr(PBi[s].Bmin);
 PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
 Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit5KeyPress(Sender: TObject; var Key: Char);
var
s:integer;
begin
  case Key of
    '0'..'9', #8: ; // цифры и Backspace
    ',','.'  :
      begin
        // DicimalSeparator - гробальная переменная
        // в которой находится символ "десятичный разделитель"
        Key:= DecimalSeparator;
        if pos(DecimalSeparator,Edit5.Text) <> 0
        then Key:= #0;
      end;
        else // остальные символы запрещены
        key := Chr(0);
  end;
        begin
         s:=Tabcontrol1.TabIndex;
         PBi[s].NBi:=s+1;
         if (Edit5.Text)<>'' then
         PBi[s].T:=strtofloat(Edit5.Text);
        end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit5Exit(Sender: TObject);
var
  s:integer;
begin
 s:=Tabcontrol1.TabIndex;
 PBi[s].NBi:=s+1;
 if (Edit5.Text)<>'' then
 PBi[s].T:=strtofloat(Edit5.Text);
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit6KeyPress(Sender: TObject; var Key: Char);
var s:integer;
begin
  case Key of
    '0'..'9', #8: ; // цифры и Backspace
    ',','.'  :
      begin
        // DicimalSeparator - гробальная переменная
        // в которой находится символ "десятичный разделитель"
        Key:= DecimalSeparator;
        if pos(DecimalSeparator,Edit6.Text) <> 0
        then Key:= #0;
      end;
        else // остальные символы запрещены
        key := Chr(0);
  end;
        begin
        s:=Tabcontrol1.TabIndex;
        PBi[s].NBi:=s+1;
        if (Edit6.Text)<>'' then
        PBi[s].Bmax:=strtofloat(Edit6.Text);
        if (PBi[s].Size<>0) then
        PBi[s].ES:=PBi[s].Bmax-PBi[s].Size;
        Edit3.Text:=floattostrF(PBi[s].ES,ffFixed,4,2);
        PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
        Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
        end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit6Exit(Sender: TObject);
var
  s:integer;
begin
        s:=Tabcontrol1.TabIndex;
        PBi[s].NBi:=s+1;
        if (Edit6.Text)<>'' then
        PBi[s].Bmax:=strtofloat(Edit6.Text);
        if (PBi[s].Size<>0) then
        PBi[s].ES:=PBi[s].Bmax-PBi[s].Size;
        Edit3.Text:=floattostrF(PBi[s].ES,ffFixed,4,2);
        PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
        Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit7KeyPress(Sender: TObject; var Key: Char);
var s:integer;
 begin
  case Key of
    '0'..'9', #8: ; // цифры и Backspace
    ',','.'  :
      begin
        // DicimalSeparator - гробальная переменная
        // в которой находится символ "десятичный разделитель"
        Key:= DecimalSeparator;
        if pos(DecimalSeparator,Edit7.Text) <> 0
        then Key:= #0;
      end;
        else // остальные символы запрещены
        key := Chr(0);
  end;
        begin
        s:=Tabcontrol1.TabIndex;
        PBi[s].NBi:=s+1;
        if (Edit7.Text)<>'' then
        PBi[s].Bmin:=strtofloat(Edit7.Text);
        if (PBi[s].Size<>0) then
        PBi[s].EI:=PBi[s].Bmin-PBi[s].Size;
        Edit4.Text:=floattostrF(PBi[s].EI,ffFixed,4,2);
        PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
        Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
        end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Edit7Exit(Sender: TObject);
var
  s:integer;
begin
        s:=Tabcontrol1.TabIndex;
        PBi[s].NBi:=s+1;
        if (Edit7.Text)<>'' then
        PBi[s].Bmin:=strtofloat(Edit7.Text);
        if (PBi[s].Size<>0) then
        PBi[s].EI:=PBi[s].Bmin-PBi[s].Size;
        Edit4.Text:=floattostrF(PBi[s].EI,ffFixed,4,2);
        PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
        Edit5.Text:=floattostrF(PBi[s].T,ffFixed,4,2);
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.RadioButton4Click(Sender: TObject);
var
  s:integer;
begin
  Radiobutton4.Checked:=true;
  Radiobutton5.Checked:=false;
  Radiobutton6.Checked:=false;
  for s:=0 to NBi-1 do
    PBi[s].Zagot:=0;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Image1Click(Sender: TObject);
var
  s:integer;
begin
  Radiobutton4.Checked:=true;
  Radiobutton5.Checked:=false;
  Radiobutton6.Checked:=false;
  for s:=0 to NBi-1 do
    PBi[s].Zagot:=0;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.RadioButton5Click(Sender: TObject);
var
  s:integer;
begin
  Radiobutton4.Checked:=false;
  Radiobutton5.Checked:=true;
  Radiobutton6.Checked:=false;
  for s:=0 to NBi-1 do
      PBi[s].Zagot:=1;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Image2Click(Sender: TObject);
var
  s:integer;
begin
  Radiobutton4.Checked:=false;
  Radiobutton5.Checked:=true;
  Radiobutton6.Checked:=false;
  for s:=0 to NBi-1 do
    PBi[s].Zagot:=1;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.RadioButton6Click(Sender: TObject);
var
  s:integer;
begin
  Radiobutton4.Checked:=false;
  Radiobutton5.Checked:=false;
  Radiobutton6.Checked:=true;
  for s:=0 to NBi-1 do
    PBi[s].Zagot:=2;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Label10Click(Sender: TObject);
var
  s:integer;
begin
  Radiobutton4.Checked:=false;
  Radiobutton5.Checked:=false;
  Radiobutton6.Checked:=true;
  for s:=0 to NBi-1 do
    PBi[s].Zagot:=2;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.BitBtn2Click(Sender: TObject);
begin
 form8.Visible:=false;
 form4.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.SpeedButton1Click(Sender: TObject);
var
  s:integer;
begin
  for s:=1 to NBi do
  begin
    Stringgrid1.Cells[s,0]:='B'+inttostr(PBi[s-1].NBi);
    Stringgrid1.Cells[s,1]:='('+PBi[s-1].N1+' - '+PBi[s-1].N2+')';
    Stringgrid1.Cells[s,2]:=floattostr(PBi[s-1].Size);
    Stringgrid1.Cells[s,3]:=floattostr(PBi[s-1].T);
    Stringgrid1.Cells[s,4]:=floattostr(PBi[s-1].ES);
    Stringgrid1.Cells[s,5]:=floattostr(PBi[s-1].EI);
    Stringgrid1.Cells[s,6]:=floattostr(PBi[s-1].Bmax);
    Stringgrid1.Cells[s,7]:=floattostr(PBi[s-1].Bmin);
    case PBi[s-1].Zagot of
      0: Stringgrid1.Cells[s,8]:='Виливок';
      1: Stringgrid1.Cells[s,8]:='Штамповка';
      2: Stringgrid1.Cells[s,8]:='Інший';
    end;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.SpeedButton2Click(Sender: TObject);
begin
  if MainUnit.Bi_rw=true then
  begin
    Bi_rw:=false;
    form8.Visible:=false;
  end
  else form8.Visible:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.Bi_Close;
var
  s : integer;
begin
  for s:=0 to NBi-1 do
  begin
    if (PBi[s].Size<>0) and (PBi[s].ES<>0) and (PBi[s].EI<>0) then
    begin
      PBi[s].Em:=(PBi[s].ES+PBi[s].EI)/2;
      PBi[s].Bm:=PBi[s].Size+PBi[s].Em;
      PBi[s].T:=abs(PBi[s].ES)+abs(PBi[s].EI);
    end
    else
    begin
      if (PBi[s].Bmax>0) and (PBi[s].Bmin>0) then
          PBi[s].T:=PBi[s].Bmax-PBi[s].Bmin;
          case PBi[s].Zagot of
          -1:;
           0:begin
              PBi[s].ES:=PBi[s].T/2;
              PBi[s].EI:=PBi[s].ES-PBi[s].T;
              PBi[s].Em:=(PBi[s].ES+PBi[s].EI)/2;
             end;
           1:begin
              PBi[s].ES:=2*PBi[s].T/3;
              PBi[s].EI:=PBi[s].ES-PBi[s].T;
              PBi[s].Em:=(PBi[s].ES+PBi[s].EI)/2;
             end;
           2:begin
              PBi[s].ES:=PBi[s].T/2;
              PBi[s].EI:=PBi[s].ES-PBi[s].T;
              PBi[s].Em:=(PBi[s].ES+PBi[s].EI)/2;
             end;
          end;
       end;
    PBi[s].W:=PBi[s].T;
    end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm8.BitBtn1Click(Sender: TObject);
var
  s,t:integer;
begin
  t:=0;
  for s:=0 to NBi-1 do
  begin
    if (PBi[s].N1List=-1) or (PBi[s].N2List=-1) then
    begin
      t:=1;
      break;
    end;
  end;

  if t=1 then
  begin
      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Недостатньо даних для розрахунку!!!'+#13#10+
                  'Введіть розмірні зв''язки.');
  end
  else
///////////////////////////захист від дурня/////////////////////////////////////

   if (t<>1) then begin
    Bi_Close;
    if MainUnit.Bi_rw=true then
    begin
      Bi_rw:=false;
      Form8.Visible:=false;
      UnitTB.Form11.BitBtn1.Click;
      MainUnit.Rw:=true;
    end
    else
    begin
      Form8.Visible:=false;
      Form9.Show;
    end;
 end;
end;
{..............................................................................}
end.

