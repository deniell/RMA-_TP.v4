unit UnitPovParametrs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Grids, DataUnit;

type
  TForm5 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabControl1: TTabControl;
    Bevel1: TBevel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    SpeedButton2: TSpeedButton;
    Button5: TButton;
    StringGrid1: TStringGrid;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure ComboBox8Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Pov_Show;
    procedure Pov_Close;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  k,z_,zn, z_s,
  NOp,                             //К-сть операцій ТП
  NZag,                            //К-сть поверхонь заготовки
  NDet,                            //К-сть поверхонь деталі
  NBi,                             //К-сть розмірів заготовки
  NAi,                             //К-сть конструкторських розмірів
  NFi: integer;                    //К-сть технологічних розмірів
  POb: array of TCut;              //Масив властивостей поверхонь
  adres: String; //для адреса, откуда запущена программа

implementation
uses MainUnit,
     Unit_NewCalc,
     UnitAiSet,
     SettingsUnit;
{$R *.dfm}

{..............................................................................}
procedure TForm5.FormShow(Sender: TObject);
var
  s,i,j :integer; n:string; //лічильники
begin
    Form5.Height:=382;

    NDet:=Unit_NewCalc.NDet;
    NOp:=Unit_NewCalc.NOp;

    if SettingsUnit.Set1.Addings=true then Button5.Visible:=true
        else Button5.Visible:=false;
      {---------заповнюємо форму початково}

   if Unit_NewCalc.AddPovParam=1 then  // перевіряємо чи змінились кількісні показники в Unit_NewCalc і якщо змінились додємо вкладку
      begin

     Tabcontrol1.Tabs.Clear;

    Label4.Caption:='раз';
    i:=1;
    repeat              //створюєм вкладки і називаємо їх
        n:=inttostr(i)+'.9';
        Tabcontrol1.TabIndex:=(i-1);
        Tabcontrol1.Tabs.Add(n);
        i:=i+1;
    until i=(NDet+1);

     Combobox1.Items.Clear;
    Combobox2.Items.Clear;
    Combobox3.Items.Clear;
    Combobox4.Items.Clear;
    Combobox5.Items.Clear;
    Combobox6.Items.Clear;
    Combobox7.Items.Clear;
    Combobox8.Items.Clear;

    for j:=1 to NOp do  //заповнюємо комбобокси номерами операцій
       begin
           if j=1 then n:='005' else n:='0'+inttostr(j*5);
          Combobox1.Items.Add(n);
          Combobox2.Items.Add(n);
          Combobox3.Items.Add(n);
          Combobox4.Items.Add(n);
          Combobox5.Items.Add(n);
          Combobox6.Items.Add(n);
          Combobox7.Items.Add(n);
          Combobox8.Items.Add(n);
       end;
       Unit_NewCalc.AddPovParam:=0;
    end
   else begin  // працює коли завнтажуємо збережений файл і гортаємо назад від UnitAiSet до UnitPovParametrs - виконує заповнення форми.
       Tabcontrol1.Tabs.Clear;

    Label4.Caption:='раз';
    i:=1;
    repeat              //створюєм вкладки і називаємо їх
        n:=inttostr(i)+'.9';
        Tabcontrol1.TabIndex:=(i-1);
        Tabcontrol1.Tabs.Add(n);
        i:=i+1;
    until i=(NDet+1);

     Combobox1.Items.Clear;
    Combobox2.Items.Clear;
    Combobox3.Items.Clear;
    Combobox4.Items.Clear;
    Combobox5.Items.Clear;
    Combobox6.Items.Clear;
    Combobox7.Items.Clear;
    Combobox8.Items.Clear;

    for j:=1 to NOp do  //заповнюємо комбобокси номерами операцій
       begin
           if j=1 then n:='005' else n:='0'+inttostr(j*5);
          Combobox1.Items.Add(n);
          Combobox2.Items.Add(n);
          Combobox3.Items.Add(n);
          Combobox4.Items.Add(n);
          Combobox5.Items.Add(n);
          Combobox6.Items.Add(n);
          Combobox7.Items.Add(n);
          Combobox8.Items.Add(n);
       end;
       Unit_NewCalc.AddPovParam:=0;
      end;


    Pov_Show;
 Tabcontrol1.TabIndex:=0;
 TabControl1Change(Sender);

    if NDet>0 then if POb[0].Axis=true then //якщо поверхня вісь
         Label2.Caption:='Параметри осі 1a.9 деталі'
            else Label2.Caption:='Параметри поверхні 1.9 деталі';

