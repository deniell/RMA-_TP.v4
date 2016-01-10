unit UnitFiSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, Buttons, Unit_NewCalc,
  Unit_Otklon, ExtCtrls, Grids, DataUnit, SettingsUnit, Menus;

type
  TForm9 = class(TForm)
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
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    RadioGroup1: TRadioGroup;
    GroupBox5: TGroupBox;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    Bevel4: TBevel;
    Label10: TLabel;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Edit4: TEdit;
    PopupMenu1: TPopupMenu;
    IT14101: TMenuItem;
    IT971: TMenuItem;
    IT651: TMenuItem;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Image1: TImage;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Bevel5: TBevel;
    RadioButton3: TRadioButton;
    Edit5: TEdit;
    UpDown1: TUpDown;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    SpeedButton6: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure RadioButton7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RadioButton8MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RadioButton9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RadioButton10MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GroupBox5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure IT14101Click(Sender: TObject);
    procedure IT971Click(Sender: TObject);
    procedure IT651Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure TabControl1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Fi_Show;
    procedure Fi_Close;
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private declarations }
  public
  //DecimalSeparator: Char;
  { Public declarations }
  end;

var
  Form9: TForm9;
  counter: integer;
  Name, fname, Mname: string;
  forma,
  Mtype,
  NOp,                             //К-сть операцій ТП
  NZag,                            //К-сть поверхонь заготовки
  NDet,                            //К-сть поверхонь деталі
  NBi,                             //К-сть розмірів заготовки
  NAi,                             //К-сть конструкторських розмірів
  NFi,                             //К-сть технологічних розмірів
  Zn, nshapes  : integer;                   //К-сть припусків
  z,z_ : integer;
  adres: String; //для адреса, откуда запущена программа
  Ch : array [0..999] of integer;  //К-сть обробок і-ої поверхні
  PFi: array of TFi;               //Масив властивостей технологічних розм.
  procedure Delay(Value: Cardinal);

const
  Incl: array [0..9] of string =
  ('1','2','3','4','5','6','7','8','9','0');

implementation
uses UnitRozmFType,
     UnitBiSet,
     UWek,
     URvb,
     UEb,
     UnitZiSet,
     UnitPovParametrs,
     UnitAiSet,
     UnitTB,
     MainUnit;
{$R *.dfm}

{Delay, не загружающий процессор}
{..............................................................................}
procedure Delay(Value: Cardinal);
var
  F, N: Cardinal;
