Program Project_RMA;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  SettingsUnit in 'SettingsUnit.pas' {Form2},
  Unit_NewCalc in 'Unit_NewCalc.pas' {Form3},
  UnitAiSet in 'UnitAiSet.pas' {Form4},
  UnitPovParametrs in 'UnitPovParametrs.pas' {Form5},
  DataUnit in 'DataUnit.pas',
  Unit_Otklon in 'Unit_Otklon.pas' {Form6},
  UnitRozmFType in 'UnitRozmFType.pas' {Form7},
  UnitBiSet in 'UnitBiSet.pas' {Form8},
  UnitFiSet in 'UnitFiSet.pas' {Form9},
  UnitZiSet in 'UnitZiSet.pas' {Form14},
  UWek in 'UWek.pas' {fmWek},
  URvb in 'URvb.pas' {fmRvb},
  UZmin in 'UZmin.pas' {fmZmin},
  UnitTB in 'UnitTB.pas' {Form11},
  UnitResults in 'UnitResults.pas' {Form12},
  UnitAbout in 'UnitAbout.pas' {Form13},
  UEb in 'UEb.pas' {fmBaza1},
  UnitZvit in 'UnitZvit.pas' {Form10},
  u_Word_Excel in 'u_Word_Excel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'плю ро';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TfmWek, fmWek);
  Application.CreateForm(TfmRvb, fmRvb);
  Application.CreateForm(TfmZmin, fmZmin);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TfmBaza1, fmBaza1);
  Application.CreateForm(TForm10, Form10);
  Application.Run;
end.