{s:=0;
 if POb[s].Ob=0 then begin

  //  Tabcontrol1.Tabs.Clear;

  Edit1.Text:=inttostr(POb[0].Ob);
  ComboBox1.ItemIndex:=POb[0].Oper1;
  Combobox2.ItemIndex:=POb[0].Oper2;
  Combobox3.ItemIndex:=POb[0].Oper3;
  Combobox4.ItemIndex:=POb[0].Oper4;
  Combobox5.ItemIndex:=POb[0].Oper5;
  Combobox6.ItemIndex:=POb[0].Oper6;
  Combobox7.ItemIndex:=POb[0].Oper7;
  Combobox8.ItemIndex:=POb[0].Oper8;
  Checkbox1.Checked:=POb[0].Axis;

  end else begin
  Edit1.Text:=inttostr(POb[s].Ob);
  ComboBox1.ItemIndex:=POb[s].Oper1;
  Combobox2.ItemIndex:=POb[s].Oper2;
  Combobox3.ItemIndex:=POb[s].Oper3;
  Combobox4.ItemIndex:=POb[s].Oper4;
  Combobox5.ItemIndex:=POb[s].Oper5;
  Combobox6.ItemIndex:=POb[s].Oper6;
  Combobox7.ItemIndex:=POb[s].Oper7;
  Combobox8.ItemIndex:=POb[s].Oper8;
  Checkbox1.Checked:=POb[s].Axis;
 end;}

 Edit1Change(nil);
  z_:=1;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.Pov_Show;
var
  s:integer;      //лічильник
begin
 z_s:=1;          //не використовується
 NDet:=Unit_NewCalc.NDet;
    NOp:=Unit_NewCalc.NOp;


 if MainUnit.counter<1 then
  begin
    SetLength(POb,NDet+5); //Задання масиву поверхонь    {+5 запасних елементів масиву,}
    for s:=0 to NDet+4 do     {якщо користувач захоче додати кілька нових поверхонь при коригуванні}
      begin                    {тобто використовуючи кнопку назад}
        POb[s].Ob:=0;
        POb[s].Oper1:=-1;
        POb[s].Oper2:=-1;
        POb[s].Oper3:=-1;
        POb[s].Oper4:=-1;
        POb[s].Oper5:=-1;
        POb[s].Oper6:=-1;
        POb[s].Oper7:=-1;
        POb[s].Oper8:=-1;
        POb[s].Axis:=false;
      end;
    MainUnit.counter:=1;
  end
  else
  begin
    if Length(POb)=0 then
      begin
        SetLength(POb,NDet);         //Задання масиву поверхонь
        for s:=0 to NDet-1 do
          begin
            POb[s].Ob:=MainUnit.POb[s].Ob;
            POb[s].Oper1:=MainUnit.POb[s].Oper1;
            POb[s].Oper2:=MainUnit.POb[s].Oper2;
            POb[s].Oper3:=MainUnit.POb[s].Oper3;
            POb[s].Oper4:=MainUnit.POb[s].Oper4;
            POb[s].Oper5:=MainUnit.POb[s].Oper5;
            POb[s].Oper6:=MainUnit.POb[s].Oper6;
            POb[s].Oper7:=MainUnit.POb[s].Oper7;
            POb[s].Oper8:=MainUnit.POb[s].Oper8;
            POb[s].Axis :=MainUnit.POb[s].Axis;
          end;
        finalize(MainUnit.POb);
      end;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.BitBtn2Click(Sender: TObject);
