unit UnitZiSet01;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, Buttons, Unit_NewCalc,
  Unit_Otklon, ExtCtrls, Grids, DataUnit, SettingsUnit;

type
  TForm10 = class(TForm)
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
    Bevel3: TBevel;
    Edit2: TEdit;
    GroupBox6: TGroupBox;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Image4: TImage;
    Image5: TImage;
    Bevel6: TBevel;
    Label10: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    RadioGroup1: TRadioGroup;
    SpeedButton2: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioButton11Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure RadioButton12Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;
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
  NZi,                             //К-сть припусків
  Zn  : integer;                   //К-сть припусків
  z,z_ : integer;
  PAi: array of TAi;               //Масив властивостей конструкторських розм.
  PBi: array of TBi;               //Масив властивостей розм. заготовки
  PFi: array of TFi;               //Масив властивостей технологічних розм.
  PZi: array of TZi;               //Масив властивостей припусків
  POb: array of integer;

const
  Incl: array [0..9] of string =
  ('1','2','3','4','5','6','7','8','9','0');

implementation
uses UnitBiSet, UnitFiSet, UZmin, UnitTB, UnitPovParametrs, MainUnit;
{$R *.dfm}

procedure TForm10.FormShow(Sender: TObject);
var tmp_f:TStrings; i,j,a,b,s,t,zi,f,ls,nz:integer; n,p,p1,p2,str:string;
ZAG, TMP:array of string; inf:boolean;
Begin
Form10.Height:=420;
fmZmin.Visible:=false;
Groupbox6.Visible:=true;
Radiogroup1.Visible:=true;
z_:=1;
if SettingsUnit.Set1.Addings=true then Button5.Visible:=true
else Button5.Visible:=false;
Speedbutton2.Visible:=false;

str:=Application.ExeName;
ls:=length(Application.ExeName);
setlength(str,ls-15);
tmp_f:=TStringList.Create();
tmp_f.LoadFromFile(str+'data.ini');
NZag:=strtoint(tmp_f.ValueFromIndex[6]);
NDet:=strtoint(tmp_f.ValueFromIndex[7]);
NBi:=strtoint(tmp_f.ValueFromIndex[8]);
NAi:=strtoint(tmp_f.ValueFromIndex[9]);
tmp_f.Free;
tmp_f:=TStringList.Create();
tmp_f.LoadFromFile(str+'shapes.ini');
zn:=strtoint(tmp_f.ValueFromIndex[1]);
tmp_f.Free;
str:='';
ls:=0;
SetLength(POb,NDet);
for a:=0 to NDet do begin
POb[a]:=UnitPovParametrs.POb[a].Ob;
end;

{str:=Application.ExeName;
ls:=length(Application.ExeName);
setlength(str,ls-15);
str:='';
ls:=0; }