begin
  N := 0;
  while N <= (Value div 10) do
  begin
    SleepEx(1, True);
    Application.ProcessMessages;
    Inc(N);
  end;
  F := GetTickCount;
  repeat
    Application.ProcessMessages;
    N := GetTickCount;
  until (N - F >= (Value mod 10)) or (N < F);
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Fi_Show;
var s:integer;
begin
 NDet:=Unit_NewCalc.NDet;
 NFi:=Unit_NewCalc.NFi;

 if MainUnit.counter<4 then begin
  SetLength(PFi,NFi);   //Задання масиву технологічних розмірів
  for s:=0 to NFi-1 do begin
   PFi[s].NFi:=0;
   PFi[s].N1List:=-1;
   PFi[s].N1:='';
   PFi[s].N2List:=-1;
   PFi[s].N2:='';
   PFi[s].Size:=0;
   PFi[s].ES:=0;
   PFi[s].EI:=0;
   PFi[s].T:=0;
   PFi[s].Em:=0;
   PFi[s].Fmax:=0;
   PFi[s].Fmin:=0;
   PFi[s].Fm:=0;
   PFi[s].Wek:=0;
   PFi[s].Eb:=0;
   PFi[s].Rvb:=0;
   PFi[s].dRvb:=0;
   PFi[s].Koef:=0;
   PFi[s].Kind:=-1;
   PFi[s].Typ1:=0;
   PFi[s].IT:=0;
   PFi[s].W:=0;
   PFi[s].Oper:=0;
   PFi[s].AvtoEb:=-1;
  end;
  MainUnit.counter:=4;
 end else begin
  if Length(PFi)=0 then begin
   SetLength(PFi,NFi);   //Задання масиву технологічних розмірів
   for s:=0 to NFi-1 do begin
    PFi[s].NFi:=MainUnit.PFi[s].NFi;
    PFi[s].N1List:=MainUnit.PFi[s].N1List;
    PFi[s].N1:=MainUnit.PFi[s].N1;
    PFi[s].N2List:=MainUnit.PFi[s].N2List;
    PFi[s].N2:=MainUnit.PFi[s].N2;
    PFi[s].Size:=MainUnit.PFi[s].Size;
    PFi[s].ES:=MainUnit.PFi[s].ES;
    PFi[s].EI:=MainUnit.PFi[s].EI;
    PFi[s].T:=MainUnit.PFi[s].T;
    PFi[s].Em:=MainUnit.PFi[s].Em;
    PFi[s].Fmax:=MainUnit.PFi[s].Fmax;
    PFi[s].Fmin:=MainUnit.PFi[s].Fmin;
    PFi[s].Fm:=MainUnit.PFi[s].Fm;
    PFi[s].Wek:=MainUnit.PFi[s].Wek;
    PFi[s].Eb:=MainUnit.PFi[s].Eb;
    PFi[s].Rvb:=MainUnit.PFi[s].Rvb;
    PFi[s].dRvb:=0;
    PFi[s].Koef:=MainUnit.PFi[s].Koef;
    PFi[s].Kind:=MainUnit.PFi[s].Kind;
    PFi[s].Typ1:=MainUnit.PFi[s].Typ1;
    PFi[s].IT:=MainUnit.PFi[s].IT;
    PFi[s].W:=MainUnit.PFi[s].W;
    PFi[s].Oper:=MainUnit.PFi[s].Oper;
    PFi[s].AvtoEb:=MainUnit.PFi[s].AvtoEb;
   end;
   finalize(MainUnit.PFi);
  end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.FormShow(Sender: TObject);
var
   i,j,s{,nshapes}:integer;
   n : string;
   tmp_f : TStrings;
begin
 Form9.Height:=420;
 SpeedButton5.Visible:=false;
 z_:=1;

 if Mainunit.Fi_rw=true then begin
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

// str:=Application.ExeName;
// ls:=length(Application.ExeName);
// setlength(str,ls-15);
 adres := ExtractFilePath(Application.ExeName);
 tmp_f:=TStringList.Create();
 tmp_f.LoadFromFile(adres+'shapes.dat');
 nshapes:=strtoint(tmp_f.ValueFromIndex[0]);
 Zn:=strtoint(tmp_f.ValueFromIndex[1]);
 tmp_f.Free;

 Fi_Show;

 Tabcontrol1.Tabs.Clear;
 Edit1.Clear;
 Edit2.Clear;
 Edit3.Clear;
 Edit4.Clear;
 i:=1;
 repeat
  n:='F'+inttostr(i);
  Tabcontrol1.TabIndex:=(i-1);
  Tabcontrol1.Tabs.Add(n);
  i:=i+1;
 until i=(NFi+1);
 z:=3;
 Label10.Caption:='Технологічні розміри';

 Combobox1.Visible:=true;
 Combobox2.Visible:=true;
 Combobox1.Items.Clear;
 Combobox2.Items.Clear;

 //str:=Application.ExeName;
 //ls:=length(Application.ExeName);
 //setlength(str,ls-15);
 tmp_f:=TStringList.Create();
 tmp_f.LoadFromFile(adres+'shapes.dat');
 //Zn:=strtoint(tmp_f.ValueFromIndex[1]);
 for j:=0 to (nshapes)-1 do begin
  Combobox1.ItemIndex:=j;
  Combobox1.Items.Add(tmp_f.Strings[j+2]);
  Combobox2.ItemIndex:=j;
  Combobox2.Items.Add(tmp_f.Strings[j+2]);
 end;
 tmp_f.Free;

 s:=0;
 if PFi[s].NFi=0 then begin
  Label1.Caption:='Розмір F'+inttostr(s+1);
  Combobox1.ItemIndex:=-1;
  Combobox2.ItemIndex:=-1;
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;
  Edit4.Clear;
  Edit5.Clear;
  Edit5.Enabled:=false;
  UpDown1.Enabled:=false;
  Checkbox1.Checked:=false;
  CheckBox1Click(Sender);
  Radiogroup1.ItemIndex:=-1;
  Radiobutton1.Checked:=false;
  Radiobutton2.Checked:=false;
  Radiobutton3.Checked:=false;
  Radiobutton7.Checked:=false;
  Radiobutton8.Checked:=false;
  Radiobutton9.Checked:=false;
  Radiobutton10.Checked:=false;
