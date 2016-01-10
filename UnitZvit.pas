unit UnitZvit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, Menus,
  PlatformDefaultStyleActnCtrls, ActnPopup, ShellApi, Printers, u_Word_Excel;

type
  TForm10 = class(TForm)
    Memo1: TMemo;
    ToolBar1: TToolBar;
    tb_save: TToolButton;
    ImageList1: TImageList;
    PopupActionBar1: TPopupActionBar;
    txt1: TMenuItem;
    MSWorddoc1: TMenuItem;
    tb_close: TToolButton;
    tb_separator1: TToolButton;
    SaveDialog1: TSaveDialog;
    tb_print: TToolButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    procedure FormShow(Sender: TObject);
    procedure tb_closeClick(Sender: TObject);
    procedure txt1Click(Sender: TObject);
    procedure MSWorddoc1Click(Sender: TObject);
    procedure tb_saveClick(Sender: TObject);
    procedure tb_printClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;
  save_met:integer;
  buf:array of string;
  txt_f:TStrings;
  adres: String; //для адреса, откуда запущена программа
  Procedure txtsave(Nlines:integer);
  Procedure WordEx(Nlines:integer);
  procedure PrintStrings(S: TStrings; Font: TFont; Title: string);

implementation
uses MainUnit, Unit_NewCalc, UnitPovParametrs, UnitAiSet, UnitBiSet, UnitFiSet,
     UnitZiSet, UnitResults, SettingsUnit;
{$R *.dfm}

procedure TForm10.FormShow(Sender: TObject);
var o:integer; d,t:TDateTime;
begin
if not IsOLEObjectInstalled('Word.Application') then begin
 //ShowMessage('Класс не зарегистрирован')
 MSWorddoc1.Enabled:=false;
 Set1.SaveMet:=0;
 end else
 //ShowMessage('Класс найден');
 MSWorddoc1.Enabled:=true;

case Set1.SaveMet of
 0:tb_save.ImageIndex:=2;
 1:tb_save.ImageIndex:=3;
end;

Form10.Caption:='Результати розрахунків для деталі - '+Unit_NewCalc.Dname;
Memo1.Clear;
Memo1.Lines.Strings[0]:='Назва деталі:  '+Unit_NewCalc.Dname;