begin
  Pov_Close;
  Form5.Visible:=false;
  //  Tabcontrol1.Tabs.Clear;
  Form3.Visible:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.Edit1Change(Sender: TObject);
var
  j,k :integer; //j-виділена в даний момент вкладка; k-кількість обробок пов.
  ax,t:string; //ах-для позначеня осі (а); t-вісь/поверхня.
begin
  k:=strtoint(Edit1.Text);

  if k>8 then
  begin
      Edit1.Text:='8';
      ShowMessage('Надто багато етапів обробки, використайте діапазон 1 - 8');
  end
  else
  begin
      j:=Tabcontrol1.TabIndex;  //виділена в даний момент вкладка
  if j>-1 then
    if POb[j].Axis=true then
      begin
          ax:='a';
          t:='Вісь ';
      end
      else
      begin
          ax:='';
          t:='Поверхня ';
      end;

  if j<>-1 then
  begin
      POb[j].Ob:=k;
  end;
                          //вводимо текст в лейбли
  case k of
     0:begin
        Label4.Caption:='раз';
        Label5.Visible:=true;
        Label5.Caption:='Не оброблюэться';
        Label6.Visible:=false;
        Label7.Visible:=false;
        Label8.Visible:=false;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=false;
        Combobox2.Visible:=false;
        Combobox3.Visible:=false;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     1:begin
        Label4.Caption:='раз';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1f отримана на операції';
        Label6.Visible:=true;
        Label7.Visible:=false;
        Label8.Visible:=false;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=false;
        Combobox3.Visible:=false;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     2:begin
        Label4.Caption:='рази';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2f отримана на операції';
        Label7.Visible:=true;
        Label8.Visible:=false;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=false;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     3:begin
        Label4.Caption:='рази';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3f отримана на операції';
        Label8.Visible:=true;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     4:begin
        Label4.Caption:='рази';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+ax+'.4f отримана на операції';
        Label9.Visible:=true;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     5:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+ax+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+ax+'.5f отримана на операції';
        Label10.Visible:=true;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
      6:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+ax+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+ax+'.5 отримана на операції';
        Label10.Visible:=true;
        Label11.Caption:=t+inttostr(j+1)+ax+'.6f отримана на операції';
        Label11.Visible:=true;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=true;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
      7:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+ax+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+ax+'.5 отримана на операції';
        Label10.Visible:=true;
        Label11.Caption:=t+inttostr(j+1)+ax+'.6 отримана на операції';
        Label11.Visible:=true;
        Label12.Caption:=t+inttostr(j+1)+ax+'.7f отримана на операції';
        Label12.Visible:=true;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=true;
        Combobox7.Visible:=true;
        Combobox8.Visible:=false;
       end;
       8:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+ax+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+ax+'.5 отримана на операції';
        Label10.Visible:=true;
        Label11.Caption:=t+inttostr(j+1)+ax+'.6 отримана на операції';
        Label11.Visible:=true;
        Label12.Caption:=t+inttostr(j+1)+ax+'.7f отримана на операції';
        Label12.Visible:=true;
        Label13.Caption:=t+inttostr(j+1)+ax+'.8f отримана на операції';
        Label13.Visible:=true;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=true;
        Combobox7.Visible:=true;
        Combobox8.Visible:=true;
       end;
    end;
  end;
end;
{..............................................................................}
                                 //якщо переключили вкладку----->
{..............................................................................}
procedure TForm5.TabControl1Change(Sender: TObject);
var
  r,j:integer;
  ax,t:string;