end else begin
  Label1.Caption:='Розмір F'+inttostr(PFi[s].NFi);
  Combobox1.ItemIndex:=PFi[s].N1List;
  Combobox2.ItemIndex:=PFi[s].N2List;
  Edit1.Text:=floattostr(PFi[s].Wek);
  Edit2.Text:=floattostr(PFi[s].Eb);
  if (PFi[s].AvtoEb=-1) then begin
    Checkbox1.Checked:=false;
    CheckBox1Click(Sender);
  end else begin
    Checkbox1.Checked:=true;
    CheckBox1Click(Sender);
  end;
  Edit3.Text:=floattostr(PFi[s].Rvb);
  Radiogroup1.ItemIndex:=PFi[s].Kind;
  case PFi[s].IT of
    14: Edit4.Text:='IT 14 - 10';
     9: Edit4.Text:='IT 9 - 7';
     6: Edit4.Text:='IT 6 - 5';
  end;
  if PFi[s].Koef=0 then begin
      Radiobutton1.Checked:=false;
      Radiobutton2.Checked:=false;
      Radiobutton3.Checked:=false;
  end;
  if PFi[s].Koef=1 then begin
      Radiobutton1.Checked:=true;
      Radiobutton2.Checked:=false;
      Radiobutton3.Checked:=false;
      Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK1.wmf');
  end;
  if PFi[s].Koef=2 then begin
      Radiobutton1.Checked:=false;
      Radiobutton2.Checked:=true;
      Radiobutton3.Checked:=false;
      Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK2.wmf');
  end;
  if (PFi[s].Koef>1) and (PFi[s].Koef<2) then begin
      Radiobutton1.Checked:=false;
      Radiobutton2.Checked:=false;
      Radiobutton3.Checked:=true;
      Edit5.Text:=floattostr(PFi[s].Koef);
      Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK1-2.wmf');
  end;
  case PFi[s].Typ1 of
    0:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=false;
      end;
    1:begin
      Radiobutton7.Checked:=true;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=false;
      end;
    2:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=true;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=false;
      end;
    3:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=true;
      Radiobutton10.Checked:=false;
      end;
    4:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=true;
      end;
  end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.BitBtn2Click(Sender: TObject);
begin
  Form9.Visible:=false;
  Form7.Close;
  Form8.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Fi_Close;
var s:integer;
begin
 for s:=0 to NFi-1 do begin
  if PFi[s].Rvb<>0 then PFi[s].dRvb:=(PFi[s].Koef*PFi[s].Rvb)-(0.6*PFi[s].Wek);
  if PFi[s].Rvb<0 then PFi[s].dRvb:=0;
  {if PFi[s].Eb<>-1 then }
  PFi[s].W:=PFi[s].Wek+PFi[s].Eb+PFi[s].dRvb;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.BitBtn1Click(Sender: TObject);
var s,t:integer;
begin
 t:=0;
 for s:=0 to NFi-1 do begin
   if (PFi[s].N1List=-1) or (PFi[s].N2List=-1) then begin
    t:=1;
    break;
   end;
 end;
 if t=1 then begin
  Tabcontrol1.TabIndex:=s;
  TabControl1Change(Sender);
  ShowMessage('Недостатньо даних для розрахунку!!!'+#13#10+
              'Введіть розмірні зв''язки.');
 end else
///////////////////////////захист від дурня/////////////////////////////////////

    for s:=0 to NFi-1 do begin

    if (PFi[s].Typ1=0) then
        begin
          t:=2;
          break;
       end;
    end;

     if t=2 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Оберіть тип розміру');
     end
      else
