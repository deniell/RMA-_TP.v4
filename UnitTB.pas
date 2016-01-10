unit UnitTB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, DataUnit, CheckLst;

type
  TForm11 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabControl1: TTabControl;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Bevel1: TBevel;
    CheckListBox1: TCheckListBox;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure TB_Show;
    procedure TB_Close;
    procedure CheckListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  str: string;
  Form11: TForm11;
  NOp,                             //К-сть операцій ТП
  NZag,                            //К-сть поверхонь заготовки
  NDet,                            //К-сть поверхонь деталі
  Zn, nshapes  : integer;                   //К-сть припусків
  adres: String; //для адреса, откуда запущена программа
  Ch : array [0..999] of integer;  //К-сть обробок і-ої поверхні
  PTB: array of Ttb;               //Масив властивостей технологічних баз

implementation
uses MainUnit,
     Unit_NewCalc,
     UnitAiSet,
     UnitZiSet,
     UnitPovParametrs,
     UnitResults,
     UnitFiSet;
{$R *.dfm}
{..............................................................................}
procedure TForm11.TB_Show;
var
  s:integer;
begin
  NZag:=Unit_NewCalc.NZag;
  NDet:=Unit_NewCalc.NDet;
  NOp:=Unit_NewCalc.NOp;
  if MainUnit.counter<6 then
  begin
    SetLength(PTB,NOp);     //Задання масиву ТБ
    for s:=0 to NOp-1 do
    begin
      PTB[s].NOper:=-1;
      PTB[s].NameOper:='';
      PTB[s].pOX:=-1;
      PTB[s].OX:='';
    end;
  MainUnit.counter:=6;
  end
  else
  begin   //if counter=6
    if Length(PTB)=0 then
    begin
      SetLength(PTB,NOp);     //Задання масиву ТБ
      for s:=0 to NOp-1 do
      begin
        PTB[s].NOper:=MainUnit.PTB[s].NOper;
        PTB[s].NameOper:=MainUnit.PTB[s].NameOper;
        PTB[s].pOX:=MainUnit.PTB[s].pOX;
        PTB[s].OX:=MainUnit.PTB[s].OX;
      end;
    Finalize(MainUnit.PTB);
  end;
end;

end;
{..............................................................................}

{..............................................................................}
procedure TForm11.FormShow(Sender: TObject);
var
  i,j,s :integer;
  n :string;
  tmp_f : TStrings;
begin
 if Mainunit.TB_rw=true then
 begin
    Bitbtn2.Caption:='Закрити';
    UnitAiSet.Form4.Im_dialog.GetBitmap(2,Bitbtn2.Glyph);
    Bitbtn1.Caption:=' Ок ';
    UnitAiSet.Form4.Im_dialog.GetBitmap(3,Bitbtn1.Glyph);
  end
  else
  begin
    Bitbtn2.Caption:='Назад';
    UnitAiSet.Form4.Im_dialog.GetBitmap(0,Bitbtn2.Glyph);
    Bitbtn1.Caption:='Завершити';
    UnitAiSet.Form4.Im_dialog.GetBitmap(4,Bitbtn1.Glyph);
end;
 ///////////////////////
 //str:=Application.ExeName;
// ls:=length(Application.ExeName);
// setlength(str,ls-15);
 adres := ExtractFilePath(Application.ExeName);
 tmp_f:=TStringList.Create();
 tmp_f.LoadFromFile(adres+'shapes.dat');
 nshapes:=strtoint(tmp_f.ValueFromIndex[0]);
 Zn:=strtoint(tmp_f.ValueFromIndex[1]);
 tmp_f.Free;

 //nshapes:=UnitFiSet.nshapes;
// Zn:=UnitFiSet.Zn;

 TB_Show;

 Tabcontrol1.Tabs.Clear;



 for i:=1 to NOp do begin
  if i=1 then n:='005' else n:='0'+inttostr(i*5);
  Tabcontrol1.Tabs.Add(n);
 end;
 Label3.Caption:='Операція 005';


 Combobox1.Visible:=true;
 Combobox1.Items.Clear;


// str:=Application.ExeName;
// ls:=length(Application.ExeName);
// setlength(str,ls-15);
 tmp_f:=TStringList.Create();
 tmp_f.LoadFromFile(adres+'shapes.dat');
  for j:=0 to (nshapes)-1 do begin
  Combobox1.ItemIndex:=j;
  Combobox1.Items.Add(tmp_f.Strings[j+2]);
 end;
 tmp_f.Free;

    {str:=Application.ExeName;
    ls:=length(Application.ExeName);
    setlength(str,ls-15);

    tmp_f:=TStringList.Create();
    tmp_f.LoadFromFile(str+'shapes.dat');
    Zn:=strtoint(tmp_f.ValueFromIndex[1]);

    for j:=0 to (NDet+Zn)-1 do begin
      Combobox1.ItemIndex:=j;
      Combobox1.Items.Add(tmp_f.Strings[j+2]);
    end;
    tmp_f.Free;}

 s:=0;
 Combobox1.ItemIndex:=PTB[s].pOX;
 label2.Caption:='Оберіть технологічні розміри, які належать даній операції:';
 Checklistbox1.Items.Clear;
 for i:=0 to Length(UnitFiSet.PFi)-1 do begin
  Checklistbox1.Items.Add('F'+inttostr(i+1));
 end;
 for i:=0 to Length(UnitFiSet.PFi)-1 do
  if UnitFiSet.PFi[i].Oper=s+1 then Checklistbox1.Checked[i]:=true
  else Checklistbox1.Checked[i]:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm11.TabControl1Change(Sender: TObject);
