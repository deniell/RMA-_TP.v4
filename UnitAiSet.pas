unit UnitAiSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, Buttons, Unit_NewCalc, UnitPovParametrs,
  Unit_Otklon, ExtCtrls, Grids, DataUnit, SettingsUnit, Menus;

type
  TForm4 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StringGrid1: TStringGrid;
    Button5: TButton;
    Bevel2: TBevel;
    TabControl1: TTabControl;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel3: TBevel;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    GroupBox1: TGroupBox;
    SpeedButton1: TSpeedButton;
    Edit5: TEdit;
    RadioButton1: TRadioButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label7: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    RadioButton2: TRadioButton;
    RadioGroup1: TRadioGroup;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    RadioButton3: TRadioButton;
    Edit6: TEdit;
    Edit7: TEdit;
    Label10: TLabel;
    Bevel4: TBevel;
    SpeedButton2: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    H71: TMenuItem;
    JS71: TMenuItem;
    K71: TMenuItem;
    N71: TMenuItem;
    P71: TMenuItem;
    F81: TMenuItem;
    H81: TMenuItem;
    E91: TMenuItem;
    H91: TMenuItem;
    C101: TMenuItem;
    D101: TMenuItem;
    H101: TMenuItem;
    A111: TMenuItem;
    B111: TMenuItem;
    C111: TMenuItem;
    D111: TMenuItem;
    H111: TMenuItem;
    N2: TMenuItem;
    g61: TMenuItem;
    h61: TMenuItem;
    js61: TMenuItem;
    k61: TMenuItem;
    n61: TMenuItem;
    p61: TMenuItem;
    r61: TMenuItem;
    s61: TMenuItem;
    f71: TMenuItem;
    h72: TMenuItem;
    e81: TMenuItem;
    h82: TMenuItem;
    d91: TMenuItem;
    h92: TMenuItem;
    d112: TMenuItem;
    h112: TMenuItem;
    N3: TMenuItem;
    js62: TMenuItem;
    js72: TMenuItem;
    js81: TMenuItem;
    js91: TMenuItem;
    js101: TMenuItem;
    js121: TMenuItem;
    js141: TMenuItem;
    Panel1: TPanel;
    Image1: TImage;
    Im_dialog: TImageList;
    SpeedButton3: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit5DblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure H71Click(Sender: TObject);
    procedure JS71Click(Sender: TObject);
    procedure K71Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure P71Click(Sender: TObject);
    procedure F81Click(Sender: TObject);
    procedure H81Click(Sender: TObject);
    procedure E91Click(Sender: TObject);
    procedure H91Click(Sender: TObject);
    procedure C101Click(Sender: TObject);
    procedure D101Click(Sender: TObject);
    procedure H101Click(Sender: TObject);
    procedure A111Click(Sender: TObject);
    procedure B111Click(Sender: TObject);
    procedure C111Click(Sender: TObject);
    procedure D111Click(Sender: TObject);
    procedure H111Click(Sender: TObject);
    procedure g61Click(Sender: TObject);
    procedure h61Click(Sender: TObject);
    procedure js61Click(Sender: TObject);
    procedure k61Click(Sender: TObject);
    procedure n61Click(Sender: TObject);
    procedure p61Click(Sender: TObject);
    procedure r61Click(Sender: TObject);
    procedure s61Click(Sender: TObject);
    procedure f71Click(Sender: TObject);
    procedure h72Click(Sender: TObject);
    procedure e81Click(Sender: TObject);
    procedure h82Click(Sender: TObject);
    procedure d91Click(Sender: TObject);
    procedure h92Click(Sender: TObject);
    procedure d112Click(Sender: TObject);
    procedure h112Click(Sender: TObject);
    procedure js62Click(Sender: TObject);
    procedure js72Click(Sender: TObject);
    procedure js81Click(Sender: TObject);
    procedure js91Click(Sender: TObject);
    procedure js101Click(Sender: TObject);
    procedure js121Click(Sender: TObject);
    procedure js141Click(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5Exit(Sender: TObject);
    procedure Ai_Show;
    procedure Ai_Close;
    procedure SpeedButton3Click(Sender: TObject);
    function  AnsiPos(const Substr, S: string; FromPos: integer): Integer;
  private
    { Private declarations }
  public
  //DecimalSeparator: Char;
    { Public declarations }
  end;

var
  Form4: TForm4;
  counter, typeA : integer;
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
  z,z_ : integer;
  adres: String; //для адреса, откуда запущена программа
  PAi: array of TAi;               //Масив властивостей конструкторських розм.

const
  Incl: array [0..9] of string =
  ('1','2','3','4','5','6','7','8','9','0');

implementation
uses MainUnit,
     ESDP,
     UnitRozmFType,
     UnitBiSet,
     UnitFiSet,
     UnitTB;
{$R *.dfm}
{..............................................................................}
procedure TForm4.Ai_Show;
var s:integer;
begin
 z_:=1;
 NAi:=Unit_NewCalc.NAi;
 NZag:=Unit_NewCalc.NZag;
 NDet:=Unit_NewCalc.NDet;
 if mainunit.counter<2 then begin
  SetLength(PAi,NAi+5);     //Задання масиву конструкторських розмірів
  for s:=0 to NAi+4 do begin
   PAi[s].NAi:=0;
   PAi[s].N1List:=-1;
   PAi[s].N1:='';
   PAi[s].N1f:='';
   PAi[s].N2List:=-1;
   PAi[s].N2:='';
   PAi[s].N2f:='';
   PAi[s].Size:=0;
   PAi[s].IT:='';
   PAi[s].ES:=0;
   PAi[s].EI:=0;
   PAi[s].T:=0;
   PAi[s].Em:=0;
   PAi[s].Amax:=0;
   PAi[s].Amin:=0;
   PAi[s].Am:=0;
   PAi[s].Kind:=-1;
   PAi[s].Psi:=0;
   PAi[s].W:=0;
  end;
  mainunit.counter:=2;
 end else begin
  if Length(PAi)=0 then begin
   SetLength(PAi,NAi);     //Задання масиву конструкторських розмірів
   for s:=0 to NAi-1 do begin
    PAi[s].NAi:=MainUnit.PAi[s].NAi;
    PAi[s].N1List:=MainUnit.PAi[s].N1List;
    PAi[s].N1:=MainUnit.PAi[s].N1;
    PAi[s].N1f:=MainUnit.PAi[s].N1f;
    PAi[s].N2List:=MainUnit.PAi[s].N2List;
    PAi[s].N2:=MainUnit.PAi[s].N2;
    PAi[s].N2f:=MainUnit.PAi[s].N2f;
    PAi[s].Size:=MainUnit.PAi[s].Size;
    PAi[s].IT:=MainUnit.PAi[s].IT;
    PAi[s].ES:=MainUnit.PAi[s].ES;
    PAi[s].EI:=MainUnit.PAi[s].EI;
    PAi[s].T:=MainUnit.PAi[s].T;
    PAi[s].Em:=MainUnit.PAi[s].Em;
    PAi[s].Amax:=MainUnit.PAi[s].Amax;
    PAi[s].Amin:=MainUnit.PAi[s].Amin;
    PAi[s].Am:=MainUnit.PAi[s].Am;
    PAi[s].Kind:=MainUnit.PAi[s].Kind;
    PAi[s].Psi:=MainUnit.PAi[s].Psi;
    PAi[s].W:=0;
   end;
   finalize(MainUnit.PAi);
  end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.FormShow(Sender: TObject);
var
   i,j,a,s: integer;
   n,p: string;
   tmp_f : TStrings;
begin
Form4.Height:=420;
SpeedButton2.Visible:=false;
Radiogroup1.Visible:=true;

//в залежності від значення параметра Ai_rw в Mainunit можна чи ні повернутись

if Mainunit.Ai_rw=true then begin
 Bitbtn2.Visible:=false;
 Bitbtn1.Caption:=' Ок ';
 Im_dialog.GetBitmap(3,Bitbtn1.Glyph);
end else begin
 Bitbtn2.Visible:=true;
 Bitbtn2.Caption:='Назад';
 Im_dialog.GetBitmap(0,Bitbtn2.Glyph);
 Bitbtn1.Caption:='Далі';
 Im_dialog.GetBitmap(1,Bitbtn1.Glyph);
end;

if SettingsUnit.Set1.Addings=true then Button5.Visible:=true
else Button5.Visible:=false;

Ai_Show;

Tabcontrol1.Tabs.Clear;
i:=1;
repeat
n:='A'+inttostr(i);
Tabcontrol1.TabIndex:=(i-1);
Tabcontrol1.Tabs.Add(n);
i:=i+1;
until i=(NAi+1);
Label10.Caption:='Конструкторські розміри';
Label1.Caption:='Розмір A1';
Combobox1.Items.Clear;
Combobox2.Items.Clear;
 //str:=Application.ExeName;
 //ls:=length(Application.ExeName);
 //setlength(str,ls-15);
 adres := ExtractFilePath(Application.ExeName);
 tmp_f:=TStringList.Create();
 tmp_f.LoadFromFile(adres+'shapes.dat');
 a:=tmp_f.IndexOf('[Ai]')+1;
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
if PAi[s].NAi=0 then begin
      Label1.Caption:='Розмір A'+inttostr(s+1);
      Combobox1.ItemIndex:=-1;
      Combobox2.ItemIndex:=-1;
      Edit2.Text:='';
      Edit3.Text:='';
      Edit4.Text:='';
      Edit5.Text:='';
      Edit6.Text:='';
      Edit7.Text:='';
      Radiogroup1.ItemIndex:=-1;
      end else begin
      Edit5.Text:='';
      Label1.Caption:='Розмір A'+inttostr(PAi[s].NAi);
      Combobox1.ItemIndex:=PAi[s].N1List;
      Combobox2.ItemIndex:=PAi[s].N2List;
      Edit2.Text:=floattostr(PAi[s].Size);
      Edit3.Text:=floattostr(PAi[s].ES);
      Edit4.Text:=floattostr(PAi[s].EI);
      Edit6.Text:=floattostr(PAi[s].Amax);
      Edit7.Text:=floattostr(PAi[s].Amin);
      Radiogroup1.ItemIndex:=PAi[s].Kind;
      if (PAi[s].IT<>' ') or (PAi[s].IT<>'') then begin
       RadioButton1Click(nil);
       Edit5.Text:=PAi[s].IT;
      end else
       RadioButton2Click(nil);
      end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.SpeedButton1Click(Sender: TObject);
begin
if Radiogroup1.ItemIndex=-1 then
MessageDlg('Оберіть тип розміру',mtWarning,[mbOK],0) else
begin
Unit_Otklon.Form6.Visible:=true;
Form4.Enabled:=false;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.TabControl1Change(Sender: TObject);
var
   s:integer;
begin
      s:=Tabcontrol1.TabIndex;
      if PAi[s].NAi=0 then
      begin
        Label1.Caption:='Розмір A'+inttostr(s+1);
        Combobox1.ItemIndex:=-1;
        Combobox2.ItemIndex:=-1;
        Edit2.Text:='';
        Edit3.Text:='';
        Edit4.Text:='';
        Edit5.Text:='';
        Edit6.Text:='';
        Edit7.Text:='';
        Radiogroup1.ItemIndex:=-1;
      end
      else
      begin
        Edit5.Text:='';
        Label1.Caption:='Розмір A'+inttostr(PAi[s].NAi);
        Combobox1.ItemIndex:=PAi[s].N1List;
        Combobox2.ItemIndex:=PAi[s].N2List;
        Edit2.Text:=floattostr(PAi[s].Size);
        Edit3.Text:=floattostr(PAi[s].ES);
        Edit4.Text:=floattostr(PAi[s].EI);
        Edit6.Text:=floattostr(PAi[s].Amax);
        Edit7.Text:=floattostr(PAi[s].Amin);
        Radiogroup1.ItemIndex:=PAi[s].Kind;
        if (PAi[s].IT<>' ') or (PAi[s].IT<>'') then
        begin
          RadioButton1Click(Sender);
          Edit5.Text:=PAi[s].IT;
        end
        else
          RadioButton2Click(Sender);
      end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.RadioButton1Click(Sender: TObject);
begin
Radiobutton1.Checked:=true;
Edit5.Enabled:=true;
Speedbutton1.Enabled:=true;
Radiobutton2.Checked:=false;
Edit3.Enabled:=false;
Edit4.Enabled:=false;
Radiobutton3.Checked:=false;
Edit6.Enabled:=false;
Edit7.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.RadioButton2Click(Sender: TObject);
begin
Radiobutton1.Checked:=false;
Edit5.Enabled:=false;
Speedbutton1.Enabled:=true;
Radiobutton2.Checked:=true;
Edit3.Enabled:=true;
Edit4.Enabled:=true;
Radiobutton3.Checked:=false;
Edit6.Enabled:=false;
Edit7.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.RadioButton3Click(Sender: TObject);
begin
Radiobutton1.Checked:=false;
Edit5.Enabled:=false;
Speedbutton1.Enabled:=true;
Radiobutton2.Checked:=false;
Edit3.Enabled:=false;
Edit4.Enabled:=false;
Radiobutton3.Checked:=true;
Edit6.Enabled:=true;
Edit7.Enabled:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Button5Click(Sender: TObject);
var s:integer;
begin
if z_=1 then begin
Form4.Height:=677;
z_:=0;
SpeedButton2.Visible:=true;
Button5.Caption:='Додатково <<';
end else begin
Form4.Height:=420;
z_:=1;
SpeedButton2.Visible:=false;
Button5.Caption:='Додатково >>';
end;
{----->>>> Інфо масиву - конструкторські розміри}
Stringgrid1.ColCount:=NAi+1;
Stringgrid1.RowCount:=10;
Stringgrid1.Cells[0,0]:='Позначення розм.';
Stringgrid1.Cells[0,1]:='Розмірні звя''зки';
Stringgrid1.Cells[0,2]:='Розмірні звя''зки';
Stringgrid1.Cells[0,3]:='Розмір';
Stringgrid1.Cells[0,4]:='Квалітет';
Stringgrid1.Cells[0,5]:='ES';
Stringgrid1.Cells[0,6]:='EI';
Stringgrid1.Cells[0,7]:='A max';
Stringgrid1.Cells[0,8]:='A min';
Stringgrid1.Cells[0,9]:='Тип';
for s:=1 to NAi do begin
Stringgrid1.Cells[s,0]:='A'+inttostr(PAi[s-1].NAi);
Stringgrid1.Cells[s,1]:='('+PAi[s-1].N1+' - '+PAi[s-1].N2+')';
Stringgrid1.Cells[s,2]:='('+PAi[s-1].N1f+' - '+PAi[s-1].N2f+')';
Stringgrid1.Cells[s,3]:=floattostr(PAi[s-1].Size);
Stringgrid1.Cells[s,4]:=PAi[s-1].IT;
Stringgrid1.Cells[s,5]:=floattostr(PAi[s-1].ES);
Stringgrid1.Cells[s,6]:=floattostr(PAi[s-1].EI);
Stringgrid1.Cells[s,7]:=floattostr(PAi[s-1].Amax);
Stringgrid1.Cells[s,8]:=floattostr(PAi[s-1].Amin);
case PAi[s-1].Kind of
  -1: Stringgrid1.Cells[s,9]:='не заданий';
   0: Stringgrid1.Cells[s,9]:='вал';
   1: Stringgrid1.Cells[s,9]:='отвір';
   2: Stringgrid1.Cells[s,9]:='інший';
end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.ComboBox1Change(Sender: TObject);
var
  s,i:integer;
  a : string;
begin
      s:=Tabcontrol1.TabIndex;
      PAi[s].NAi:=Tabcontrol1.TabIndex+1;
      i:=Combobox1.ItemIndex;
      PAi[s].N1List:=i;
      PAi[s].N1:=Combobox1.Text;
      a := Combobox1.Text;
      if (AnsiPos('a',a,1) <> 0) then
         PAi[s].N1f:=inttostr(i+1)+'a.'+inttostr(UnitPovParametrs.POb[i].Ob)+'f'
      else
      PAi[s].N1f:=inttostr(i+1)+'.'+inttostr(UnitPovParametrs.POb[i].Ob)+'f';
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.ComboBox2Change(Sender: TObject);
var
  s,i:integer;
  a : string;
begin
      s:=Tabcontrol1.TabIndex;
      PAi[s].NAi:=Tabcontrol1.TabIndex+1;
      i:=Combobox2.ItemIndex;
      PAi[s].N2List:=i;
      PAi[s].N2:=Combobox2.Text;
      a := Combobox2.Text;
      if (AnsiPos('a',a,1) <> 0) then
         PAi[s].N2f:=inttostr(i+1)+'a.'+inttostr(UnitPovParametrs.POb[i].Ob)+'f'
      else
      PAi[s].N2f:=inttostr(i+1)+'.'+inttostr(UnitPovParametrs.POb[i].Ob)+'f';
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit2KeyPress(Sender: TObject; var Key: Char);
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
        PAi[s].NAi:=s+1;
        if (Edit2.Text)<>'' then
          PAi[s].Size:=strtofloat(Edit2.Text);
          Edit3Exit(Sender);
          Edit4Exit(Sender);

        end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit2Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
  PAi[s].NAi:=s+1;
  if (Edit2.Text)<>'' then PAi[s].Size:=strtofloat(Edit2.Text);
  Edit3Exit(Sender);
  Edit4Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit5KeyPress(Sender: TObject; var Key: Char);

begin
  case Key of
  #8,'0'..'9','a'..'z','A'..'Z': ; // цифры,буквы Lat и <Backspace>
  #13: // клавиша <Enter>
  Edit5Exit(Sender);
  else // остальные символы запрещены
  key := Chr(0);
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit5Exit(Sender: TObject);
var s:integer; Rozmir:string;
begin
 s:=Tabcontrol1.TabIndex;
 PAi[s].NAi:=s+1;

       if Radiogroup1.ItemIndex=-1 then
       MessageDlg('Оберіть тип розміру',mtWarning,[mbOK],0)
       else
 if (Edit5.Text<>'') and (Edit2.Text<>'') then begin
  PAi[s].IT:=Edit5.Text;
  case Radiogroup1.ItemIndex of
   0:begin
      Rozmir:=Edit2.Text+Edit5.Text;
      Wal(Rozmir,IT,Dmax,Dmin,D,Dopusk,Es,Ei,Osnov_Otklon,Kod);
     end;
   1:begin
      Rozmir:=Edit2.Text+Edit5.Text;
      Otvir(Rozmir,IT,Dmax,Dmin,D,Dopusk,Es,Ei,Osnov_Otklon,Kod);
     end;
   2:begin
      Rozmir:=Edit2.Text+Edit5.Text;
      Liniyni(Rozmir,IT,Dmax,Dmin,D,Dopusk,Es,Ei,Osnov_Otklon,Kod);
     end;
  end;
  Edit3.Text:=floattostr(Es/1000);
  Edit4.Text:=floattostr(Ei/1000);
  Edit6.Text:=floattostr(Dmax);
  Edit7.Text:=floattostr(Dmin);
  PAi[s].ES:=Es/1000;
  PAi[s].EI:=Ei/1000;
  PAi[s].Amax:=Dmax;
  PAi[s].Amin:=Dmin;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit3KeyPress(Sender: TObject; var Key: Char);
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
        PAi[s].NAi:=s+1;
        Edit5.Text:='';
        if (Edit3.Text<>'') and (Edit3.Text<>'-') and (Edit3.Text<>'+') then
        PAi[s].ES:=strtofloat(Edit3.Text);
        if (PAi[s].Size<>0) and (Edit3.Text<>'-') and (Edit3.Text<>'+') then
        PAi[s].Amax:=PAi[s].Size+PAi[s].ES;
        Edit6.Text:=floattostr(PAi[s].Amax);
        end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit3Exit(Sender: TObject);
var s:integer;
 begin
s:=Tabcontrol1.TabIndex;
PAi[s].NAi:=s+1;
Edit5.Text:='';
if (Edit3.Text<>'') and (Edit3.Text<>'-') and (Edit3.Text<>'+') then
PAi[s].ES:=strtofloat(Edit3.Text);
if (PAi[s].Size<>0) and (Edit3.Text<>'-') and (Edit3.Text<>'+') then begin
PAi[s].Amax:=PAi[s].Size+PAi[s].ES;
Edit6.Text:=floattostr(PAi[s].Amax);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit4KeyPress(Sender: TObject; var Key: Char);
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
        PAi[s].NAi:=s+1;
        Edit5.Text:='';
        if (Edit4.Text<>'') and (Edit4.Text<>'-') and (Edit4.Text<>'+') then
        PAi[s].EI:=strtofloat(Edit4.Text);
        if (PAi[s].Size<>0) and (Edit4.Text<>'-') and (Edit4.Text<>'+') then
        PAi[s].Amin:=PAi[s].Size+PAi[s].EI;
        Edit7.Text:=floattostr(PAi[s].Amin);
        end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit4Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PAi[s].NAi:=s+1;
Edit5.Text:='';
if (Edit4.Text<>'') and (Edit4.Text<>'-') and (Edit4.Text<>'+') then
PAi[s].EI:=strtofloat(Edit4.Text);
if (PAi[s].Size<>0) and (Edit4.Text<>'-') and (Edit4.Text<>'+') then begin
PAi[s].Amin:=PAi[s].Size+PAi[s].EI;
Edit7.Text:=floattostr(PAi[s].Amin);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit6KeyPress(Sender: TObject; var Key: Char);
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
        PAi[s].NAi:=s+1;
        Edit5.Text:='';
        if (Edit6.Text)<>'' then
        PAi[s].Amax:=strtofloat(Edit6.Text);
        if (PAi[s].Size<>0) then
        PAi[s].ES:=PAi[s].Amax-PAi[s].Size;
        Edit3.Text:=floattostrF(PAi[s].ES,ffFixed,4,2);
        end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit6Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PAi[s].NAi:=s+1;
Edit5.Text:='';
if (Edit6.Text)<>'' then
PAi[s].Amax:=strtofloat(Edit6.Text);
if (PAi[s].Size<>0) then begin
PAi[s].ES:=PAi[s].Amax-PAi[s].Size;
Edit3.Text:=floattostrF(PAi[s].ES,ffFixed,4,2);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit7KeyPress(Sender: TObject; var Key: Char);
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
        PAi[s].NAi:=s+1;
        Edit5.Text:='';
        if (Edit7.Text)<>'' then
        PAi[s].Amin:=strtofloat(Edit7.Text);
        if (PAi[s].Size<>0) then
        PAi[s].EI:=PAi[s].Amin-PAi[s].Size;
        Edit4.Text:=floattostrF(PAi[s].EI,ffFixed,4,2);
        end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit7Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PAi[s].NAi:=s+1;
Edit5.Text:='';
if (Edit7.Text)<>'' then
PAi[s].Amin:=strtofloat(Edit7.Text);
if (PAi[s].Size<>0) then begin
PAi[s].EI:=PAi[s].Amin-PAi[s].Size;
Edit4.Text:=floattostrF(PAi[s].EI,ffFixed,4,2);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.RadioGroup1Click(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
case Radiogroup1.ItemIndex of
  0:begin
    typeA:=1;
    PAi[s].Kind:=0;
    end;
  1:begin
    typeA:=2;
    PAi[s].Kind:=1;
    end;
  2:begin
    typeA:=3;
    PAi[s].Kind:=2;
    end;
end;
if (Edit5.Text<>'') and (Edit2.Text<>'') then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.BitBtn2Click(Sender: TObject);
begin
  Form4.Visible:=false;
  Form5.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Edit5DblClick(Sender: TObject);
var
  p:TPoint;
begin
  GetCursorPos(p);
  Popupmenu1.Popup(p.X,p.Y);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.SpeedButton2Click(Sender: TObject);
var s:integer;
begin
  for s:=1 to NAi do begin
  Stringgrid1.Cells[s,0]:='A'+inttostr(PAi[s-1].NAi);
  Stringgrid1.Cells[s,1]:='('+PAi[s-1].N1+' - '+PAi[s-1].N2+')';
  Stringgrid1.Cells[s,2]:='('+PAi[s-1].N1f+' - '+PAi[s-1].N2f+')';
  Stringgrid1.Cells[s,3]:=floattostr(PAi[s-1].Size);
  Stringgrid1.Cells[s,4]:=PAi[s-1].IT;
  Stringgrid1.Cells[s,5]:=floattostr(PAi[s-1].ES);
  Stringgrid1.Cells[s,6]:=floattostr(PAi[s-1].EI);
  Stringgrid1.Cells[s,7]:=floattostr(PAi[s-1].Amax);
  Stringgrid1.Cells[s,8]:=floattostr(PAi[s-1].Amin);
  case PAi[s-1].Kind of
  -1: Stringgrid1.Cells[s,9]:='не заданий';
   0: Stringgrid1.Cells[s,9]:='вал';
   1: Stringgrid1.Cells[s,9]:='отвір';
   2: Stringgrid1.Cells[s,9]:='інший';
  end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.SpeedButton3Click(Sender: TObject);
begin
 if MainUnit.Ai_rw=true then begin
  MainUnit.Ai_rw:=false;
  Form4.Visible:=false;
 end else Form4.Visible:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.H71Click(Sender: TObject);
begin
Edit5.Text:='H7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.JS71Click(Sender: TObject);
begin
Edit5.Text:='JS7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.K71Click(Sender: TObject);
begin
Edit5.Text:='K7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.N71Click(Sender: TObject);
begin
Edit5.Text:='N7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.P71Click(Sender: TObject);
begin
Edit5.Text:='P7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.F81Click(Sender: TObject);
begin
Edit5.Text:='F8';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.H81Click(Sender: TObject);
begin
Edit5.Text:='H8';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.E91Click(Sender: TObject);
begin
Edit5.Text:='E9';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.H91Click(Sender: TObject);
begin
Edit5.Text:='H9';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.C101Click(Sender: TObject);
begin
Edit5.Text:='C10';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.D101Click(Sender: TObject);
begin
Edit5.Text:='D10';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.H101Click(Sender: TObject);
begin
Edit5.Text:='H10';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.A111Click(Sender: TObject);
begin
Edit5.Text:='A11';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.B111Click(Sender: TObject);
begin
Edit5.Text:='B11';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.C111Click(Sender: TObject);
begin
Edit5.Text:='C11';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.D111Click(Sender: TObject);
begin
Edit5.Text:='D11';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.H111Click(Sender: TObject);
begin
Edit5.Text:='H11';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.g61Click(Sender: TObject);
begin
Edit5.Text:='g6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.h61Click(Sender: TObject);
begin
Edit5.Text:='h6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js61Click(Sender: TObject);
begin
Edit5.Text:='js6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.k61Click(Sender: TObject);
begin
Edit5.Text:='k6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.n61Click(Sender: TObject);
begin
Edit5.Text:='n6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.p61Click(Sender: TObject);
begin
Edit5.Text:='p6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.r61Click(Sender: TObject);
begin
Edit5.Text:='r6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.s61Click(Sender: TObject);
begin
Edit5.Text:='s6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.f71Click(Sender: TObject);
begin
Edit5.Text:='f7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.h72Click(Sender: TObject);
begin
Edit5.Text:='h7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.e81Click(Sender: TObject);
begin
Edit5.Text:='e8';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.h82Click(Sender: TObject);
begin
Edit5.Text:='h8';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.d91Click(Sender: TObject);
begin
Edit5.Text:='d9';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.h92Click(Sender: TObject);
begin
Edit5.Text:='h9';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.d112Click(Sender: TObject);
begin
Edit5.Text:='d11';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.h112Click(Sender: TObject);
begin
Edit5.Text:='h11';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js62Click(Sender: TObject);
begin
Edit5.Text:='js6';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js72Click(Sender: TObject);
begin
Edit5.Text:='js7';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js81Click(Sender: TObject);
begin
Edit5.Text:='js8';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js91Click(Sender: TObject);
begin
Edit5.Text:='js9';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js101Click(Sender: TObject);
begin
Edit5.Text:='js10';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js121Click(Sender: TObject);
begin
Edit5.Text:='js12';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.js141Click(Sender: TObject);
begin
Edit5.Text:='js14';
if Edit2.Text<>'' then Edit5Exit(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm4.Ai_Close;
var s:integer;
begin
 for s:=0 to NAi-1 do
 begin
    if (PAi[s].Size<>0) and (PAi[s].Amax<>0) and (PAi[s].Amin<>0) then
    begin
// формула перещета припусков
      PAi[s].Em:=(PAi[s].ES+PAi[s].EI)/2;
      PAi[s].Am:=PAi[s].Size+PAi[s].Em;
      PAi[s].T:=abs(PAi[s].ES)+abs(PAi[s].EI);
// формула перещета припусков
    end;
    PAi[s].W:=PAi[s].T;
 end;

end;
{..............................................................................}

{..............................................................................}
procedure TForm4.BitBtn1Click(Sender: TObject);
var
    s,t1,t2,t3:integer;
    p:string;
begin
    t1:=0;  t2:=0;   t3:=0;  p:='';
///////////////////////////захист від дурня/////////////////////////////////////
  begin
    for s:=0 to NAi-1 do begin
       if (PAi[s].N1List=-1) or (PAi[s].N2List=-1) then
       begin
          t1:=1;
          break;
       end;
    end;

     if t1=1 then  begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Недостатньо даних для розрахунку!!!'+#13#10+
                  'Введіть розмірні зв''язки.');
     end
      else
///////////////////////////захист від дурня/////////////////////////////////////

    for s:=0 to NAi-1 do begin

    if (PAi[s].Kind=-1) then
        begin
          t2:=1;
          break;
       end;
    end;

     if t2=1 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Оберіть тип розміру');
     end
      else
///////////////////////////захист від дурня/////////////////////////////////////

     for s:=0 to NAi-1 do begin

    if PAi[s].Size=0 then
        begin
          t3:=1;
          break;
       end;
    end;

     if t3=1 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Введіть значення номінального розміру');
     end;

/////////////////////////////захист від дурня///////////////////////////////////
     if (t1<>1) and (t2<>1) and (t3<>1) then begin



      Ai_Close;
      if MainUnit.Ai_rw=true then
        begin
          Form4.Visible:=false;
          UnitTB.Form11.BitBtn1.Click;
          MainUnit.Ai_rw:=false;
          MainUnit.Rw:=true;
        end
        else
        begin
          Form4.Visible:=false;
          Form8.Show;
        end;
     end;
  end;
end;
{..............................................................................}
//функція для Комбобоксів
{..............................................................................}
function TForm4.AnsiPos(const Substr, S: string; FromPos: integer): Integer;
var
  P: PChar;
begin
  Result := 0;
  P := AnsiStrPos(PChar(S) + fromPos - 1, PChar(SubStr));
  if P <> nil then
    Result := Integer(P) - Integer(PChar(S)) + 1;
end;
{..............................................................................}
end.

