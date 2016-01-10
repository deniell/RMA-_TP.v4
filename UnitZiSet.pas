unit UnitZiSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, DataUnit, SettingsUnit;

type
  TForm14 = class(TForm)
    TabControl1: TTabControl;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    RadioGroup1: TRadioGroup;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    GroupBox6: TGroupBox;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Image4: TImage;
    Image5: TImage;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    Label4: TLabel;
    Label10: TLabel;
    Bevel6: TBevel;
    Bevel2: TBevel;
    SpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StringGrid1: TStringGrid;
    Button5: TButton;
    SpeedButton3: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure RadioButton11Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure RadioButton12Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Zi_Show;
    procedure Zi_Close;
    procedure SpeedButton3Click(Sender: TObject);
    function  AnsiPos(const Substr, S: string; FromPos: integer): Integer;
  private
    { Private declarations }
  public
 //DecimalSeparator: Char;
    { Public declarations }
  end;

var
  Form14: TForm14;
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
  adres: String; //для адреса, откуда запущена программа
  PZi: array of TZi;               //Масив властивостей припусків
  POb: array of integer;

implementation
uses UnitAiSet,
     UnitBiSet,
     UnitFiSet,
     UZmin,
     UnitTB,
     UnitPovParametrs,
     MainUnit;
{$R *.dfm}
{..............................................................................}
procedure TForm14.Zi_Show;
var
  tmp_f:TStrings;
  i,j,a,s,nz:integer;
  n,p1,p2:string;
  ZAG, TMP:array of string;
  inf:boolean;
begin
  z_:=1;
 // str:=Application.ExeName; //зчитування даних з попередніх етапів >begin
 // ls:=length(Application.ExeName);
 // setlength(str,ls-15);
 adres := ExtractFilePath(Application.ExeName);
  tmp_f:=TStringList.Create();
  tmp_f.LoadFromFile(adres+'data.dat');
  NZag:=strtoint(tmp_f.ValueFromIndex[6]);
  NDet:=strtoint(tmp_f.ValueFromIndex[7]);
  NBi:=strtoint(tmp_f.ValueFromIndex[8]);
  NAi:=strtoint(tmp_f.ValueFromIndex[9]);
  tmp_f.Free;
  tmp_f:=TStringList.Create();
  tmp_f.LoadFromFile(adres+'shapes.dat');
  zn:=strtoint(tmp_f.ValueFromIndex[1]);
  tmp_f.Free;
 // str:='';
                   //зчитування даних з попередніх етапів >end

  if MainUnit.counter<5 then
  begin             //0
    SetLength(POb,NDet+5);
    for a:=0 to NDet do
    begin
      POb[a]:=UnitPovParametrs.POb[a].Ob;
    end;
{---------Визначення кількості припусків, якщо (пов. Заг)<(пов. Дет)---------}
  if (NZag<>NDet) then
  begin                 //01
    SetLength(TMP,NDet+5);
    for i:=0 to NBi+4 do
      begin                //011
        if (UnitBiSet.PBi[i].N1List<>-1) then
            TMP[UnitBiSet.PBi[i].N1List]:=UnitBiSet.PBi[i].N1;
        if (UnitBiSet.PBi[i].N2List<>-1) then
            TMP[UnitBiSet.PBi[i].N2List]:=UnitBiSet.PBi[i].N2;
      end;                                      //011
    SetLength(ZAG,NZag+5);
    nz:=0;                                    //012
    for i:=0 to NDet-1 do
      begin               //0121
        if TMP[i]<>'' then
          begin
            ZAG[nz]:=TMP[i];
            nz:=nz+1;
          end;                                     //0121
      end;                                      //012
    finalize(TMP);
    SetLength(PZi,0); //Задання масиву припусків
    s:=0;
    for a:=0 to NDet-1 do
      begin               //013
        for j:=0 to POb[a]-1 do
          begin           //0131
            inf:=false;
            if j=0 then
            begin                     //01311
              p1:=inttostr(a+1)+'.0';
              for i:=0 to NZag+4 do
                  if p1=ZAG[i] then inf:=true;
            end                                   //01311
          else
          begin                            //01312
            p1:=inttostr(a+1)+'.'+inttostr(j);
            inf:=true;
          end;                                  //01312
        if ((POb[a]-(j+1))<>0) then
                 p2:=inttostr(a+1)+'.'+inttostr(j+1)
            else p2:=inttostr(a+1)+'.'+inttostr(j+1)+'f';
        if inf=true then
        begin                //01313
          SetLength(PZi,s+1);
          n:='Z'+inttostr(a+1)+'.'+inttostr(j+1);
          PZi[s].Name:=n;
          PZi[s].NZi:=s+1;
          PZi[s].N1:=p1;      //////
          PZi[s].N2:=p2;      //////
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
  SetLength(PZi,Zn+5); //Задання масиву припусків
  NZi:=Zn;
  MainUnit.NZi:=Zn;
  s:=0;
  for a:=0 to NDet-1 do
    for j:=0 to POb[a]-1 do begin
      n:='Z'+inttostr(a+1)+'.'+inttostr(j+1);
      Tabcontrol1.TabIndex:=s;
      Tabcontrol1.Tabs.Add(n);
      PZi[s].Name:=n;

      if j=0 then
        begin
          p1:=inttostr(a+1)+'.0'
        end
        else
        begin
          p1:=inttostr(a+1)+'.'+inttostr(j);
        end;

      if ((POb[a]-(j+1))<>0) then
        begin
          p2:=inttostr(a+1)+'.'+inttostr(j+1);
        end
        else
        begin
          p2:=inttostr(a+1)+'.'+inttostr(j+1)+'f';
        end;

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
 end                            //0