if MainUnit.counter<5 then begin             //0
 Tabcontrol1.Tabs.Clear;
{---------Визначення кількості припусків, якщо (пов. Заг)<(пов. Дет)---------}
 if (NZag<>NDet) then begin                 //01
  SetLength(TMP,NDet);
  for i:=0 to NBi-1 do begin                //011
   if (UnitBiSet.PBi[i].N1List<>-1) then
   TMP[UnitBiSet.PBi[i].N1List]:=UnitBiSet.PBi[i].N1;
   if (UnitBiSet.PBi[i].N2List<>-1) then
   TMP[UnitBiSet.PBi[i].N2List]:=UnitBiSet.PBi[i].N2;
  end;                                      //011
  SetLength(ZAG,NZag);
  nz:=0;                                    //012
  for i:=0 to NDet-1 do begin               //0121
   if TMP[i]<>'' then begin
    ZAG[nz]:=TMP[i];
    nz:=nz+1;
   end;                                     //0121
  end;                                      //012
  finalize(TMP);
  SetLength(PZi,0); //Задання масиву припусків
  s:=0;
  for a:=0 to NDet-1 do begin               //013
    for j:=0 to POb[a]-1 do begin           //0131
      inf:=false;
      if j=0 then begin                     //01311
       p1:=inttostr(a+1)+'.0';
       for i:=0 to NZag-1 do if p1=ZAG[i] then inf:=true;
      end                                   //01311
      else begin                            //01312
       p1:=inttostr(a+1)+'.'+inttostr(j);
       inf:=true;
      end;                                  //01312
      if ((POb[a]-(j+1))<>0) then p2:=inttostr(a+1)+'.'+inttostr(j+1)
      else p2:=inttostr(a+1)+'.'+inttostr(j+1)+'f';
      if inf=true then begin                //01313
       SetLength(PZi,s+1);
       n:='Z'+inttostr(a+1)+'.'+inttostr(j+1);
       Tabcontrol1.TabIndex:=s;
       Tabcontrol1.Tabs.Add(n);
       PZi[s].Name:=n;
       PZi[s].NZi:=s+1;
       PZi[s].N1:=p1;
       PZi[s].N2:=p2;
       PZi[s].Met:=0;
       PZi[s].Zmax:=0;
       PZi[s].Zmin:=0;
       PZi[s].Kind:=-1;
       PZi[s].W:=0;
       s:=s+1;
      end;                                   //01313
    end;                                    //0131
   end;                                    //013
   NZi:=length(PZi); MainUnit.NZi:=NZi;
   finalize(ZAG);
{---------Визначення кількості припусків, якщо (пов. Заг)<(пов. Дет)---------}
 end                                           //01
 else begin                                     //02
  SetLength(PZi,Zn); //Задання масиву припусків
  NZi:=Zn; MainUnit.NZi:=Zn;
  s:=0;
  for a:=0 to NDet-1 do
    for j:=0 to POb[a]-1 do begin
      n:='Z'+inttostr(a+1)+'.'+inttostr(j+1);
      Tabcontrol1.TabIndex:=s;
      Tabcontrol1.Tabs.Add(n);
      PZi[s].Name:=n;
      if j=0 then p1:=inttostr(a+1)+'.0'
      else p1:=inttostr(a+1)+'.'+inttostr(j);
      if ((POb[a]-(j+1))<>0) then p2:=inttostr(a+1)+'.'+inttostr(j+1)
      else p2:=inttostr(a+1)+'.'+inttostr(j+1)+'f';
      PZi[s].NZi:=s+1;
      PZi[s].N1:=p1;
      PZi[s].N2:=p2;
      PZi[s].Met:=0;
      PZi[s].Zmax:=0;
      PZi[s].Zmin:=0;
      PZi[s].Kind:=-1;
      PZi[s].W:=0;
      s:=s+1;
   end;
  end;                       //02
  MainUnit.counter:=5;
  Radiogroup1.Visible:=true;
  Groupbox6.Visible:=true;
  Speedbutton1.Visible:=true;
  Edit1.Clear;
  Edit2.Clear;
  s:=0;
  Label10.Caption:='Припуски';
  Label4.Caption:='Розмірні зв''язки:   ('+PZi[s].N1+' - '+PZi[s].N2+')';
  Tabcontrol1.TabIndex:=0;
  Label1.Caption:='Припуск Z1.1';
  Radiogroup1.ItemIndex:=0;
  RadioGroup1Click(Sender);
  Radiobutton11.Checked:=false;
  Radiobutton12.Checked:=false;
  Speedbutton2.Visible:=false;
 end                            //0
