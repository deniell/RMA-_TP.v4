unit Unit_NewCalc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, SettingsUnit;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StaticText1: TStaticText;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label12: TLabel;
    Image1: TImage;
    Image2: TImage;
    Bevel1: TBevel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Edit7: TEdit;
    UpDown6: TUpDown;
    StaticText2: TStaticText;
    Bevel2: TBevel;
    GroupBox3: TGroupBox;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    UpDown8: TUpDown;
    UpDown9: TUpDown;
    UpDown10: TUpDown;
    UpDown11: TUpDown;
    Label7: TLabel;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure NewCalc_Show;
    procedure NewCalc_Close;
    procedure Save(Sender: TObject);
    procedure EditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  Dname,                   //����� �����
  fname, Mname : string;   // ����� �����, ��� �����������
  forma,                   //��� ����� �����
  Mtype,
  NOp,              //�-��� �������� ��
  NZag,             //�-��� ��������� ���������
  NDet,             //�-��� ��������� �����
  NBi,              //�-��� ������ ���������
  NAi,              //�-��� ���������������� ������
  NFi:integer;    //�-��� ������������ ������
  adres: String; //��� ������, ������ �������� ���������
 // str:string;
  tmp_f:TStrings;
  AddPovParam:Integer;
implementation
 uses
    UnitPovParametrs, MainUnit;
{$R *.dfm}

{..............................................................................}
procedure TForm3.FormShow(Sender: TObject);
begin
    NewCalc_Show;
end;
{..............................................................................}

{..............................................................................}
procedure TForm3.NewCalc_Show;

begin

  if (MainUnit.counter<0) then
    begin       // ���� �� ����� ������ �� ������ ���������� �� ���� �����
      Edit1.Text:='���� ������';
      radiobutton1.Checked:=true;
      radiobutton2.Checked:=false;
      Combobox1.ItemIndex:=2;
      Edit7.Text:='2';
      Edit3.Text:='3';
      Edit2.Text:='3';
      Edit4.Text:='2';
      Edit5.Text:='2';
      Edit6.Text:='3';
     mainunit.counter:=0;
    end
    else
    begin
         case MainUnit.NScalc of
          1: begin
                        Edit1.Text:=Dname;
      case forma of
      1: begin
            radiobutton1.Checked:=true;
            radiobutton2.Checked:=false;
         end;
      2: begin
            radiobutton1.Checked:=false;
            radiobutton2.Checked:=true;
         end;
      end;

      Combobox1.ItemIndex:=Mtype;
      Edit7.Text:=inttostr(NOp);
      Edit3.Text:=inttostr(NDet);
      Edit4.Text:=inttostr(NBi);
      Edit5.Text:=inttostr(NAi);
      Edit6.Text:=inttostr(NFi);
      Edit2.Text:=inttostr(NZag);
             end;
           2: begin
                          Edit1.Text:=MainUnit.Dname;
      case MainUnit.forma of
      1: begin
            radiobutton1.Checked:=true;
            radiobutton2.Checked:=false;
         end;
      2: begin
            radiobutton1.Checked:=false;
            radiobutton2.Checked:=true;
         end;
      end;

      Combobox1.ItemIndex:=MainUnit.Mtype;
      Edit7.Text:=inttostr(MainUnit.NOp);
      Edit3.Text:=inttostr(MainUnit.NDet);
      Edit4.Text:=inttostr(MainUnit.NBi);
      Edit5.Text:=inttostr(MainUnit.NAi);
      Edit6.Text:=inttostr(MainUnit.NFi);
      Edit2.Text:=inttostr(MainUnit.NZag);
              end;
         end;

    end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm3.BitBtn2Click(Sender: TObject);
begin
  unit_newcalc.Form3.Close;
  mainunit.counter:=-1;
end;
{..............................................................................}

{..............................................................................}
procedure TForm3.NewCalc_Close;
var
    c:integer;
  //  str:string;
    tmp_f:TStrings;
