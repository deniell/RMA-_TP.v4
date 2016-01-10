unit UEb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TfmBaza1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Image2: TImage;
    Panel3: TPanel;
    Image3: TImage;
    Panel4: TPanel;
    Image4: TImage;
    Panel5: TPanel;
    Image5: TImage;
    Panel6: TPanel;
    Image6: TImage;
    Panel7: TPanel;
    Image7: TImage;
    Panel8: TPanel;
    Image8: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Edit4: TEdit;
    UpDown2: TUpDown;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit6: TEdit;
    UpDown3: TUpDown;
    Edit5: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    RadioGroup1: TRadioGroup;
    Edit12: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Edit13: TEdit;
    Label14: TLabel;
    Edit14: TEdit;
    Label15: TLabel;
    Edit15: TEdit;
    RadioGroup2: TRadioGroup;
    Edit16: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Edit17: TEdit;
    RadioGroup3: TRadioGroup;
    Edit18: TEdit;
    Edit19: TEdit;
    UpDown4: TUpDown;
    Label18: TLabel;
    Label19: TLabel;
    Edit20: TEdit;
    UpDown5: TUpDown;
    Edit21: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmBaza1: TfmBaza1;

implementation
uses UnitFiSet;
{$R *.dfm}


procedure TfmBaza1.BitBtn1Click(Sender: TObject);
var
 D:real;
 A:real;
 E:real;
 T1:real;
 T2:real;
 Rad:real;
 Eks:real;
begin
T2:=0; T1:=0; E:=0;
 case PageControl1.ActivePageIndex of
 0:begin
    D:=StrToFloat(Edit1.Text);
    A:=StrToFloat(Edit2.Text);
    E:=0.5*D*(1/Sin(PI*A/180)+1);
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
    UnitFiSet.Form9.Edit2Exit(Sender);
   end;
 1:begin
    D:=StrToFloat(Edit3.Text);
    A:=StrToFloat(Edit4.Text);
    E:=0.5*D*(1/Sin(PI*A/180)-0);
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
    UnitFiSet.Form9.Edit2Exit(Sender)
   end;
 2:begin
    D:=StrToFloat(Edit5.Text);
    A:=StrToFloat(Edit6.Text);
    E:=0.5*D*(1/Sin(PI*A/180)-1);
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
    UnitFiSet.Form9.Edit2Exit(Sender)
   end;
 3:begin
    D:=StrToFloat(Edit7.Text);
    Eks:=StrToFloat(Edit8.Text);
    T1:=StrToFloat(Edit9.Text);
    T2:=StrToFloat(Edit10.Text);
    Rad:=StrToFloat(Edit11.Text);
    case RadioGroup1.ItemIndex of
     0,1:E:=0.5*D+2*Eks+T1+T2+2*Rad;
     2:E:=2*Eks+T1+T2+2*Rad;
    end;
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
    UnitFiSet.Form9.Edit2Exit(Sender)
   end;
 4:begin
    D:=StrToFloat(Edit12.Text);
    Eks:=StrToFloat(Edit13.Text);
    T1:=StrToFloat(Edit14.Text);
    T2:=StrToFloat(Edit15.Text);
    case RadioGroup2.ItemIndex of
     0,1:E:=0.5*D+2*Eks+0.5*T2;
     2:E:=2*Eks+0.5*T1+0.5*T2;
    end;
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
    UnitFiSet.Form9.Edit2Exit(Sender)
   end;
 5:begin
    D:=StrToFloat(Edit16.Text);
    Eks:=StrToFloat(Edit17.Text);
    case RadioGroup3.ItemIndex of
     0,1:E:=0.5*D+2*Eks;
     2:E:=2*Eks+T1+T2+D;
    end;
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
    UnitFiSet.Form9.Edit2Exit(Sender)
   end;
 6:begin
    D:=StrToFloat(Edit18.Text);
    A:=StrToFloat(Edit19.Text);
    E:=0.5*D*(cos(PI*A/180)/sin(PI*A/180));
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
    UnitFiSet.Form9.Edit2Exit(Sender)
   end;
 7:begin
    Form9.Edit2.Text:='0';
   end;
 end;
fmBaza1.Visible:=false;
end;

procedure TfmBaza1.BitBtn2Click(Sender: TObject);
begin
fmBaza1.Close;
end;

procedure TfmBaza1.FormHide(Sender: TObject);
begin
 Form9.Edit2.SetFocus;
end;

end.
