unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, GIFImg;

type
  TForm13 = class(TForm)
    BitBtn1: TBitBtn;
    Bevel2: TBevel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    Animate1: TAnimate;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}

procedure TForm13.BitBtn1Click(Sender: TObject);
begin
Form13.Close;
end;

procedure TForm13.FormShow(Sender: TObject);
var ls:integer; str:string;
begin
str:=Application.ExeName;
ls:=length(Application.ExeName);
setlength(str,ls-15);
//imate1.FileName:=str+'anim\Logo-anim_200x200.avi';
//Animate1.Active:=true;
str:='';
//ls:=0;
end;

end.