begin

  j:=Tabcontrol1.TabIndex;
   if POb[j].Ob=0 then begin
  Edit1.Text:=inttostr(POb[j].Ob);
  ComboBox1.ItemIndex:=POb[j].Oper1;
  Combobox2.ItemIndex:=POb[j].Oper2;
  Combobox3.ItemIndex:=POb[j].Oper3;
  Combobox4.ItemIndex:=POb[j].Oper4;
  Combobox5.ItemIndex:=POb[j].Oper5;
  Combobox6.ItemIndex:=POb[j].Oper6;
  Combobox7.ItemIndex:=POb[j].Oper7;
  Combobox8.ItemIndex:=POb[j].Oper8;
  Checkbox1.Checked:=POb[j].Axis;



  if POb[j].Axis=true then
  begin
      ax:='a';
      t:='Вісь ';
      Label2.Caption:='Параметри осі '+inttostr(j+1)+'a.9 деталі';
  end
  else
  begin
      ax:='';
      t:='Поверхня ';
      Label2.Caption:='Параметри поверхні '+inttostr(j+1)+'.9 деталі';
  end;

  r:=POb[j].Ob;
  Edit1.Text:=inttostr(r);
  NOp:=strtoint(Form3.Edit7.Text);

{----------------------Колличество обработок}
  case r of
     0:begin
        Label4.Caption:='раз';
        Label5.Visible:=true;
        Label5.Caption:='Не оброблюється';
        Label6.Visible:=false;
        Label7.Visible:=false;
        Label8.Visible:=false;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=false;
        Combobox2.Visible:=false;
        Combobox3.Visible:=false;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     1:begin
        Label4.Caption:='раз';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1f отримана на операції';
        Label6.Visible:=true;
        Label7.Visible:=false;
        Label8.Visible:=false;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=false;
        Combobox3.Visible:=false;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     2:begin
        Label4.Caption:='рази';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2f отримана на операції';
        Label7.Visible:=true;
        Label8.Visible:=false;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=false;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     3:begin
        Label4.Caption:='рази';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3f отримана на операції';
        Label8.Visible:=true;
        Label9.Visible:=false;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=false;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     4:begin
        Label4.Caption:='рази';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+ax+'.4f отримана на операції';
        Label9.Visible:=true;
        Label10.Visible:=false;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=false;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
     5:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+ax+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+ax+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+ax+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+ax+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+ax+'.5f отримана на операції';
        Label10.Visible:=true;
        Label11.Visible:=false;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=false;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
      6:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+'.5 отримана на операції';
        Label10.Visible:=true;
        Label11.Caption:=t+inttostr(j+1)+'.6f отримана на операції';
        Label11.Visible:=true;
        Label12.Visible:=false;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=true;
        Combobox7.Visible:=false;
        Combobox8.Visible:=false;
       end;
      7:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+'.5 отримана на операції';
        Label10.Visible:=true;
        Label11.Caption:=t+inttostr(j+1)+'.6 отримана на операції';
        Label11.Visible:=true;
        Label12.Caption:=t+inttostr(j+1)+'.7f отримана на операції';
        Label12.Visible:=true;
        Label13.Visible:=false;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=true;
        Combobox7.Visible:=true;
        Combobox8.Visible:=false;
       end;
       8:begin
        Label4.Caption:='разів';
        Label5.Visible:=false;
        Label6.Caption:=t+inttostr(j+1)+'.1 отримана на операції';
        Label6.Visible:=true;
        Label7.Caption:=t+inttostr(j+1)+'.2 отримана на операції';
        Label7.Visible:=true;
        Label8.Caption:=t+inttostr(j+1)+'.3 отримана на операції';
        Label8.Visible:=true;
        Label9.Caption:=t+inttostr(j+1)+'.4 отримана на операції';
        Label9.Visible:=true;
        Label10.Caption:=t+inttostr(j+1)+'.5 отримана на операції';
        Label10.Visible:=true;
        Label11.Caption:=t+inttostr(j+1)+'.6 отримана на операції';
        Label11.Visible:=true;
        Label12.Caption:=t+inttostr(j+1)+'.7 отримана на операції';
        Label12.Visible:=true;
        Label13.Caption:=t+inttostr(j+1)+'.8f отримана на операції';
        Label13.Visible:=true;
        Combobox1.Visible:=true;
        Combobox2.Visible:=true;
        Combobox3.Visible:=true;
        Combobox4.Visible:=true;
        Combobox5.Visible:=true;
        Combobox6.Visible:=true;
        Combobox7.Visible:=true;
        Combobox8.Visible:=true;
       end;
  end;
{----------------Колличество обработок забиваєм в масив для кажної поверхні j }

  Combobox1.ItemIndex:=POb[j].Oper1;
  Combobox2.ItemIndex:=POb[j].Oper2;
  Combobox3.ItemIndex:=POb[j].Oper3;
  Combobox4.ItemIndex:=POb[j].Oper4;
  Combobox5.ItemIndex:=POb[j].Oper5;
  Combobox6.ItemIndex:=POb[j].Oper6;
  Combobox7.ItemIndex:=POb[j].Oper7;
  Combobox8.ItemIndex:=POb[j].Oper8;

  Checkbox1.Checked:=POb[j].Axis;   //для осі

    end else begin
  Edit1.Text:=inttostr(POb[j].Ob);
  ComboBox1.ItemIndex:=POb[j].Oper1;
  Combobox2.ItemIndex:=POb[j].Oper2;
  Combobox3.ItemIndex:=POb[j].Oper3;
  Combobox4.ItemIndex:=POb[j].Oper4;
  Combobox5.ItemIndex:=POb[j].Oper5;
  Combobox6.ItemIndex:=POb[j].Oper6;
  Combobox7.ItemIndex:=POb[j].Oper7;
  Combobox8.ItemIndex:=POb[j].Oper8;
  Checkbox1.Checked:=POb[j].Axis;
  if POb[j].Axis=true then
  begin
      ax:='a';
      t:='Вісь ';
      Label2.Caption:='Параметри осі '+inttostr(j+1)+'a.9 деталі';
  end
  else
  begin
      ax:='';
      t:='Поверхня ';
      Label2.Caption:='Параметри поверхні '+inttostr(j+1)+'.9 деталі';
  end;
 end;