else begin                     //1
 if Length(PZi)=0 then begin     //11
  NZi:=MainUnit.NZi;
  SetLength(PZi,NZi+5); //Задання масиву припусків
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

 end;                                    //1
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.FormShow(Sender: TObject);
var s:integer; n:string;
Begin
Form14.Height:=420;
fmZmin.Visible:=false;
Groupbox6.Visible:=true;
Radiogroup1.Visible:=true;

if Mainunit.Zi_rw=true then begin
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
Speedbutton2.Visible:=false;

Zi_Show;

Tabcontrol1.Tabs.Clear;
Radiogroup1.Visible:=true;
Groupbox6.Visible:=true;
Speedbutton1.Visible:=true;
Label10.Caption:='Припуски';
 for s:=0 to NZi-1 do begin    //12
  if PZi[s].Kind=1 then n:=PZi[s].Name+'*' else n:=PZi[s].Name;
  Tabcontrol1.TabIndex:=s;
  Tabcontrol1.Tabs.Add(n);
 end;                          //12
 s:=0;
 Label4.Caption:='Розмірні зв''язки:   ('+PZi[s].N1+' - '+PZi[s].N2+')';
 Tabcontrol1.TabIndex:=s;
 Radiogroup1.ItemIndex:=PZi[s].Met;
 RadioGroup1Click(nil);
 if PZi[s].Zmin=0 then Edit1.Clear else Edit1.Text:=floattostr(PZi[s].Zmin);
 if PZi[s].Zmax=0 then Edit2.Clear else Edit2.Text:=floattostr(PZi[s].Zmax);
 case PZi[s].Kind of                   //13
  -1:begin                             //131
      Radiobutton11.Checked:=false;
      Radiobutton12.Checked:=false;
      Label1.Caption:='Припуск '+Tabcontrol1.Tabs.Strings[s];
     end;                              //131
   0:begin                             //132
      Radiobutton11.Checked:=true;
      Radiobutton12.Checked:=false;
     end;                              //132
   1:begin                             //133
      Radiobutton11.Checked:=false;
      Radiobutton12.Checked:=true;
     end;                              //133
 end;                                  //13
End;
{..............................................................................}

{..............................................................................}
procedure TForm14.BitBtn1Click(Sender: TObject);
begin
Zi_Close;
if MainUnit.Zi_rw=true then begin
   Zi_rw:=false;
   Form14.Visible:=false;
   UnitTB.Form11.BitBtn1.Click;
   MainUnit.Rw:=true;
  end else begin
   Form14.Visible:=false;
   Form11.Show;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.Zi_Close;
begin
if (Length(POb)>0) then finalize(POb);
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.BitBtn2Click(Sender: TObject);
begin
 Zi_Close;
 Form14.Visible:=false;
 Form9.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.Button5Click(Sender: TObject);
var s:integer;
begin
if z_=1 then begin
Form14.Height:=677;
Speedbutton2.Visible:=true;
z_:=0;
Button5.Caption:='Додатково <<';
end else begin
Form14.Height:=420;
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
   1:Stringgrid1.Cells[s,4]:='зворотній (*)';
end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.Edit1Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
if (Edit1.Text)<>'' then
PZi[s].Zmin:=strtofloat(Edit1.Text);
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.Edit1KeyPress(Sender: TObject; var Key: Char);
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
procedure TForm14.Edit2Exit(Sender: TObject);
var s:integer;
begin
s:=Tabcontrol1.TabIndex;
if (Edit2.Text)<>'' then
PZi[s].Zmax:=strtofloat(Edit2.Text);
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.Edit2KeyPress(Sender: TObject; var Key: Char);
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
procedure TForm14.RadioButton11Click(Sender: TObject);
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
{..............................................................................}

{..............................................................................}
procedure TForm14.RadioButton12Click(Sender: TObject);
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
{..............................................................................}

{..............................................................................}
procedure TForm14.Image5Click(Sender: TObject);
begin
RadioButton12Click(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.Image4Click(Sender: TObject);
begin
RadioButton11Click(Sender);
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.RadioGroup1Click(Sender: TObject);
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
{..............................................................................}

{..............................................................................}
procedure TForm14.SpeedButton1Click(Sender: TObject);
begin
fmZmin.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.SpeedButton2Click(Sender: TObject);
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
   1:Stringgrid1.Cells[s,4]:='зворотній (*)';
end;
end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.SpeedButton3Click(Sender: TObject);
begin
 Zi_Close;
 if MainUnit.Zi_rw=true then begin
  Zi_rw:=false;
  Form14.Visible:=false;
 end else Form14.Visible:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm14.TabControl1Change(Sender: TObject);
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
{..............................................................................}

{..............................................................................}
function TForm14.AnsiPos(const Substr, S: string; FromPos: integer): Integer;
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