begin

    if radiobutton1.Checked=true then
        begin
            forma:=1;
            fname:='ҳ�� ���������';
        end;
    if radiobutton2.Checked=true then
        begin
            forma:=2;
            fname:='�������� ������';
        end;
    Mtype:=Combobox1.ItemIndex;     // ����� �����
    Mname:=Combobox1.Text;          // ��� �����������

    Dname:=(edit1.text);
    NOp:=strtoint(edit7.text);        // ����������� �������� ��
    NZag:=strtoint(edit2.text);       // ���������� ������������ ���������
    NDet:=strtoint(edit3.text);       // ���������� ������������ ������
    NBi:=strtoint(edit4.text);        // ���������� �������� ���������
    NAi:=strtoint(edit5.text);        // ���������� ��������������� ��������
    NFi:=strtoint(edit6.text);        // ���������� ��������������� ��������


  //  str:=Application.ExeName;
  //  ls:=length(Application.ExeName);
  //  setlength(str,ls-15);
    adres := ExtractFilePath(Application.ExeName);
    tmp_f:=TStringList.Create();    // �������� ��������� ����� ��� ���������� � ���"�� �������� �����
    tmp_f.LoadFromFile(adres+'data.dat');
    tmp_f.Clear;
    for c:=0 to 10 do
       begin
           tmp_f.Insert(c,'');
       end;
    tmp_f.Strings[0]:='[main]';
    tmp_f.Strings[1]:='n.strings=10';
    tmp_f.Strings[2]:='detal.name='+Dname;
    tmp_f.Strings[3]:='forma='+inttostr(forma);
    tmp_f.Strings[4]:='manuf.type='+inttostr(Mtype);
    tmp_f.Strings[5]:='n.oper='+inttostr(NOp);
    tmp_f.Strings[6]:='zag.shape='+inttostr(NZag);
    tmp_f.Strings[7]:='det.shape='+inttostr(NDet);
    tmp_f.Strings[8]:='zag.dim='+inttostr(NBi);
    tmp_f.Strings[9]:='det.dim='+inttostr(NAi);
    tmp_f.Strings[10]:='tech.dim='+inttostr(NFi);
    tmp_f.SaveToFile(adres+'data.dat');
    tmp_f.Free;
end;
{..............................................................................}

{..............................................................................}
procedure TForm3.BitBtn1Click(Sender: TObject);
var i:Integer;
begin
 i:=0;
///////////////////////////������ �� �����/////////////////////////////////////
     if (Edit1.Text=' ') or (Edit1.Text='0') then begin
      i:=1;
      ShowMessage('������ ����� �����.');

     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if (Edit2.Text=' ') or (Edit2.Text='0') then begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������ ������� ��������� ���������.');
     i:=1;
     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if (Edit3.Text=' ') or (Edit3.Text='0') then begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������ ������� ��������� �����.');
     i:=1;
     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if (Edit4.Text=' ') or (Edit4.Text='0') then begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������ ������� ������ ���������.');
     i:=1;
     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if (Edit5.Text=' ') or (Edit5.Text='0') then  begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������ ������� ���������������� ������.');
     i:=1;
     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if (Edit6.Text=' ') or (Edit6.Text='0') then begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������ ������� ������������ ������.');
     i:=1;
     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if (Edit7.Text=' ') or (Edit7.Text='0') then begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������ ������� �������� ��.');
     i:=1;
     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if (Radiobutton1.Checked=false) and (Radiobutton2.Checked=false) then begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������� ��� �����.');
     i:=1;
     end
     else
///////////////////////////������ �� �����/////////////////////////////////////
     if Combobox1.ItemIndex=-1 then begin
      ShowMessage('����������� ����� ��� ����������!'+#13#10+
                  '������� ��� �����������.');
     i:=1;
     end;
///////////////////////////������ �� �����/////////////////////////////////////
 if i=0 then begin

  NewCalc_Close;

  if Set1.Addings=true then         //���� � ���������� �������� �������
  ShowMessage('����� �����:            '+Dname+';'+#13#10+   //���������� ����,
              '����� �����:            '+fname+';'+#13#10+    //�� �������� ��� �� �����.
              '��� �����������:       '+Mname+';'+#13#10+
              '�-��� ��������:         '+inttostr(NOp)+';'+#13#10+
              '�-��� ���������:'+#13#10+
              '  -���������:                    '+inttostr(NZag)+';'+#13#10+
              '  -�����:                          '+inttostr(NDet)+';'+#13#10+
              '�-��� ������:'+#13#10+
              '  -���������:                    '+inttostr(NBi)+';'+#13#10+
              '  -����������������:      '+inttostr(NAi)+';'+#13#10+
              '  -������������:             '+inttostr(NFi)+'.');

 // if AddPovParam=1 or (mainunit.counter>1) then begin
 // Form3.Visible:=false;
 // Form5.Visible:=true;
 // end else
  Form3.Visible:=false;
  UnitPovParametrs.Form5.Show;

  end;

end;
{..............................................................................}

{..............................................................................}
procedure TForm3.Image1Click(Sender: TObject);
begin
  radiobutton1.Checked:=true;
  radiobutton2.Checked:=false;
end;
{..............................................................................}

{..............................................................................}
procedure TForm3.Image2Click(Sender: TObject);
begin
    radiobutton1.Checked:=false;
    radiobutton2.Checked:=true;
end;
{..............................................................................}

{..............................................................................}
procedure TForm3.Save(Sender: TObject);
begin
  //  mainunit.counter:=0;
    NewCalc_Close;
end;
{..............................................................................}

{..............................................................................}
procedure TForm3.EditChange(Sender: TObject);
begin
  AddPovParam:=1
end;
{..............................................................................}


end.

