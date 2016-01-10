unit SettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DataUnit, ComCtrls;

type
  TForm2 = class(TForm)
    Btn_settingsOK: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    RadioGroup_Settings: TRadioGroup;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    procedure Btn_settingsOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  Set1: TSettings;
  demo:string;
  Sys_F:TStrings;
  adres: String; //для адреса, откуда запущена программа

implementation
uses MainUnit;
{$R *.dfm}

procedure TForm2.Btn_settingsOKClick(Sender: TObject);
//var ls:integer; str:string;
begin
Form2.Close;

Set1.MethodCalc:=RadioGroup_Settings.ItemIndex;


 if (Checkbox1.Checked=true) then Set1.Addings:=true
   else Set1.Addings:=false;
      if (Checkbox2.Checked=true) then Set1.Demo:=true
          else Set1.Demo:=false;
             if (Checkbox3.Checked=true) then begin
 case ComboBox1.ItemIndex of
  0:begin
     Set1.Date1:=true;
     Set1.Time1:=false;
    end;
  1:begin
     Set1.Date1:=true;
     Set1.Time1:=true;
    end;
 end;
            end
           else
    begin
    Set1.Date1:=false;
    Set1.Time1:=false;
   end;
    if (Checkbox4.Checked=true) then Set1.Kompens1:=true
        else Set1.Kompens1:=false;
    if (Checkbox5.Checked=true) then Set1.Wview:=true
        else Set1.Wview:=false;

//showmessage(inttostr(Method));

//str:=Application.ExeName;
//ls:=length(Application.ExeName);
//setlength(str,ls-15);
adres := ExtractFilePath(Application.ExeName);
Sys_F:=TStringList.Create();
Sys_F.LoadFromFile(adres+'settings.ini');
Sys_F.Clear;
Sys_F.Add('calculating.method='+inttostr(Set1.MethodCalc));
if Set1.Addings=true then begin
 Sys_F.Add('sys.addings=1');
 Form1.StatusBar1.Panels[2].Text:='  Add';
end else begin
 Sys_F.Add('sys.addings=0');
 Form1.StatusBar1.Panels[2].Text:='';
end;
if Set1.Demo=true then begin
 Sys_F.Add('demo=1');
 Form1.StatusBar1.Panels[3].Text:=' Demo';
end else begin
 Sys_F.Add('demo=0');
 Form1.StatusBar1.Panels[3].Text:='';
end;
if Set1.Date1=true then begin
 Sys_F.Add('date=1');
end else begin
 Sys_F.Add('date=0');
end;
if Set1.Time1=true then begin
 Sys_F.Add('time=1');
end else begin
 Sys_F.Add('time=0');
end;
if Set1.Kompens1=true then begin
 Sys_F.Add('kompens=1');
end else begin
 Sys_F.Add('kompens=0');
end;
if Set1.Wview=true then begin
 Sys_F.Add('W.view=1');
end else begin
 Sys_F.Add('W.view=0');
end;
Sys_F.Add('save.met='+inttostr(Set1.SaveMet));
Sys_F.SaveToFile(adres+'settings.ini');
Sys_F.Free;
case Set1.MethodCalc of
 0:Form1.StatusBar1.Panels[1].Text:='  Max';
 1:Form1.StatusBar1.Panels[1].Text:='  Im';
 2:Form1.StatusBar1.Panels[1].Text:='  PRG';
end;
end;



procedure TForm2.CheckBox3Click(Sender: TObject);
begin
 if Checkbox3.Checked=false then begin
  Combobox1.Enabled:=false;
  Combobox1.ItemIndex:=-1;
 end else begin
  Combobox1.Enabled:=true;
  Combobox1.ItemIndex:=0;
 end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
 PageControl1.TabIndex:=0;
{Sys_F:=TStringList.Create();
Sys_F.LoadFromFile('settings.ini');
demo:=Sys_F.ValueFromIndex[2];
Sys_F.Free;}

 RadioGroup_Settings.ItemIndex:=Set1.MethodCalc;
 if Set1.Kompens1=true then Checkbox4.Checked:=true
 else Checkbox4.Checked:=false;
 if Set1.Addings=true then Checkbox1.Checked:=true
 else Checkbox1.Checked:=false;
 if Set1.Demo=true then Checkbox2.Checked:=true
 else Checkbox2.Checked:=false;
 if Set1.Wview=true then Checkbox5.Checked:=true
 else Checkbox5.Checked:=false;
 if (Set1.Date1=true) and (Set1.Time1=true) then begin
  Checkbox3.Checked:=true;
  Combobox1.ItemIndex:=1;
 end else if (Set1.Date1=true) then begin
  Checkbox3.Checked:=true;
  Combobox1.ItemIndex:=0;
 end else begin
  Checkbox3.Checked:=false;
  Combobox1.ItemIndex:=-1;
 end;
end;

end.