///////////////////////////захист від дурня/////////////////////////////////////
       for s:=0 to NFi-1 do begin

    if (Edit5.Text=' ') then
        begin
          t:=3;
          break;
       end;
    end;

     if t=3 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Введіть інформацію про розташування бази.');
     end
      else

///////////////////////////захист від дурня/////////////////////////////////////
     for s:=0 to NFi-1 do begin

    if (Edit1.Text=' ') then
        begin
          t:=4;
          break;
       end;
    end;

     if t=4 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Введіть значення величини поля розсіювання.');
     end
      else

///////////////////////////захист від дурня/////////////////////////////////////
     for s:=0 to NFi-1 do begin

    if (Edit2.Text=' ') and (Checkbox1.Checked=false) then
        begin
          t:=5;
          break;
       end;
    end;

     if t=5 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Введіть значення величини похибки базування.');
     end
      else

///////////////////////////захист від дурня/////////////////////////////////////
    for s:=0 to NFi-1 do begin

    if (Edit3.Text=' ') then
        begin
          t:=6;
          break;
       end;
    end;

     if t=6 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Введіть значення величини просторового'+#13#10+
                     'відхилення вимірювальної бази.');
     end
      else

///////////////////////////захист від дурня/////////////////////////////////////

    for s:=0 to NFi-1 do begin

    if (PFi[s].Kind=-1) then
        begin
          t:=7;
          break;
       end;
    end;

     if t=7 then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Оберіть вид розміру');
     end
      else
///////////////////////////захист від дурня/////////////////////////////////////

    for s:=0 to NFi-1 do begin

    if (PFi[s].IT=0) then
        begin
          t:=8;
          break;
       end;
    end;

     if t=8
     then begin

      Tabcontrol1.TabIndex:=s;
      TabControl1Change(Sender);
      ShowMessage('Оберіть точність розміру');
     end;
///////////////////////////захист від дурня/////////////////////////////////////

 if (t=0) then
  begin
  Fi_Close;
  if MainUnit.Fi_rw=true then begin
   Fi_rw:=false;
   Form9.Visible:=false;
   Form7.Close;
   UnitTB.Form11.BitBtn1.Click;
   MainUnit.Rw:=true;
  end else begin
   Form9.Visible:=false;
   Form7.Close;
   Form14.Show;
  end;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.TabControl1Change(Sender: TObject);
var
  s:integer;
begin
Form7.Visible:=false;
s:=Tabcontrol1.TabIndex;
if PFi[s].NFi=0 then begin
  Label1.Caption:='Розмір F'+inttostr(s+1);
  Combobox1.ItemIndex:=-1;
  Combobox2.ItemIndex:=-1;
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;
  Edit4.Clear;
  Edit5.Clear;
  Edit5.Enabled:=false;
  UpDown1.Enabled:=false;
  Checkbox1.Checked:=false;
  CheckBox1Click(Sender);
  Radiogroup1.ItemIndex:=-1;
  Radiobutton1.Checked:=false;
  Radiobutton2.Checked:=false;
  Radiobutton3.Checked:=false;
  Radiobutton7.Checked:=false;
  Radiobutton8.Checked:=false;
  Radiobutton9.Checked:=false;
  Radiobutton10.Checked:=false;