if (set1.Date1=True) and (set1.Time1=true) then begin
 FormatDateTime('d.mm.yyyy',Date()); d:=Date();
 FormatDateTime('hh:nn',Time()); t:=Time();
 Memo1.Lines.Add('Дата проведення розрахунку: '+Datetostr(d)+', '
                 +Timetostr(t)+#13#10);
end else if (set1.Date1=True) then begin
 FormatDateTime('d.mm.yyyy',Date());
 d:=Date();
 Memo1.Lines.Add('Дата проведення розрахунку: '+Datetostr(d)+#13#10);
end else Memo1.Lines.Add('');

Memo1.Lines.Add('');
Memo1.Lines.Add('    Основні дані:');
Memo1.Lines.Add('');
Memo1.Lines.Add('Кількість поверхонь:');
Memo1.Lines.Add('     -Заготовки: ............................ '
                +inttostr(Unit_NewCalc.NZag));
Memo1.Lines.Add('     -Деталі: ................................. '
                +inttostr(Unit_NewCalc.NDet));
Memo1.Lines.Add('Кількість розмірів:');
Memo1.Lines.Add('     -Заготовки (Bi): ........................ '
                +inttostr(Unit_NewCalc.NBi));
Memo1.Lines.Add('     -Конструкторських (Ai): ............. '
                +inttostr(Unit_NewCalc.NAi));
Memo1.Lines.Add('     -Технологічних (Fi): ................... '
                +inttostr(Unit_NewCalc.NFi));
Memo1.Lines.Add('     -Припусків (Zi): ......................... '
                +inttostr(UnitZiSet.NZi));
case MainUnit.Mtype of
 -1:;
  0:Memo1.Lines.Add('Тип виробництва: ......................... Одиничне');
  1:Memo1.Lines.Add('Тип виробництва: ......................... Малосерійне');
  2:Memo1.Lines.Add('Тип виробництва: ......................... Середньосерійне');
  3:Memo1.Lines.Add('Тип виробництва: ......................... Великосерійне');
  4:Memo1.Lines.Add('Тип виробництва: ......................... Масове');
end;
Memo1.Lines.Add('Кількість операцій ТП: .................... '
                +inttostr(Unit_NewCalc.NOp));
Memo1.Lines.Add('');
Memo1.Lines.Add('    Сформовані операційно-розмірні ланцюги (ОРЛ):');
Memo1.Lines.Add('');
for o:=0 to Length(UnitResults.ORL)-1 do begin
 if Length(UnitResults.ORL[o].chain1)<>0 then begin
  Memo1.Lines.Add(inttostr(o+1)+') '+UnitResults.ORL[o].chain1);
  Memo1.Lines.Add('       '+UnitResults.ORL[o].chain2);
 end;
end;
if Set1.Wview=true then begin
Memo1.Lines.Add('');
Memo1.Lines.Add('    Сформовані рівняння відхилень замикаючиз ланок:');
Memo1.Lines.Add('');
 for o:=0 to Length(UnitResults.ORL)-1 do
  if Length(UnitResults.ORL[o].chain1)<>0 then
   Memo1.Lines.Add(inttostr(o+1)+') '+UnitResults.ORL[o].chain3);
end;

Memo1.Lines.Add('');
Memo1.Lines.Add('    Конструкторські розміри:');
Memo1.Lines.Add('');
for o:=0 to UnitAiSet.NAi- 1 do begin
 Memo1.Lines.Add(inttostr(o+1)+'. А'+inttostr(o+1)+'  ('+UnitAiSet.PAi[o].N1+
                 ' - '+UnitAiSet.PAi[o].N2+')');
 Memo1.Lines.Add('     Номінальний розмір = '
                 +floattostr(UnitAiSet.PAi[o].Size)+' мм');
 Memo1.Lines.Add('     Максимальний розмір = '
                 +floattostr(UnitAiSet.PAi[o].Amax)+' мм');
 Memo1.Lines.Add('     Мінімальний розмір = '
                 +floattostr(UnitAiSet.PAi[o].Amin)+' мм');
 Memo1.Lines.Add('     Верхнє відхилення ES = '
                 +floattostr(UnitAiSet.PAi[o].ES)+' мм');
 Memo1.Lines.Add('     Нижнє відхилення EI = '
                 +floattostr(UnitAiSet.PAi[o].EI)+' мм');
 Memo1.Lines.Add('     Допуск T = '
                 +floattostr(UnitAiSet.PAi[o].T)+' мм');
 Memo1.Lines.Add('     Величина поля розсіювання ω = '
                 +strroundreal(UnitAiSet.PAi[o].W,3)+' мм');
 if UnitAiSet.PAi[o].Psi<1.199999 then
   Memo1.Lines.Add('     Точність розміру не забезпечується даним ТП (ψ = '
                   +strroundreal(UnitAiSet.PAi[o].Psi,2)+'<1,2)') else
   Memo1.Lines.Add('     Точність розміру забезпечується даним ТП (ψ = '
                   +strroundreal(UnitAiSet.PAi[o].Psi,2)+'≥1,2)');
end;

Memo1.Lines.Add('');
Memo1.Lines.Add('    Розміри заготовки:');
Memo1.Lines.Add('');
for o:=0 to UnitBiSet.NBi- 1 do begin
 Memo1.Lines.Add(inttostr(o+1)+'. B'+inttostr(o+1)+'  ('+UnitBiSet.PBi[o].N1+
                 ' - '+UnitBiSet.PBi[o].N2+')');
 Memo1.Lines.Add('     Номінальний розмір = '
                 +floattostr(UnitBiSet.PBi[o].Size)+' мм');
 Memo1.Lines.Add('     Максимальний розмір = '
                 +floattostr(UnitBiSet.PBi[o].Bmax)+' мм');
 Memo1.Lines.Add('     Мінімальний розмір = '
                 +floattostr(UnitBiSet.PBi[o].Bmin)+' мм');
 Memo1.Lines.Add('     Верхнє відхилення ES = '
                 +floattostr(UnitBiSet.PBi[o].ES)+' мм');
 Memo1.Lines.Add('     Нижнє відхилення EI = '
                 +floattostr(UnitBiSet.PBi[o].EI)+' мм');
 Memo1.Lines.Add('     Допуск T = '
                 +floattostr(UnitBiSet.PBi[o].T)+' мм');
end;

Memo1.Lines.Add('');
Memo1.Lines.Add('    Технологічні розміри:');
Memo1.Lines.Add('');
for o:=0 to UnitFiSet.NFi- 1 do begin
 Memo1.Lines.Add(inttostr(o+1)+'. F'+inttostr(o+1)+'  ('+UnitFiSet.PFi[o].N1+
                 ' - '+UnitFiSet.PFi[o].N2+')');
 Memo1.Lines.Add('     Номінальний розмір = '
                 +strroundreal(UnitFiSet.PFi[o].Size,3)+' мм');
 Memo1.Lines.Add('     Максимальний розмір = '
                 +strroundreal(UnitFiSet.PFi[o].Fmax,3)+' мм');
 Memo1.Lines.Add('     Мінімальний розмір = '
                 +strroundreal(UnitFiSet.PFi[o].Fmin,3)+' мм');
 Memo1.Lines.Add('     Верхнє відхилення ES = '
                 +strroundreal(UnitFiSet.PFi[o].ES,3)+' мм');
 Memo1.Lines.Add('     Нижнє відхилення EI = '
                 +strroundreal(UnitFiSet.PFi[o].EI,3)+' мм');
 Memo1.Lines.Add('     Величина поля розсіювання ω = '
                 +strroundreal(UnitFiSet.PFi[o].W,3)+' мм');
 Memo1.Lines.Add('     Величина поля розсіювання ωек = '
                 +strroundreal(UnitFiSet.PFi[o].Wek,3)+' мм');
 Memo1.Lines.Add('     Похибка базування εб = '
                 +strroundreal(UnitFiSet.PFi[o].Eb,3)+' мм');
 Memo1.Lines.Add('     Просторове відхилення вимірювальної бази ρвб = '
                 +strroundreal(UnitFiSet.PFi[o].dRvb,3)+' мм');
end;

Memo1.Lines.Add('');
Memo1.Lines.Add('    Припуски:');
Memo1.Lines.Add('');
for o:=0 to UnitZiSet.NZi- 1 do begin
 if UnitZiSet.PZi[o].Kind=0 then
 Memo1.Lines.Add(inttostr(o+1)+'. '+UnitZiSet.PZi[o].Name+
                 '  ('+UnitZiSet.PZi[o].N1+' - '+UnitZiSet.PZi[o].N2+')')
 else
 Memo1.Lines.Add(inttostr(o+1)+'. '+UnitZiSet.PZi[o].Name+
                 '*  ('+UnitZiSet.PZi[o].N1+' - '+UnitZiSet.PZi[o].N2+')');
 Memo1.Lines.Add('     Максимальне значення = '
                 +strroundreal(UnitZiSet.PZi[o].Zmax,3)+' мм');
 Memo1.Lines.Add('     Мінімальне значення = '
                 +strroundreal(UnitZiSet.PZi[o].Zmin,3)+' мм');
 Memo1.Lines.Add('     Величина поля розсіювання ω = '
                 +strroundreal(UnitZiSet.PZi[o].W,3)+' мм');
end;
end;

procedure TForm10.txt1Click(Sender: TObject);
var {str:string; ls:integer;}
Sys_F:TStrings;
begin
tb_save.ImageIndex:=2;
Set1.SaveMet:=0;
//str:=Application.ExeName;
//ls:=length(Application.ExeName);
//setlength(str,ls-15);
adres := ExtractFilePath(Application.ExeName);
Sys_F:=TStringList.Create();
Sys_F.LoadFromFile(adres+'settings.ini');
Sys_F.Strings[6]:='save.met=0';
Sys_F.SaveToFile(adres+'settings.ini');
Sys_F.Free;
end;

procedure TForm10.MSWorddoc1Click(Sender: TObject);
var {str:string; ls:integer;} Sys_F:TStrings;
begin
tb_save.ImageIndex:=3;
Set1.SaveMet:=1;
//str:=Application.ExeName;
//ls:=length(Application.ExeName);
//setlength(str,ls-15);
adres := ExtractFilePath(Application.ExeName);
Sys_F:=TStringList.Create();
Sys_F.LoadFromFile(adres+'settings.ini');
Sys_F.Strings[6]:='save.met=1';
Sys_F.SaveToFile(adres+'settings.ini');
Sys_F.Free;
end;

procedure TForm10.tb_closeClick(Sender: TObject);
begin
Form10.Close;
end;

procedure PrintStrings(S: TStrings; Font: TFont; Title: string);
var
 LeftMargin, TopMargin, LineCoord, LineOnPage, LinesOnDoc,
 CurrentLine, TextHeight, LinesPerPage, LineInterval: integer;

 procedure StartDoc;
 begin
   LinesOnDoc := S.Count;
   Printer.Canvas.Font.Assign(Font);
   Printer.Canvas.TextOut(0, 0, ' ');
   LeftMargin := (Printer.Canvas.Font.PixelsPerInch) div 2;
   TopMargin  := (Printer.Canvas.Font.PixelsPerInch) div 2;
   TextHeight := Abs(Printer.Canvas.Font.Height);
   LineInterval := TextHeight + (TextHeight div 2);
   LinesPerPage := (Printer.PageHeight - TopMargin) div LineInterval;
   CurrentLine := 0;
 end;

 function MorePages:boolean;
 begin
   Result := (CurrentLine <  LinesOnDoc) and
             not Printer.Aborted;
 end;

 procedure StartPage;
 begin
   LineOnPage := 0;
   LineCoord := TopMargin;
 end;

 procedure NextPage;
 begin
   if MorePages then Printer.NewPage;
 end;

 function MoreLines:boolean;
 begin
   Result := (LineOnPage <  LinesPerPage) and
             (LineOnPage <  LinesOnDoc) and
             not Printer.Aborted;
 end;

 procedure NextLine;
 begin
   Inc(LineOnPage);
   Inc(LineCoord, LineInterval);
   Inc(CurrentLine);
 end;

 procedure PrintLine;
 begin
   Printer.Canvas.TextOut(LeftMargin, LineCoord, S.Strings[CurrentLine]);
 end;

begin
 Printer.Title := Title;
 Printer.BeginDoc;
 StartDoc;
 while MorePages do
 begin
   StartPage;
   while MoreLines do
   begin
     PrintLine;
     NextLine;
     Application.ProcessMessages;
   end;
   NextPage;
 end;
 Printer.EndDoc;
end;

procedure TForm10.tb_printClick(Sender: TObject); //Друк данних
//var
//  tm: TTextMetric;
//  i: integer;
begin
//  if PrintDialog1.Execute then
//  begin
//    PrintStrings(Memo1.Lines,Memo1.Font,PrintDialog1.Name);
//  end;
end;

procedure TForm10.tb_saveClick(Sender: TObject);
var
ToR: TextFile;
tmp_f:TStrings;
n1,j:integer;
begin
 n1:=memo1.Lines.Count;
 //ShowMessage(inttostr(n1));
 Setlength(buf,n1);
 for j:=0 to n1-1 do
  buf[j]:=memo1.Lines.Strings[j];
case Set1.SaveMet of
 0:begin
   if MainUnit.Dname='' then SaveDialog1.FileName:='Нова деталь.txt'
      else SaveDialog1.FileName:=MainUnit.Dname+'.txt';
    if SaveDialog1.Execute then      { Display Save dialog box}
    begin
      AssignFile(ToR, SaveDialog1.FileName);	{ Open output file }
      Rewrite(ToR);	{ Record size = 1 }
      CloseFile(ToR);
      tmp_f:=TStringList.Create();
      tmp_f.LoadFromFile(SaveDialog1.FileName);
      tmp_f.Clear;
      txtsave(n1);
      tmp_f.AddStrings(txt_f);
      txt_f.Free;
      tmp_f.SaveToFile(SaveDialog1.FileName);
      tmp_f.Free;
    end;
   end;
 1:begin
    WordEx(n1);
   end;
end;
end;

Procedure WordEx(Nlines:integer);
var i:integer;
begin
if CreateWord then begin
   VisibleWord(true);
   If AddDoc then begin
    for i:=0 to Nlines-1 do
     SetTextToDoc(buf[i]+#13#10,true);
    CloseDoc;
   end;
   CloseWord;
   end;
end;

Procedure txtsave(Nlines:integer);
var i:integer; d,t:TDateTime;
begin
 txt_f:=TStringList.Create();
 txt_f.Add('Назва деталі:  '+Unit_NewCalc.Dname);
 if (set1.Date1=True) and (set1.Time1=true) then begin
 FormatDateTime('d.mm.yyyy',Date()); d:=Date();
 FormatDateTime('hh:nn',Time()); t:=Time();
 txt_f.Add('Дата проведення розрахунку: '+Datetostr(d)+', '
                 +Timetostr(t)+#13#10);
end else if (set1.Date1=True) then begin
 FormatDateTime('d.mm.yyyy',Date());
 d:=Date();
 txt_f.Add('Дата проведення розрахунку: '+Datetostr(d)+#13#10);
end else txt_f.Add('');
 txt_f.Add('    Основні дані:');
 txt_f.Add('');
 txt_f.Add('Кількість поверхонь:');
 txt_f.Add('     -Заготовки: ............................ '
           +inttostr(Unit_NewCalc.NZag));
 txt_f.Add('     -Деталі: ................................. '
           +inttostr(Unit_NewCalc.NDet));
 txt_f.Add('Кількість розмірів:');
 txt_f.Add('     -Заготовки (Bi): ........................ '
           +inttostr(Unit_NewCalc.NBi));
 txt_f.Add('     -Конструкторських (Ai): ............. '
            +inttostr(Unit_NewCalc.NAi));
 txt_f.Add('     -Технологічних (Fi): ................... '
            +inttostr(Unit_NewCalc.NFi));
 txt_f.Add('     -Припусків (Zi): ......................... '
                +inttostr(UnitZiSet.NZi));
 case MainUnit.Mtype of
  -1:;
   0:txt_f.Add('Тип виробництва: ......................... Одиничне');
   1:txt_f.Add('Тип виробництва: ......................... Малосерійне');
   2:txt_f.Add('Тип виробництва: ......................... Середньосерійне');
   3:txt_f.Add('Тип виробництва: ......................... Великосерійне');
   4:txt_f.Add('Тип виробництва: ......................... Масове');
 end;
 txt_f.Add('Кількість операцій ТП: .................... '
            +inttostr(Unit_NewCalc.NOp));

 txt_f.Add('');
 txt_f.Add('    Сформовані операційно-розмірні ланцюги (ОРЛ):');
 txt_f.Add('');
 for i:=0 to Length(UnitResults.ORL)-1 do begin
  if Length(UnitResults.ORL[i].chain1)<>0 then begin
   txt_f.Add(inttostr(i+1)+') '+UnitResults.ORL[i].chain1);
   txt_f.Add('       '+UnitResults.ORL[i].chain2);
  end;
 end;

if Set1.Wview=true then begin
txt_f.Add('');
txt_f.Add('    Сформовані рівняння відхилень замикаючиз ланок:');
txt_f.Add('');
 for i:=0 to Length(UnitResults.ORL)-1 do
  if Length(UnitResults.ORL[i].chain1)<>0 then
   txt_f.Add(inttostr(i+1)+') '+UnitResults.ORL[i].chain3);
end;

txt_f.Add('');
txt_f.Add('    Конструкторські розміри:');
txt_f.Add('');
for i:=0 to UnitAiSet.NAi- 1 do begin
 txt_f.Add(inttostr(i+1)+'. А'+inttostr(i+1)+'  ('+UnitAiSet.PAi[i].N1+
           ' - '+UnitAiSet.PAi[i].N2+')');
 txt_f.Add('     Номінальний розмір = '
           +floattostr(UnitAiSet.PAi[i].Size)+' мм');
 txt_f.Add('     Максимальний розмір = '
           +floattostr(UnitAiSet.PAi[i].Amax)+' мм)');
 txt_f.Add('     Мінімальний розмір = '
           +floattostr(UnitAiSet.PAi[i].Amin)+' мм');
 txt_f.Add('     Верхнє відхилення ES = '
           +floattostr(UnitAiSet.PAi[i].ES)+' мм');
 txt_f.Add('     Нижнє відхилення EI = '
           +floattostr(UnitAiSet.PAi[i].EI)+' мм');
 txt_f.Add('     Допуск T = '
           +floattostr(UnitAiSet.PAi[i].T)+' мм');
 txt_f.Add('     Величина поля розсіювання w = '
           +strroundreal(UnitAiSet.PAi[i].W,3)+' мм');
 if UnitAiSet.PAi[i].Psi<1.199999 then
   txt_f.Add('     Точність розміру не забезпечується даним ТП (Psi = '
             +strroundreal(UnitAiSet.PAi[i].Psi,2)+'<1,2)') else
   txt_f.Add('     Точність розміру забезпечується даним ТП (Psi = '
             +strroundreal(UnitAiSet.PAi[i].Psi,2)+'>=1,2)');
end;

txt_f.Add('');
txt_f.Add('    Розміри заготовки:');
txt_f.Add('');
for i:=0 to UnitBiSet.NBi- 1 do begin
 txt_f.Add(inttostr(i+1)+'. B'+inttostr(i+1)+'  ('+UnitBiSet.PBi[i].N1+
           ' - '+UnitBiSet.PBi[i].N2+')');
 txt_f.Add('     Номінальний розмір = '
           +floattostr(UnitBiSet.PBi[i].Size)+' мм');
 txt_f.Add('     Максимальний розмір = '
           +floattostr(UnitBiSet.PBi[i].Bmax)+' мм');
 txt_f.Add('     Мінімальний розмір = '
           +floattostr(UnitBiSet.PBi[i].Bmin)+' мм');
 txt_f.Add('     Верхнє відхилення ES = '
           +floattostr(UnitBiSet.PBi[i].ES)+' мм');
 txt_f.Add('     Нижнє відхилення EI = '
           +floattostr(UnitBiSet.PBi[i].EI)+' мм');
 txt_f.Add('     Допуск T = '+floattostr(UnitBiSet.PBi[i].T)+' мм');
end;

txt_f.Add('');
txt_f.Add('    Технологічні розміри:');
txt_f.Add('');
for i:=0 to UnitFiSet.NFi- 1 do begin
 txt_f.Add(inttostr(i+1)+'. F'+inttostr(i+1)+'  ('+UnitFiSet.PFi[i].N1+
           ' - '+UnitFiSet.PFi[i].N2+')');
 txt_f.Add('     Номінальний розмір = '
           +strroundreal(UnitFiSet.PFi[i].Size,3)+' мм');
 txt_f.Add('     Максимальний розмір = '
           +strroundreal(UnitFiSet.PFi[i].Fmax,3)+' мм');
 txt_f.Add('     Мінімальний розмір = '
             +strroundreal(UnitFiSet.PFi[i].Fmin,3)+' мм');
 txt_f.Add('     Верхнє відхилення ES = '
           +strroundreal(UnitFiSet.PFi[i].ES,3)+' мм');
 txt_f.Add('     Нижнє відхилення EI = '
           +strroundreal(UnitFiSet.PFi[i].EI,3)+' мм');
 txt_f.Add('     Величина поля розсіювання w = '
           +strroundreal(UnitFiSet.PFi[i].W,3)+' мм');
 txt_f.Add('     Величина поля розсіювання wек = '
             +strroundreal(UnitFiSet.PFi[i].Wek,3)+' мм');
 txt_f.Add('     Похибка базування Eб = '
           +strroundreal(UnitFiSet.PFi[i].Eb,3)+' мм');
 txt_f.Add('     Просторове відхилення вимірювальної бази Rвб = '
           +strroundreal(UnitFiSet.PFi[i].dRvb,3)+' мм');
end;

txt_f.Add('');
txt_f.Add('    Припуски:');
txt_f.Add('');
for i:=0 to UnitZiSet.NZi- 1 do begin
 if UnitZiSet.PZi[i].Kind=0 then
 txt_f.Add(inttostr(i+1)+'. '+UnitZiSet.PZi[i].Name+
           '  ('+UnitZiSet.PZi[i].N1+' - '+UnitZiSet.PZi[i].N2+')')
 else
 txt_f.Add(inttostr(i+1)+'. '+UnitZiSet.PZi[i].Name+
           '*  ('+UnitZiSet.PZi[i].N1+' - '+UnitZiSet.PZi[i].N2+')');
 txt_f.Add('     Максимальний розмір = '
           +strroundreal(UnitZiSet.PZi[i].Zmax,3)+' мм');
 txt_f.Add('     Мінімальний розмір = '
           +strroundreal(UnitZiSet.PZi[i].Zmin,3)+' мм');
 txt_f.Add('     Величина поля розсіювання w = '
           +strroundreal(UnitZiSet.PZi[i].W,3)+' мм');
end;
end;

end.