var
  s,i:integer; n:string;
begin
  s:=Tabcontrol1.TabIndex;
  if (s+1)=1 then n:='005' else n:='0'+inttostr((s+1)*5);
  Label3.Caption:='Операція '+n;
  Combobox1.ItemIndex:=PTB[s].pOX;
  for i:=0 to Length(UnitFiSet.PFi)-1 do
  if UnitFiSet.PFi[i].Oper=s+1 then Checklistbox1.Checked[i]:=true
    else Checklistbox1.Checked[i]:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm11.CheckListBox1Click(Sender: TObject);
var
  i,s:integer;
begin
  s:=Tabcontrol1.TabIndex;
  for i:=0 to Length(UnitFiSet.PFi)-1 do
  begin
    if Checklistbox1.Checked[i]=true then
    begin
      UnitFiSet.PFi[i].Oper:=s+1;
    end;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm11.ComboBox1Change(Sender: TObject);
var
  s:integer; n:string;
begin
  s:=Tabcontrol1.TabIndex;
  if (s+1)=1 then n:='005' else n:='0'+inttostr((s+1)*5);
  PTB[s].NOper:=s+1;
  PTB[s].NameOper:=n;
  PTB[s].pOX:=Combobox1.ItemIndex;
  PTB[s].OX:=Combobox1.Text;
end;
{..............................................................................}

{..............................................................................}
procedure TForm11.TB_Close;
var x,s,n,k:integer;
    SumEb:real;
    baz:string;
begin

 for s:=0 to NFi-1 do begin
   x:=s;
  if (UnitFiSet.PFi[s].AvtoEb=1) then begin
   if (UnitFiSet.PFi[s].Typ1=1) then begin
     n:=(UnitFiSet.PFi[s].Oper)-1;
     baz:=PTB[n].OX;
    if (UnitFiSet.PFi[s].N1=baz) or (UnitFiSet.PFi[s].N2=baz) then
      UnitFiSet.PFi[s].Eb:=0
     else  begin
      k:=-1;
      SumEb:=0;

     repeat
      k:=k+1;

       if (UnitFiSet.PFi[k].NFi<>UnitFiSet.PFi[x].NFi) and
       (UnitFiSet.PFi[k].Oper=UnitFiSet.PFi[x].Oper) then begin
         if (UnitFiSet.PFi[k].N1=UnitFiSet.PFi[x].N1) or (UnitFiSet.PFi[k].N2=UnitFiSet.PFi[x].N2)
          or (UnitFiSet.PFi[k].N1=UnitFiSet.PFi[x].N2) or (UnitFiSet.PFi[k].N2=UnitFiSet.PFi[x].N1)
          then begin
           SumEb:=SumEb+UnitFiSet.PFi[k].W;
           x:=k;
           end;
       end;
      until (UnitFiSet.PFi[k].N1=baz) or (UnitFiSet.PFi[k].N2=baz) or (k=(NFi-1));
      if (k=(NFi-1)) and (UnitFiSet.PFi[k].N1<>baz) and (UnitFiSet.PFi[k].N2<>baz)
      then ShowMessage('Перевірте інформацію про розташування баз')
      else UnitFiSet.PFi[s].Eb:=SumEb;
    end;

   end else UnitFiSet.PFi[s].Eb:=0;
  end;

 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm11.BitBtn2Click(Sender: TObject);
begin
if MainUnit.TB_rw=true then
  begin
    TB_rw:=false;
    Form11.Visible:=false;
  end
  else
  begin
    Form11.Visible:=false;
    Form14.Visible:=true;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm11.BitBtn1Click(Sender: TObject);
begin
  TB_Close;
  if MainUnit.TB_rw=true then
  begin
    TB_rw:=false;
    Form11.Visible:=false;
    UnitTB.Form11.BitBtn1.Click;
    UnitResults.Form12.BitBtn1.Click;
    MainUnit.Rw:=true;
  end
  else
  begin
    Form11.Visible:=false;
    Form12.Show;
//  UnitResults.Form12.BitBtn1.Click;    // послен полной поинки програмы закоментировать данную строку!!!!!!
 end;
end;
{..............................................................................}
end.