end else begin
  Label1.Caption:='Розмір F'+inttostr(PFi[s].NFi);
  Combobox1.ItemIndex:=PFi[s].N1List;
  Combobox2.ItemIndex:=PFi[s].N2List;
  Edit1.Text:=floattostr(PFi[s].Wek);
  Edit2.Text:=floattostr(PFi[s].Eb);
  if (PFi[s].AvtoEb=-1) then begin
    Checkbox1.Checked:=false;
    CheckBox1Click(Sender);
   end else begin
    Checkbox1.Checked:=true;
    CheckBox1Click(Sender);
  end;
  Edit3.Text:=floattostr(PFi[s].Rvb);
  Radiogroup1.ItemIndex:=PFi[s].Kind;
  case PFi[s].IT of
    14: Edit4.Text:='IT 14 - 10';
     9: Edit4.Text:='IT 9 - 7';
     6: Edit4.Text:='IT 6 - 5';
  end;
  if (Edit4.Text='IT 14 - 10') then PFi[s].IT:=14;
  if (Edit4.Text='IT 9 - 7') then PFi[s].IT:=9;
  if (Edit4.Text='IT 6 - 5') then PFi[s].IT:=6;
  if PFi[s].Koef=0 then begin
      Radiobutton1.Checked:=false;
      Radiobutton2.Checked:=false;
      Radiobutton3.Checked:=false;
  end;
  if PFi[s].Koef=1 then begin
      Radiobutton1.Checked:=true;
      Radiobutton2.Checked:=false;
      Radiobutton3.Checked:=false;
      Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK1.wmf');
  end;
  if PFi[s].Koef=2 then begin
      Radiobutton1.Checked:=false;
      Radiobutton2.Checked:=true;
      Radiobutton3.Checked:=false;
      Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK2.wmf');
  end;
  if (PFi[s].Koef>1) and (PFi[s].Koef<2) then begin
      Radiobutton1.Checked:=false;
      Radiobutton2.Checked:=false;
      Radiobutton3.Checked:=true;
      Edit5.Text:=floattostr(PFi[s].Koef);
      Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK1-2.wmf');
  end;
  case PFi[s].Typ1 of
    0:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=false;
      end;
    1:begin
      Radiobutton7.Checked:=true;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=false;
      end;
    2:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=true;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=false;
      end;
    3:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=true;
      Radiobutton10.Checked:=false;
      end;
    4:begin
      Radiobutton7.Checked:=false;
      Radiobutton8.Checked:=false;
      Radiobutton9.Checked:=false;
      Radiobutton10.Checked:=true;
      end;
  end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Button5Click(Sender: TObject);
var s:integer;
begin
if z_=1 then begin
Form9.Height:=677;
z_:=0;
SpeedButton5.Visible:=true;
Button5.Caption:='Додатково <<';
end else begin
Form9.Height:=420;
z_:=1;
SpeedButton5.Visible:=false;
Button5.Caption:='Додатково >>';
end;
{----->>>> Інфо масиву - технологічні розміри}
Stringgrid1.ColCount:=NFi+1;
Stringgrid1.RowCount:=12;
Stringgrid1.Cells[0,0]:='Позначення розм.';
Stringgrid1.Cells[0,1]:='№ пов.1 у списку';
Stringgrid1.Cells[0,2]:='№ пов.1';
Stringgrid1.Cells[0,3]:='№ пов.2 у списку';
Stringgrid1.Cells[0,4]:='№ пов.2';
Stringgrid1.Cells[0,5]:='Wек';
Stringgrid1.Cells[0,6]:='Eб';
Stringgrid1.Cells[0,7]:='Rвб';
Stringgrid1.Cells[0,8]:='Спосіб установки';
Stringgrid1.Cells[0,9]:='Точність розм.';
Stringgrid1.Cells[0,10]:='Вид розм.';
Stringgrid1.Cells[0,11]:='Забезпечується';
for s:=1 to NFi do begin
Stringgrid1.Cells[s,0]:='F'+inttostr(PFi[s-1].NFi);
Stringgrid1.Cells[s,1]:=inttostr(PFi[s-1].N1List);
Stringgrid1.Cells[s,2]:=PFi[s-1].N1;
Stringgrid1.Cells[s,3]:=inttostr(PFi[s-1].N2List);
Stringgrid1.Cells[s,4]:=PFi[s-1].N2;
Stringgrid1.Cells[s,5]:=floattostr(PFi[s-1].Wek);
if PFi[s-1].Eb=-1 then Stringgrid1.Cells[s,6]:='авто. розрах'
else Stringgrid1.Cells[s,6]:=floattostr(PFi[s-1].Eb);
Stringgrid1.Cells[s,7]:=floattostr(PFi[s-1].Rvb);
Stringgrid1.Cells[s,8]:=floattostr(PFi[s-1].Koef);
 case PFi[s-1].IT of
    14:Stringgrid1.Cells[s,9]:='IT 14 - 10';
     9:Stringgrid1.Cells[s,9]:='IT 9 - 7';
     6:Stringgrid1.Cells[s,9]:='IT 6 - 5';
     0:Stringgrid1.Cells[s,9]:='';
 end;
 case PFi[s-1].Kind of
  -1:Stringgrid1.Cells[s,10]:='';
   0:Stringgrid1.Cells[s,10]:='Охоплюємий';
   1:Stringgrid1.Cells[s,10]:='Охоплюючий';
   2:Stringgrid1.Cells[s,10]:='Інший';
 end;
 case PFi[s-1].Typ1 of
  0:Stringgrid1.Cells[s,11]:='';
  1:Stringgrid1.Cells[s,11]:='ТОС';
  2:Stringgrid1.Cells[s,11]:='інструментом';
  3:Stringgrid1.Cells[s,11]:='набором інструментів, копіром або УП';
  4:Stringgrid1.Cells[s,11]:='верстатним пристроєм';
 end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.ComboBox1Change(Sender: TObject);