else begin                     //1
 Tabcontrol1.Tabs.Clear;
 Radiogroup1.Visible:=true;
 Groupbox6.Visible:=true;
 Speedbutton1.Visible:=true;
 if Length(PZi)=0 then begin     //11
  NZi:=MainUnit.NZi;
  SetLength(PZi,NZi); //Задання масиву припусків
  for s:=0 to NZi-1 do begin     //111
   PZi[s].NZi:=MainUnit.PZi[s].NZi;
   PZi[s].Name:=MainUnit.PZi[s].Name;
   PZi[s].Kind:=MainUnit.PZi[s].Kind;
   PZi[s].N1:=MainUnit.PZi[s].N1;
   PZi[s].N2:=MainUnit.PZi[s].N2;
   PZi[s].Met:=MainUnit.PZi[s].Met;
   PZi[s].Zmax:=MainUnit.PZi[s].Zmax;
   PZi[s].Zmin:=MainUnit.PZi[s].Zmin;
   PZi[s].Zm:=MainUnit.PZi[s].Zm;
   PZi[s].W:=MainUnit.PZi[s].W;
  end;                           //111
  finalize(MainUnit.PZi);
 end;                              //11
    for s:=0 to NZi-1 do begin    //12
      if PZi[s].Kind=1 then n:=PZi[s].Name+'*' else n:=PZi[s].Name;
      Tabcontrol1.TabIndex:=s;
      Tabcontrol1.Tabs.Add(n);
    end;                          //12
    s:=0;
    Label10.Caption:='Припуски';
    Label4.Caption:='Розмірні зв''язки:   ('+PZi[s].N1+' - '+PZi[s].N2+')';
    Tabcontrol1.TabIndex:=0;
    Radiogroup1.ItemIndex:=PZi[s].Met;
    RadioGroup1Click(Sender);
    if PZi[s].Zmin=0 then Edit1.Clear else Edit1.Text:=floattostr(PZi[s].Zmin);
    if (PZi[s].Zmax=0) or (PZi[s].Met=0) then Edit2.Clear
    else Edit2.Text:=floattostr(PZi[s].Zmax);
    case PZi[s].Kind of                   //13
      -1:begin                             //131
         Radiobutton11.Checked:=false;
         Radiobutton12.Checked:=false;
         Label1.Caption:='Припуск '+Tabcontrol1.Tabs.Strings[s];
         end;                              //131
       0:begin                             //132
         Radiobutton11.Checked:=true;
         Radiobutton12.Checked:=false;
         //Label1.Caption:='Припуск '+PZi[s].Name;
         end;                              //132
       1:begin                             //133
         Radiobutton11.Checked:=false;
         Radiobutton12.Checked:=true;
         //Label1.Caption:='Припуск '+PZi[s].Name+'*';
         end;                              //133
    end;                                  //13
 end;                                    //1
End;

procedure TForm10.BitBtn2Click(Sender: TObject);
begin
Form10.Visible:=false;
Form9.Visible:=true;
end;


procedure TForm10.BitBtn1Click(Sender: TObject);
begin
Form10.Visible:=false;
Form11.Show;
//Form11.Visible:=true;
end;

