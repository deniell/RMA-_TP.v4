unit UBaza;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, jpeg, OleCtnrs;

type
  TfmBaza = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Image2: TImage;
    Image3: TImage;
    Image5: TImage;
    Image4: TImage;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    UpDown2: TUpDown;
    Edit5: TEdit;
    Edit6: TEdit;
    UpDown3: TUpDown;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    RadioGroup1: TRadioGroup;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    RadioGroup2: TRadioGroup;
    Label16: TLabel;
    Label17: TLabel;
    RadioGroup3: TRadioGroup;
    Edit16: TEdit;
    Edit17: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Edit18: TEdit;
    Edit19: TEdit;
    UpDown4: TUpDown;
    Edit20: TEdit;
    Edit21: TEdit;
    UpDown5: TUpDown;
    Label20: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmBaza: TfmBaza;

implementation

uses UnitFiSet;

{$R *.DFM}




{procedure TfmBaza.BitBtn1Click(Sender: TObject);
var
 D:real;
 A:real;
 E:real;
begin
 D:=StrToFloat(Edit1.Text);
 A:=StrToFloat(Edit2.Text);
 case fmBaza.Tag of
  1:E:=0.5*D*(1/Sin(PI*A/180)+1);
  2:E:=0.5*D*(1/Sin(PI*A/180)-0);
  3:E:=0.5*D*(1/Sin(PI*A/180)-1);
 end;
 fmIf.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
end;}


procedure TfmBaza.BitBtn1Click(Sender: TObject);
var
 D:real;
 A:real;
 E:real;
 T1:real;
 T2:real;
 Rad:real;
 Eks:real;
begin
 case PageControl1.ActivePageIndex of
 0:begin
    D:=StrToFloat(Edit1.Text);
    A:=StrToFloat(Edit2.Text);
    E:=0.5*D*(1/Sin(PI*A/180)+1);
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2);
   end;
 1:begin
    D:=StrToFloat(Edit3.Text);
    A:=StrToFloat(Edit4.Text);
    E:=0.5*D*(1/Sin(PI*A/180)-0);
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2)
   end;
 2:begin
    D:=StrToFloat(Edit5.Text);
    A:=StrToFloat(Edit6.Text);
    E:=0.5*D*(1/Sin(PI*A/180)-1);
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2)
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
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2)
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
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2)
   end;
 5:begin
    D:=StrToFloat(Edit16.Text);
    Eks:=StrToFloat(Edit17.Text);
    case RadioGroup3.ItemIndex of
     0,1:E:=0.5*D+2*Eks;
     2:E:=2*Eks+T1+T2+2*Rad;
    end;
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2)
   end;
 6:begin
    D:=StrToFloat(Edit18.Text);
    A:=StrToFloat(Edit19.Text);
    E:=0.5*D*(cos(PI*A/180)/sin(PI*A/180));
    Form9.Edit2.Text:=FloatToStrF(E,ffFixed,8,2)
   end;
 7:begin
    D:=StrToFloat(Edit20.Text);
    A:=StrToFloat(Edit21.Text);
    Form9.Edit2.Text:=FloatToStr(0);
   end;
 end;
fmBaza.Visible:=false;
end;

procedure TfmBaza.BitBtn2Click(Sender: TObject);
begin
fmBaza.Close;
end;

end.