end;
{..............................................................................}

{..............................................................................}
procedure TForm5.CheckBox1Click(Sender: TObject);
var
  j:integer;
begin
  j:=Tabcontrol1.TabIndex;
  POb[j].Axis:=Checkbox1.Checked;

  if POb[j].Axis=true then
  begin
    Tabcontrol1.Tabs.Strings[j]:=inttostr(j+1)+'a.9';
    Label2.Caption:='Параметри осі '+inttostr(j+1)+'a.9 деталі';
  end
  else
  begin
    Tabcontrol1.Tabs.Strings[j]:=inttostr(j+1)+'.9';
    Label2.Caption:='Параметри поверхні '+inttostr(j+1)+'.9 деталі';
  end;

  TabControl1Change(nil);
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox1Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox1.ItemIndex;
    POb[j].Oper1:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox2Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox2.ItemIndex;
    POb[j].Oper2:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox3Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox3.ItemIndex;
    POb[j].Oper3:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox4Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox4.ItemIndex;
    POb[j].Oper4:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox5Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox5.ItemIndex;
    POb[j].Oper5:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox6Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox6.ItemIndex;
    POb[j].Oper6:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox7Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox7.ItemIndex;
    POb[j].Oper7:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.ComboBox8Change(Sender: TObject);
var
  i,j:integer;
begin
    j:=Tabcontrol1.TabIndex;
    i:=Combobox8.ItemIndex;
    POb[j].Oper8:=i;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.Pov_Close;
var
    tmp_f : TStrings;
    a,c,d,i : integer;
    ax,t : string;