procedure TForm10.TabControl1Change(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
Label4.Caption:='Розмірні зв''язки:   ('+PZi[s].N1+' - '+PZi[s].N2+')';
Radiogroup1.ItemIndex:=PZi[s].Met;
RadioGroup1Click(Sender);
if (PZi[s].Zmin=0) then Edit1.Clear else Edit1.Text:=floattostr(PZi[s].Zmin);
if (PZi[s].Zmax=0) or (PZi[s].Met=0) then Edit2.Clear
else Edit2.Text:=floattostr(PZi[s].Zmax);
case PZi[s].Kind of
  -1:begin
     Radiobutton11.Checked:=false;
     Radiobutton12.Checked:=false;
     Label1.Caption:='Припуск '+Tabcontrol1.Tabs.Strings[s];
     end;
   0:begin
     Radiobutton11.Checked:=true;
     Radiobutton12.Checked:=false;
     Label1.Caption:='Припуск '+PZi[s].Name;
     end;
   1:begin
     Radiobutton11.Checked:=false;
     Radiobutton12.Checked:=true;
     Label1.Caption:='Припуск '+PZi[s].Name+'*';
     end;
end;
end;

procedure TForm10.Button5Click(Sender: TObject);
var s:integer;
begin
if z_=1 then begin
Form10.Height:=677;
Speedbutton2.Visible:=true;
z_:=0;
Button5.Caption:='Додатково <<';
end else begin
Form10.Height:=420;
Speedbutton2.Visible:=false;
z_:=1;
Button5.Caption:='Додатково >>';
end;
{----->>>> Інфо масиву - припуски}
Stringgrid1.ColCount:=Zn+1;
Stringgrid1.RowCount:=5;
Stringgrid1.Cells[0,0]:='Позначення розм.';
Stringgrid1.Cells[0,1]:='Розмірні зв''язки';
Stringgrid1.Cells[0,2]:='Zmin';
Stringgrid1.Cells[0,3]:='Zmax';
Stringgrid1.Cells[0,4]:='Тип припуску';
for s:=1 to NZi do begin
case PZi[s-1].Kind of
  -1:Stringgrid1.Cells[s,0]:=PZi[s-1].Name;
   0:Stringgrid1.Cells[s,0]:=PZi[s-1].Name;
   1:Stringgrid1.Cells[s,0]:=PZi[s-1].Name+'*';
end;
Stringgrid1.Cells[s,1]:='('+PZi[s-1].N1+' - '+PZi[s-1].N2+')';
Stringgrid1.Cells[s,2]:=floattostr(PZi[s-1].Zmin);
Stringgrid1.Cells[s,3]:=floattostr(PZi[s-1].Zmax);
case PZi[s-1].Kind of
  -1:Stringgrid1.Cells[s,4]:='не задан';
   0:Stringgrid1.Cells[s,4]:='прямий';
   1:Stringgrid1.Cells[s,4]:='зворотний (*)';
end;
end;
end;

procedure TForm10.RadioGroup1Click(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
PZi[s].Met:=Radiogroup1.ItemIndex;
case Radiogroup1.ItemIndex of
  0:begin
    Label3.Enabled:=false;
    Edit2.Enabled:=false;
    end;
  1:begin
    Label3.Enabled:=true;
    Edit2.Enabled:=true;
    end;
end;
end;

procedure TForm10.RadioButton11Click(Sender: TObject);
var s:integer; temp:string;
begin
Radiobutton11.Checked:=true;
Radiobutton12.Checked:=false;
s:=Tabcontrol1.TabIndex;
if (PZi[s].Kind=1) then begin
temp:=PZi[s].N1;
PZi[s].N1:=PZi[s].N2;
PZi[s].N2:=temp;
Label4.Caption:='Розмірні зв''язки:   ('+PZi[s].N1+' - '+PZi[s].N2+')';
end;
PZi[s].Kind:=0;
Label1.Caption:='Припуск '+PZi[s].Name;
Tabcontrol1.Tabs.Strings[s]:=PZi[s].Name;
end;

procedure TForm10.Image4Click(Sender: TObject);
begin
RadioButton11Click(Sender);
end;

procedure TForm10.RadioButton12Click(Sender: TObject);
var s:integer; temp:string;
begin
Radiobutton11.Checked:=false;
Radiobutton12.Checked:=true;
s:=Tabcontrol1.TabIndex;
if (PZi[s].Kind=0) or (PZi[s].Kind=-1) then begin
temp:=PZi[s].N1;
PZi[s].N1:=PZi[s].N2;
PZi[s].N2:=temp;
Label4.Caption:='Розмірні зв''язки:   ('+PZi[s].N1+' - '+PZi[s].N2+')';
end;
PZi[s].Kind:=1;
Label1.Caption:='Припуск '+PZi[s].Name+'*';
Tabcontrol1.Tabs.Strings[s]:=PZi[s].Name+'*';
end;

procedure TForm10.Image5Click(Sender: TObject);
begin
RadioButton12Click(Sender);
end;

procedure TForm10.SpeedButton2Click(Sender: TObject);
var s:integer;
begin
for s:=1 to NZi do begin
case PZi[s-1].Kind of
  -1:Stringgrid1.Cells[s,0]:=PZi[s-1].Name;
   0:Stringgrid1.Cells[s,0]:=PZi[s-1].Name;
   1:Stringgrid1.Cells[s,0]:=PZi[s-1].Name+'*';
end;
Stringgrid1.Cells[s,1]:='('+PZi[s-1].N1+' - '+PZi[s-1].N2+')';
Stringgrid1.Cells[s,2]:=floattostr(PZi[s-1].Zmin);
Stringgrid1.Cells[s,3]:=floattostr(PZi[s-1].Zmax);
case PZi[s-1].Kind of
  -1:Stringgrid1.Cells[s,4]:='не задан';
   0:Stringgrid1.Cells[s,4]:='прямий';
   1:Stringgrid1.Cells[s,4]:='зворотний (*)';
end;
end;
end;

procedure TForm10.SpeedButton1Click(Sender: TObject);
begin
fmZmin.Visible:=true;
end;

procedure TForm10.Edit1Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
if (Edit1.Text)<>'' then
PZi[s].Zmin:=strtofloat(Edit1.Text);
end;

procedure TForm10.Edit1KeyPress(Sender: TObject; var Key: Char);
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

procedure TForm10.Edit2Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
if (Edit2.Text)<>'' then
PZi[s].Zmax:=strtofloat(Edit2.Text);
end;

procedure TForm10.Edit2KeyPress(Sender: TObject; var Key: Char);
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

end.