var s,i:integer;
begin
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=Tabcontrol1.TabIndex+1;
i:=Combobox1.ItemIndex;
PFi[s].N1List:=i;
PFi[s].N1:=Combobox1.Text;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.ComboBox2Change(Sender: TObject);
var s,i:integer;
begin
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=Tabcontrol1.TabIndex+1;
i:=Combobox2.ItemIndex;
PFi[s].N2List:=i;
PFi[s].N2:=Combobox2.Text;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit1Exit(Sender: TObject);
var s:integer;
begin
 s:=Tabcontrol1.TabIndex;
 PFi[s].NFi:=s+1;
 if (Edit1.Text)<>'' then
 PFi[s].Wek:=strtofloat(Edit1.Text);
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
case Key of
 #8,'0'..'9' : ; // цифры и <Backspace>
 #13: // клавиша <Enter>
     Edit1Exit(Sender);
 '.',',': // разделитель целой и дробной частей числа
         begin
          if Key <> DecimalSeparator then
           Key := DecimalSeparator; // заменим разделитель на допустимый
          if Pos(Edit1.Text,DecimalSeparator) <> 0 then
           Key := Chr(0); // запрет ввода второго разделителя
          end
  else // остальные символы запрещены
   key := Chr(0);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit2Exit(Sender: TObject);
var s:integer;
begin
 s:=Tabcontrol1.TabIndex;
 PFi[s].NFi:=s+1;
 if (Edit2.Text)<>'' then
 PFi[s].Eb:=strtofloat(Edit2.Text);
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
case Key of
 #8,'0'..'9' : ; // цифры и <Backspace>
 #13: // клавиша <Enter>
     Edit2Exit(Sender);
 '.',',': // разделитель целой и дробной частей числа
         begin
          if Key <> DecimalSeparator then
           Key := DecimalSeparator; // заменим разделитель на допустимый
          if Pos(Edit2.Text,DecimalSeparator) <> 0 then
           Key := Chr(0); // запрет ввода второго разделителя
          end
  else // остальные символы запрещены
   key := Chr(0);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit3Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