begin
  zn:=0;

  for a:=0 to NDet-1 do
  begin
    Zn:=Zn+POb[a].Ob;
  end;

  adres := ExtractFilePath(Application.ExeName);
 // str:=Application.ExeName;
 // ls:=length(Application.ExeName);
 // setlength(str,ls-15);
  tmp_f:=TStringList.Create();
  tmp_f.LoadFromFile(adres+'shapes.dat');
  tmp_f.Clear;
  tmp_f.Add('[shapes]');
  tmp_f.Add('numberOb='+inttostr(zn));
  i:=0;
       {----------------запис в файл shapes.dat інформації про поверхні}
  for c:=0 to (NDet-1) do
  begin
    if POb[c].Axis=true then ax:='a'
       else ax:='';

       if POb[c].Ob=0 then
         begin
            t:=inttostr(c+1)+ax+'.0';
            tmp_f.Add(t);
            i:=i+1;
         end
         else
         begin
            t:=inttostr(c+1)+ax+'.0';
            tmp_f.Add(t);
            i:=i+1;
            for d:=1 to POb[c].Ob do
            begin
              if d<>POb[c].Ob then
              begin
                t:=inttostr(c+1)+ax+'.'+inttostr(d);
                tmp_f.Add(t);
                i:=i+1;
              end
              else
              begin
                t:=inttostr(c+1)+ax+'.'+inttostr(d)+'f';
                tmp_f.Add(t);
                i:=i+1;
              end;
            end;
         end;
  end;

  tmp_f.Strings[0]:='[shapes]='+inttostr(i);
  tmp_f.Add('[Ai]');

  for c:=0 to (NDet-1) do
  begin
    if POb[c].Axis=true then ax:='a'
  else
    ax:='';
    tmp_f.Add(inttostr(c+1)+ax+'.9');
  end;

  tmp_f.Add('[Bi]');
  for c:=0 to (NDet-1) do
  begin
    if POb[c].Axis=true then ax:='a'
  else ax:='';
  tmp_f.Add(inttostr(c+1)+ax+'.0');
  end;

  tmp_f.SaveToFile(adres+'shapes.dat');
  tmp_f.Free;
 // str:='';
//  ls:=0;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.BitBtn1Click(Sender: TObject);
begin
  Pov_Close;
  if Set1.Addings=true then ShowMessage('Загальна кількість переходів = '+inttostr(zn));
  Form5.Visible:=false;
  UnitAiSet.Form4.Show;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.Button5Click(Sender: TObject);
var
  s:integer;
begin
  if z_=1 then
  begin
      Form5.Height:=495;
      Speedbutton2.Visible:=true;
      z_:=0;
      Button5.Caption:='Додатково <<';
  end
  else
  begin
      Form5.Height:=382;
      Speedbutton2.Visible:=false;
      z_:=1;
      Button5.Caption:='Додатково >>';
  end;

  {----->>>> Інфо масиву - к-сть обробок}
  Stringgrid1.ColCount:=NDet+1;
  Stringgrid1.RowCount:=3;
  Stringgrid1.Cells[0,0]:='Позначення розм.';
  Stringgrid1.Cells[0,1]:='К-сть переходів';
  Stringgrid1.Cells[0,2]:='Вісь';
  for s:=1 to Ndet do
  begin
    Stringgrid1.Cells[s,0]:=inttostr(s)+'.9';
    Stringgrid1.Cells[s,1]:=inttostr(POb[s-1].Ob);
    if POb[s-1].Axis=true then Stringgrid1.Cells[s,2]:='так'
  else
    Stringgrid1.Cells[s,2]:='ні';
  end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.SpeedButton1Click(Sender: TObject);
begin
  Form5.Visible:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm5.SpeedButton2Click(Sender: TObject);
var
  s:integer;
begin
{----->>>> Інфо масиву - к-сть обробок}
  Stringgrid1.ColCount:=NDet+1;
  Stringgrid1.RowCount:=3;
  Stringgrid1.Cells[0,0]:='Позначення розм.';
  Stringgrid1.Cells[0,1]:='К-сть переходів';
  Stringgrid1.Cells[0,2]:='Вісь';
  for s:=1 to Ndet do
  begin
    Stringgrid1.Cells[s,0]:=inttostr(s)+'.9';
    Stringgrid1.Cells[s,1]:=inttostr(POb[s-1].Ob);
    if POb[s-1].Axis=true then Stringgrid1.Cells[s,2]:='так'
  else
    Stringgrid1.Cells[s,2]:='ні';
  end;
end;
{..............................................................................}
end.