if (Edit3.Text)<>'' then
PFi[s].Rvb:=strtofloat(Edit3.Text);
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
case Key of
 #8,'0'..'9' : ; // цифры и <Backspace>
 #13: // клавиша <Enter>
     Edit3Exit(Sender);
 '.',',': // разделитель целой и дробной частей числа
         begin
          if Key <> DecimalSeparator then
           Key := DecimalSeparator; // заменим разделитель на допустимый
          if Pos(Edit3.Text,DecimalSeparator) <> 0 then
           Key := Chr(0); // запрет ввода второго разделителя
          end
  else // остальные символы запрещены
   key := Chr(0);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit4Change(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
if (Edit4.Text)<>'' then
if (Edit4.Text='IT 14 - 10') then PFi[s].IT:=14;
if (Edit4.Text='IT 9 - 7') then PFi[s].IT:=9;
if (Edit4.Text='IT 6 - 5') then PFi[s].IT:=6;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit5Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
if (Edit5.Text<>'') then
PFi[s].Koef:=strtofloat(Edit5.Text);
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
case Key of
 #8,'0'..'9' : ; // цифры и <Backspace>
 #13: // клавиша <Enter>
     Edit5Exit(Sender);
 '.',',': // разделитель целой и дробной частей числа
         begin
          if Key <> DecimalSeparator then
           Key := DecimalSeparator; // заменим разделитель на допустимый
          if Pos(Edit5.Text,DecimalSeparator) <> 0 then
           Key := Chr(0); // запрет ввода второго разделителя
          end
  else // остальные символы запрещены
   key := Chr(0);
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton7MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var p:TPoint;
begin
//Delay(2000);
GetCursorPos(p);
Form7.Left:=p.X+10;
Form7.Top:=p.Y+10;
Form7.Visible:=true;
Form7.Image6.Picture.Metafile.LoadFromFile(str+'img\fi(01).wmf');
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton7Click(Sender: TObject);
var s:integer;
begin
Form7.Visible:=false;
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
PFi[s].Typ1:=1;
Label3.Enabled:=true;
Label8.Enabled:=true;
Checkbox1.Enabled:=true;
Edit2.Enabled:=true;
Edit3.Enabled:=true;
Speedbutton2.Enabled:=true;
Speedbutton3.Enabled:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton8MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var p:TPoint;
begin
GetCursorPos(p);
Form7.Left:=p.X+10;
Form7.Top:=p.Y+10;
Form7.Visible:=true;
Form7.Image6.Picture.Metafile.LoadFromFile(str+'img\fi(02).wmf');
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton8Click(Sender: TObject);
var s:integer;
begin
Form7.Visible:=false;
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
PFi[s].Typ1:=2;
Label3.Enabled:=false;
Label8.Enabled:=false;
Checkbox1.Enabled:=false;
Edit2.Enabled:=false;
Edit3.Enabled:=false;
Speedbutton2.Enabled:=false;
Speedbutton3.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton9MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var p:TPoint;
begin
GetCursorPos(p);
Form7.Left:=p.X+10;
Form7.Top:=p.Y+10;
Form7.Width:=300;
Form7.Visible:=true;
Form7.Image6.Picture.Metafile.LoadFromFile(str+'img\fi(03).wmf');
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton9Click(Sender: TObject);
var s:integer;
begin
Form7.Visible:=false;
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
PFi[s].Typ1:=3;
Label3.Enabled:=false;
Label8.Enabled:=false;
Checkbox1.Enabled:=false;
Edit2.Enabled:=false;
Edit3.Enabled:=false;
Speedbutton2.Enabled:=false;
Speedbutton3.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton10MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var p:TPoint;
begin
GetCursorPos(p);
Form7.Left:=p.X+10;
Form7.Top:=p.Y+10;
Form7.Visible:=true;
Form7.Image6.Picture.Metafile.LoadFromFile(str+'img\fi(04).wmf');
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton10Click(Sender: TObject);
var s:integer;
begin
Form7.Visible:=false;
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
PFi[s].Typ1:=4;
Label3.Enabled:=false;
Label8.Enabled:=false;
Checkbox1.Enabled:=false;
Edit2.Enabled:=false;
Edit3.Enabled:=false;
Speedbutton2.Enabled:=false;
Speedbutton3.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.GroupBox5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
Form7.Visible:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.IT14101Click(Sender: TObject);
begin
Edit4.Text:='IT 14 - 10';
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.IT971Click(Sender: TObject);
begin
Edit4.Text:='IT 9 - 7';
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.IT651Click(Sender: TObject);
begin
Edit4.Text:='IT 6 - 5';
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.CheckBox1Click(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
if Checkbox1.Checked=true then begin
  Label3.Enabled:=false;
  Edit2.Text:='';
  Edit2.Enabled:=false;
  Speedbutton2.Enabled:=false;
  PFi[s].AvtoEb:=1;      // було PFi[s].Eb:=-1;
end else begin
  Label3.Enabled:=true;
  Edit2.Enabled:=true;
  Speedbutton2.Enabled:=true;
  //if PFi[s].Eb=-1 then PFi[s].Eb:=0;
   Edit2.Text:=floattostr(PFi[s].Eb);
   PFi[s].AvtoEb:=-1;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.SpeedButton1Click(Sender: TObject);
begin
fmWek.Show;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton1Click(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
Radiobutton1.Checked:=true;
Radiobutton2.Checked:=false;
Edit5.Text:='1';
if PFi[s].Koef<>1 then PFi[s].Koef:=1;
Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK1.wmf');
Edit5.Enabled:=false;
UpDown1.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton2Click(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
Radiobutton1.Checked:=false;
Radiobutton2.Checked:=true;
Edit5.Text:='2';
if PFi[s].Koef<>2 then PFi[s].Koef:=2;
Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK2.wmf');
Edit5.Enabled:=false;
UpDown1.Enabled:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioButton3Click(Sender: TObject);
begin
Edit5.Enabled:=true;
UpDown1.Enabled:=true;
Image1.Picture.Metafile.LoadFromFile(str+'img\UstanovK1-2.wmf');
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var t:real; s:integer;
begin
if (Edit5.Text<>'') then
t:=strtofloat(Edit5.Text);
if t=1 then UpDown1.Position:=101;
if t=2 then UpDown1.Position:=199;
Edit5.Text:=FloatToStr(UpDown1.Position/100);
s:=Tabcontrol1.TabIndex;
PFi[s].Koef:=(UpDown1.Position)/100;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.SpeedButton3Click(Sender: TObject);
begin
fmRvb.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.SpeedButton2Click(Sender: TObject);
begin
fmBaza1.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.SpeedButton4Click(Sender: TObject);
var x1,y1:integer;
begin
x1:=Form9.Left+Speedbutton4.Left+Speedbutton4.Width-10;
y1:=Form9.Top+Speedbutton4.Top+Speedbutton4.Height+52;
Popupmenu1.Popup(x1,y1);
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.RadioGroup1Click(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PFi[s].NFi:=s+1;
PFi[s].Kind:=Radiogroup1.ItemIndex;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.SpeedButton5Click(Sender: TObject);
var s:integer;
begin
for s:=1 to NFi do begin
Stringgrid1.Cells[s,0]:='F'+inttostr(PFi[s-1].NFi);
Stringgrid1.Cells[s,1]:=inttostr(PFi[s-1].N1List);
Stringgrid1.Cells[s,2]:=PFi[s-1].N1;
Stringgrid1.Cells[s,3]:=inttostr(PFi[s-1].N2List);
Stringgrid1.Cells[s,4]:=PFi[s-1].N2;
Stringgrid1.Cells[s,5]:=floattostr(PFi[s-1].Wek);
if PFi[s-1].Eb=-1 then Stringgrid1.Cells[s,6]:='авто. розрах'
else Stringgrid1.Cells[s,6]:=floattostr(PFi[s-1].Eb);
Stringgrid1.Cells[s,7]:=floattostr(PFi[s-1].Rvb);
Stringgrid1.Cells[s,8]:=floattostr(PFi[s-1].Koef);
 case PFi[s-1].IT of
    14:Stringgrid1.Cells[s,9]:='IT 14 - 10';
     9:Stringgrid1.Cells[s,9]:='IT 9 - 7';
     6:Stringgrid1.Cells[s,9]:='IT 6 - 5';
     0:Stringgrid1.Cells[s,9]:='';
 end;
 case PFi[s-1].Kind of
  -1:Stringgrid1.Cells[s,10]:='';
   0:Stringgrid1.Cells[s,10]:='Охоплюємий';
   1:Stringgrid1.Cells[s,10]:='Охоплюючий';
   2:Stringgrid1.Cells[s,10]:='Інший';
 end;
 case PFi[s-1].Typ1 of
  0:Stringgrid1.Cells[s,11]:='';
  1:Stringgrid1.Cells[s,11]:='ТОС';
  2:Stringgrid1.Cells[s,11]:='інструментом';
  3:Stringgrid1.Cells[s,11]:='набором інструментів, копіром або УП';
  4:Stringgrid1.Cells[s,11]:='верстатним пристроєм';
 end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.SpeedButton6Click(Sender: TObject);
begin
if MainUnit.Fi_rw=true then begin
  Fi_rw:=false;
  Form9.Visible:=false;
  Form7.Close;
 end else begin
  Form9.Visible:=false;
  Form7.Close;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm9.TabControl1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
Form7.Visible:=false;
end;
{..............................................................................}
end.
