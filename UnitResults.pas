unit UnitResults;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, Math, ComObj, ActiveX, DataUnit;

type
  TForm12 = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormShow(Sender: TObject);
   // procedure KResults_Eror(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
 // type
//   procedure KResults_Eror(Sender: TObject);
    { Public declarations }
  end;

var
  Form12: TForm12;
  Dname:string;
  forma,
  Mtype,
  NOp,              //К-сть операцій ТП
  NZag,             //К-сть поверхонь заготовки
  NDet,             //К-сть поверхонь деталі
  NBi,              //К-сть розмірів заготовки
  NAi,              //К-сть конструкторських розмірів
  NFi,              //К-сть технологічних розмірів
  NZi,              //К-сть припусків
  Zn:integer;
  NPov: integer;
  h0,v0,h1,v1:integer;             {горизонталь, вертикаль}
  PAi: array of TAi;               //Масив властивостей конструкторських розм.
  PBi: array of TBi;               //Масив властивостей розм. заготовки
  PFi: array of TFi;               //Масив властивостей технологічних розм.
  PZi: array of TZi;               //Масив властивостей припусків
  ORL: array of TORL;              //Масив ОРЛ
 // TmpORL: array of TTempORL;
  Pov:array of string;
  Matrix: array of array of TMatrix;
  tmp_f:TStrings;
  adres: String; //для адреса, откуда запущена программа
  //str:string;
  //
  Rp0    : array of char;    // правая знак (от движения)
 Rp1    : array of char;    // правая вид размера (тех заг)
 Rp2    : array of Integer; // правая порядковый номер
 Rp3    : array of Char;    // маркер направвления движения
 //Mb     : Boolean;          // маркер отката на один шаг
 LpCDir : array of String;  // маркер провереных направлений начала ОРЛ
 RpCDir : array of String;  // маркер проверенных направлений замыкающего размера ОРЛ
 //
  TmpORL : TTempORL;
  o : Integer = 0;
  RollBackVer : Integer;
  RollBackHor : Integer;
  RollBackDir : Char;
  RollBackFLG : Boolean;

  Function StrRoundReal(r:real; prec:byte):string;
 // Function Str2Char(Str:String; n:integer) :Char;

 // Function Compare(SLn:string; o:integer):boolean;
  Function findORL(o,x:integer):boolean;
  Function CheckPov(orl_,l1,l2,t:integer):boolean;

//  Procedure fill_matrix;

  Procedure w_calc;
  Procedure Rm_calc;
//  Procedure Fi_oper;
  Procedure kompens;

 // Function  SetCurPointV(Iteration : Integer) : Integer;
 // Function  SetCurPointH(Iteration : Integer) : Integer;
  Function  GetLastHor(sh : Integer) : Integer;
  Function  GetLastVer(sv : Integer) : Integer;
  Function  ChecSelfCell(sv,sh,Num : Integer):Boolean;
  Function  IsEnd(SPv,SPh,EPv,EPh : Integer; Criteria : Char):Boolean;
  Function  SetDierction(ME,Mb : Boolean; N : Char):Char;
  Function  IsRollBack : Boolean;
  Function  IsFirstElement : Boolean;
  Function  GetSign (CVs,CHs,SVs,SHs : Integer; DIRs : Char) : Char;

  Procedure GetORL;
  Procedure mFindORL(sv,sh,Num : Integer);
  Procedure WriteTempOrl(Rp0,Rp1,Rp3:char;
                       Rp2:Integer;
                       LpCDir,RpCDir:String;
                       FHor,FVer : Integer;
                       AddChange : Boolean);
//  procedure KResults_Eror(Sender: TObject);
  Procedure DelElement;
  Procedure WriteORL;
  function  AnsiPos(const Substr, S: string; FromPos: integer): Integer;

implementation

uses Unit_NewCalc,
     UnitAiSet,
     UnitBiSet,
     UnitFiSet,
     UnitZiSet,
     UnitTB,
     UnitPovParametrs,
     SettingsUnit,
     MainUnit;
{$R *.dfm}

{..............................................................................}
procedure TForm12.FormShow(Sender: TObject);
var p: Integer;
begin
    MainUnit.counter:=7;
    Label1.Top:=2;
    Label1.Left:=2;
    Stringgrid1.Left:=0;
    Stringgrid1.Top:=17;
    Stringgrid1.Width:=Form12.Width-7;
    Stringgrid1.Height:=Form12.Height-20-60;
    BitBtn1.Top:=Form12.Height-38-BitBtn1.Height;
    BitBtn1.Left:=Form12.Width-15-BitBtn1.Width;
    BitBtn2.Top:=Form12.Height-38-BitBtn2.Height;
    BitBtn2.Left:=10;
    if not IsOLEObjectInstalled('Excel.Application') then
        begin
            //ShowMessage('Класс не зарегистрирован');
            BitBtn2.Visible:=false;
        end
        else
        begin
            //ShowMessage('Класс найден');
            BitBtn2.Visible:=true;
        end;
    if Mainunit.m1=true then Bitbtn1.Caption:='Закрити'
        else Bitbtn1.Caption:='Розрахунок';
 adres := ExtractFilePath(Application.ExeName);
  //  str:= Unit_NewCalc.str;
   // str:=Application.ExeName;
   // ls:=length(Application.ExeName);
  //  setlength(str,ls-15);
{подхватывает из временного файла данные}
    tmp_f:=TStringList.Create();
    tmp_f.LoadFromFile(adres+'data.dat');
    Dname:=tmp_f.ValueFromIndex[2];
    NZag:=strtoint(tmp_f.ValueFromIndex[6]);
    NDet:=strtoint(tmp_f.ValueFromIndex[7]);
    NBi:=strtoint(tmp_f.ValueFromIndex[8]);
    NAi:=strtoint(tmp_f.ValueFromIndex[9]);
    NFi:=strtoint(tmp_f.ValueFromIndex[10]);
    tmp_f.Free;
    {Dname:=Unit_NewCalc.Dname;
    NZag:=Unit_NewCalc.NZag;
    NDet:=Unit_NewCalc.NDet;
    NBi:=Unit_NewCalc.NBi;
    NAi:=Unit_NewCalc.NAi;
    NFi:=Unit_NewCalc.NFi;}
    Zn:=UnitPovParametrs.Zn;
    Npov:=NDet+Zn;
    SetLength(Pov,NPov);
    p:=0;
    Stringgrid1.ColCount:=Npov+1;
    Stringgrid1.RowCount:=Npov+1;
{---номера колонок----}

  //   str:=Application.ExeName;
// ls:=length(Application.ExeName);
 //setlength(str,ls-15);
 tmp_f:=TStringList.Create();
 tmp_f.LoadFromFile(adres+'shapes.dat');
   // tmp_f:=TStringList.Create();
    //tmp_f.LoadFromFile(str+'shapes.dat');
    //Zn:=strtoint(tmp_f.ValueFromIndex[1]);

    for p:=0 to Npov-1 do
        Pov[p]:=tmp_f.Strings[p+2];
    tmp_f.Free;
    Form12.Caption:='Матриця розмірних з''вязків';
    Label1.Caption:='Розмір матриці: '+inttostr(NPov)+'x'+inttostr(NPov);

end;
{..............................................................................}

{..............................................................................}
procedure TForm12.FormResize(Sender: TObject);
begin
  Label1.Top:=2;
  Label1.Left:=2;
  Stringgrid1.Left:=0;
  Stringgrid1.Top:=17;
  Stringgrid1.Width:=Form12.Width-7;
  Stringgrid1.Height:=Form12.Height-20-60;
  BitBtn1.Top:=Form12.Height-38-BitBtn1.Height;
  BitBtn1.Left:=Form12.Width-15-BitBtn1.Width;
  BitBtn2.Top:=Form12.Height-38-BitBtn2.Height;
  BitBtn2.Left:=10;
end;
{..............................................................................}

{..............................................................................}
procedure TForm12.BitBtn3Click(Sender: TObject);
var
    i,j,ls,b,a : integer;
   // tmp_f : TStrings;
    SLn,Sl0 : string;
    TMP,ZAG:array of string;
    nz,s : integer;
    p1,p2 : string;
    inf : boolean;
    POb : array of integer;

    n1, n2 : string;
    i1, i2 : integer;

    ts : string;

begin
 try

    SetLength(Matrix,NPov,NPov);

    for i:=0 to Npov-1 do
       for j:=0 to Npov-1 do
          begin
              Matrix[i,j].Names:='0';
              Matrix[i,j].index:=0;
          end;

{запис розм. заготовки}
    for i:=0 to NBi-1 do
        begin
            h0:=-1; v0:=-1;
            a:=i+1;
            j:=-1;
          repeat
              j:=j+1;
          until (UnitBiSet.PBi[i].N1=Pov[j]) or (j>(Npov-1));
          if j<Npov then h0:=j;
          j:=-1;
          repeat
              j:=j+1;
          until (UnitBiSet.PBi[i].N2=Pov[j]) or (j>(Npov-1));
          if j<Npov then v0:=j;
          if (h0>=0) and (v0>=0) then
              begin
                  Matrix[h0,v0].Names:='B';
                  Matrix[h0,v0].index:=a;
                  Matrix[v0,h0].Names:='B';
                  Matrix[v0,h0].index:=a;
              end;
        end;
{запис розм. заготовки}

{запис технологічних розм.}
    for i:=0 to NFi-1 do
        begin
            h0:=-1; v0:=-1;
            a:=i+1;
            j:=-1;
            repeat
                j:=j+1;
            until (UnitFiSet.PFi[i].N1=Pov[j]) or (j>(Npov-1));
            if j<Npov then h0:=j;
            j:=-1;
            repeat
                j:=j+1;
            until (UnitFiSet.PFi[i].N2=Pov[j]) or (j>(Npov-1));
            if j<Npov then v0:=j;
            if (h0>=0) and (v0>=0) then
                begin
                    Matrix[h0,v0].Names:='F';
                    Matrix[h0,v0].index:=a;
                    Matrix[v0,h0].Names:='F';
                    Matrix[v0,h0].index:=a;
                end;
        end;
{запис технологічних розм.}

{begin - заповнення матриці візуалізації}

   for i:=0 to Npov-1 do
       begin
           Stringgrid1.Cells[i+1,0]:=Pov[i];
           Stringgrid1.Cells[0,i+1]:=Pov[i];
           for j:=0 to Npov-1 do
               begin
                  if Matrix[i,j].Names='0'
                      then
                        try
                         Stringgrid1.Cells[i+1,j+1]:='';
                        except
                        end
                      else
                        Stringgrid1.Cells[i+1,j+1]:=Matrix[i,j].Names+inttostr(Matrix[i,j].index);
                  if i=j
                      then Stringgrid1.Cells[i+1,j+1]:='\';
               end;
       end;

{begin - запис конструктор. розм.}
    for i:=0 to NAi-1 do
        begin
            h0:=-1; v0:=-1;
            a:=i+1;

            j:=-1;
            repeat
                j:=j+1;
            until (UnitAiSet.PAi[i].N1f=Pov[j]) or (j>(Npov-1));
            if j<Npov then h0:=j+1
              else
              begin
                  j:=-1;
                  repeat
                      j:=j+1;
                  until (UnitAiSet.PAi[i].N1=Pov[j]) or (j>(Npov-1));
                  if j<Npov then h0:=j+1
                  else ShowMessage('Ошибка списка поверхностей');
              end;

            j:=-1;
            repeat
                j:=j+1;
            until (UnitAiSet.PAi[i].N2f=Pov[j]) or (j>(Npov-1));
            if j<Npov then v0:=j+1
            else
              begin
                  j:=-1;
                  repeat
                      j:=j+1;
                  until (UnitAiSet.PAi[i].N2=Pov[j]) or (j>(Npov-1));
                  if j<Npov then v0:=j+1
                  else ShowMessage('Ошибка списка поверхностей');
              end;


            if Matrix[h0-1,v0-1].Names='0' then
                begin
                    Stringgrid1.Cells[v0,h0]:='A'+inttostr(a);
                end
                else
                begin
                    Stringgrid1.Cells[v0,h0]:=Stringgrid1.Cells[h0,v0]+'/A'+inttostr(a);
                end;
        end;
{end - запис конструктор. розм.}
{begin - запис припусків}
    NZi:=MainUnit.NZi;
    for i:=0 to NZi-1 do
        begin
            h0:=-1;
            v0:=-1;
            j:=-1;
            repeat
                j:=j+1;
                try
                   ts := Pov[j];
                except
                   break;
                end;
            until (UnitZiSet.PZi[i].N1=ts) or (j>(Npov-1));
            if j<Npov then h0:=j+1
              else
              begin
                j:=-1;
                n1 := UnitZiSet.PZi[i].N1;
                i1 := AnsiPos('.',n1,1);
                Insert('a',n1,i1-1);
                repeat
                    j:=j+1;
                until (n1=Pov[j]) or (j>(Npov-1));
                if j<Npov then h0:=j+1
                  else ShowMessage('Ошибка списка поверхностей');
              end;

            j:=-1;
            repeat
                j:=j+1;
                try
                   ts := Pov[j];
                except
                   break;
                end;
            until (UnitZiSet.PZi[i].N2=ts) or (j>(Npov-1));
            if j<Npov then v0:=j+1
              else
              begin
                j:=-1;
                n2 := UnitZiSet.PZi[i].N2;
                i2 := AnsiPos('.',n2,1);
                Insert('a',n2,i2-1);
                repeat
                    j:=j+1;
                until (n2=Pov[j]) or (j>(Npov-1));
                if j<Npov then v0:=j+1
                  else ShowMessage('Ошибка списка поверхностей');
              end;

            if UnitZiSet.PZi[i].Kind=0 then
                begin
                    Stringgrid1.Cells[v0,h0]:=UnitZiSet.PZi[i].Name;
                end
                else
                begin
                    Stringgrid1.Cells[v0,h0]:=UnitZiSet.PZi[i].Name+'*';
                end;
        end;
{end - запис припусків}
Form12.Repaint;
 except
  try
   finalize(UnitResults.Matrix);
  except

  end;
   ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
// KResults_Eror(Sender);
 end;
end;
{..............................................................................}

{....функція для руху позиції курсора по матриці розмірних зв'язків............
......StringGrid1......по вертикалі............................................
Function  SetCurPointV(Iteration : Integer) : Integer;
var
    Name  : String;
    Index : Integer;
    i,j   : Integer;
Begin
    Name  := '';
    Index := 0;
    Name  := TmpORL.Rp1[Iteration];
    Index := TmpORL.Rp2[Iteration];
    i := -1;
    j := -1;
    repeat
        i := i + 1;
        j := -1;
         repeat
              j := j + 1;
         until (Matrix[i,j].Names = Name) and (Matrix[i,j].Index = Index) or (j>Npov) ;
    until (Matrix[i,j].Names = Name) and (Matrix[i,j].Index = Index) or (i>Npov);
    Result := j;
End;
{..............................................................................}

{....функція для руху позиції курсора по матриці розмірних зв'язків............
......StringGrid1......по горизонталі..........................................
Function  SetCurPointH(Iteration : Integer) : Integer;
var
    Name  : String;
    Index : Integer;
    i,j   : Integer;
Begin
    Name  := '';
    Index := 0;
    Name  := TmpORL.Rp1[Iteration];
    Index := TmpORL.Rp2[Iteration];
    i := -1;
    j := -1;
    repeat
        i := i + 1;
        j := -1;
         repeat
              j := j + 1;
         until (Matrix[i,j].Names = Name) and (Matrix[i,j].Index = Index) or (j>Npov) ;
    until (Matrix[i,j].Names = Name) and (Matrix[i,j].Index = Index) or (i>Npov);
    Result := i;
End;
{..............................................................................}

{..............................................................................}
Function GetLastHor(sh : Integer) : Integer;
var
    Count : Integer;
Begin
    Count := 10;
    repeat
         Count := Count - 1;
    Until (TmpORL.Rp1[Count] <> '0') or (Count = -1);
    if (Count = -1) then
        Begin
            Result := sh;
        End
        Else
            Result :=  TmpORL.FHor[Count];
End;
{..............................................................................}

{..............................................................................}
Function GetLastVer(sv : Integer) : Integer;
var
    Count : Integer;
Begin
    Count := 10;
    repeat
         Count := Count - 1;
    Until (TmpORL.Rp1[Count] <> '0') or (Count = -1);
    if (Count = -1) then
        Begin
            Result := sv;
        End
        Else
            Result :=  TmpORL.FVer[Count];
End;
{..............................................................................}

{..............................................................................}
Function  ChecSelfCell(sv,sh,Num : Integer):Boolean;
Begin
    if Matrix[sh,sv].Names<>'0' then
       begin
           WriteTempOrl('+',
                        Matrix[sh,sv].Names,
                        '0',
                        Matrix[sh,sv].index,
                        '0',
                        '0',
                         0,
                         0,
                        True);
           Result := True;
       End
       Else
       Result := False;
End;
{..............................................................................}

{..............................................................................}
Function  IsEnd(SPv,SPh,EPv,EPh : Integer; Criteria : Char):Boolean;
Var
    I : Boolean;
Begin
    I := False;
    If (Criteria = 'U') or (Criteria = 'D') then
        Begin
            If SPv = EPh then I := True
            Else
        End;
    If (Criteria = 'L') or (Criteria = 'R') then
        Begin
            If SPv = EPv then I := True
            Else
        End;
    If I = False Then Result := False
End;
{..............................................................................}

{..............................................................................}
Function  SetDierction(ME,Mb : Boolean; N : Char):Char;
Begin
{смена направления по найденному теоретически возможному звену}
    If (Me = False) and (Mb = False) Then
        Begin
            If (N = 'U') then Result := 'R';
            If (N = 'D') then Result := 'L';
            If (N = 'L') then Result := 'U';
            If (N = 'R') then Result := 'D';
        End;
{смена направления по найденному теоретически возможному звену}
{смена направления по выходу за придел матрицы}
{когда проверяется по смене направления проверки того же елемента}
    If (Me = True) and (Mb = False) Then
        Begin
            If (N = 'U') then
                Begin
                    Result := 'D';
                End;
            If (N = 'D') then
                Begin
                    Result := 'U';
                End;
            If (N = 'L') then
                Begin
                    Result := 'R';
                End;
            If (N = 'R') then
                Begin
                    Result := 'L';
                End;
        End;
{когда проверяется по смене направления проверки того же елемента}
{смена направления по выходу за придел матрицы}
{смена направления поиска по откату на символ}
    If (Me = True) and (Mb = True) Then
        Begin
            If (N = 'U') then
                Begin
                    Mb := False;
                    Result := 'R';
                End;
            If (N = 'D') then
                Begin
                    Mb := False;
                    Result := 'L';
                End;
            If (N = 'L') then
                Begin
                    Mb := False;
                    Result := 'U';
                End;
            If (N = 'R') then
                Begin
                    Mb := False;
                    Result := 'D';
                End;
        End;
End;
{..............................................................................}

{..............................................................................}
Function IsRollBack : Boolean;
var
    Count : Integer;
Begin
    Count := 10;
    Repeat
         Count := Count - 1;
    Until (TmpORL.Rp1[Count] <> '0') or (Count = -1);
    If Count = -1 then
        Begin
          if Length(TmpORL.LpCDir[0]) = 2 then Showmessage('ОРЛ для '
                                                            + TmpORL.LpC
                                                            + IntToStr(TmpORL.LpN)
                                                            + ' не знайдено або є помілка в вихідних данних');
          Count := 0;
        End;
    If Length(TmpORL.RpCDir[Count]) = 2 Then
        Begin
            RollBackVer := TmpORL.FVer[Count];
            RollBackHor := TmpORL.FHor[Count];
            RollBackDir := TmpORL.Rp3[Count];
            RollBackFLG := True;
            Result := True
        End
        Else Result := False;
End;
{..............................................................................}

{..............................................................................}
Function  IsFirstElement : Boolean;
var
    Count : Integer;
Begin
    Count := 10;
    Repeat
         Count := Count - 1;
    Until (TmpORL.Rp1[Count] <> '0') or (Count = -1);
    if (Count = -1) then Result := True
        else Result := False;
End;
{..............................................................................}

{..............................................................................}
Function GetSign (CVs,CHs,SVs,SHs : Integer; DIRs : Char) : Char;
var
   lparam : integer;
   rparam : integer;
Begin
    if ((DIRs = 'R') or (DIRs = 'L')) then lparam := CHs;
    if ((DIRs = 'U') or (DIRs = 'D')) then lparam := CVs;
    if ((DIRs = 'R') or (DIRs = 'L')) then rparam := CVs;
    if ((DIRs = 'U') or (DIRs = 'D')) then rparam := CHs;
    if ((lparam < rparam) and ((DIRs = 'R') or (DIRs = 'L'))) then Result := '+';
    if ((lparam > rparam) and ((DIRs = 'R') or (DIRs = 'L'))) then Result := '-';
    if ((lparam < rparam) and ((DIRs = 'U') or (DIRs = 'D'))) then Result := '+';
    if ((lparam > rparam) and ((DIRs = 'U') or (DIRs = 'D'))) then Result := '-';
End;
{..............................................................................}

{..............................................................................}
Procedure GetORL;
var
   i   : Integer; // щетчик для верхнего цыкла
   j   : Integer; // щетчик для поиска начальных координат
   sv,
   sh  : Integer; // начальные координаты вертикали и горизонтали
   Num : Integer; // щетчик ОРЛ
   i1,i2 : Integer;
   n1,n2 : String;

   ts : string;
Begin
 try
//  обявляем временный масив ОРЛ
    try
      SetLength (TmpORL.Rp0,100);
      SetLength (TmpORL.Rp1,100);
      SetLength (TmpORL.Rp2,100);
      SetLength (TmpORL.Rp3,100);
      SetLength (TmpORL.LpCDir,100);
      SetLength (TmpORL.RpCDir,100);
      SetLength (TmpORL.FVer,100);
      SetLength (TmpORL.FHor,100);
    except;
    end;
//  обявляем временный масив ОРЛ
    i := -1;
    repeat
         i := i + 1;
         TmpORL.Rp0[i] := '0';
         TmpORL.Rp1[i] := '0';
         TmpORL.Rp3[i] := '0';
         TmpORL.FHor[i] := 0;
         TmpORL.FVer[i] := 0;
    until (i = 10);

// ORL Ai
     Num := 0;
     for i := 0 to NAi - 1 do
     Begin
         Num := Num + 1;

         TmpORL.LpC := 'A';
         TmpORL.LpN := Num;

         sv := -1;
         sh := -1;
         j  := -1;
         Repeat
              j := j + 1;
         Until (UnitAiSet.PAi[i].N1f=Pov[j]) or (j>(Npov-1));
         If j < Npov Then
                        sh := j
                     Else
                        ShowMessage('Помилка визначення поверхонь!');
         j := -1;
         Repeat
              j := j + 1;
         Until (UnitAiSet.PAi[i].N2f=Pov[j]) or (j>(Npov-1));
         If j < Npov Then
                        sv := j
                     Else
                        ShowMessage('Помилка визначення поверхонь!');

         If ChecSelfCell(sv,sh,Num) = True
         then
            Begin
                WriteORL;
            End
            Else
            Begin
                mFindORL(sv,sh,Num);
                WriteORL;
            End;
     End;
// ORL Ai
{..............................................................................}
// ORL Zi
     Num := 0;
     for i := 0 to NZi - 1 do
     begin
         Num := Num + 1;

         TmpORL.LpC := 'Z';
         TmpORL.LpN := Num;

         sh := -1;
         sv := -1;

         ts := '';
         j  := -1;
         repeat
             j:=j+1;
             try
               ts := Pov[j];
             except
               break;
             end;
         until (UnitZiSet.PZi[i].N1=ts) or (j>(Npov-1));
         if j < Npov Then
                        sh := j
                     Else
                     Begin
                        j := -1;
                        n1 := UnitZiSet.PZi[i].N1;
                        i1 := AnsiPos('.',n1,1);
                        Insert('a',n1,i1-1);
                        repeat
                            j:=j+1;
                        until (n1=Pov[j]) or (j>(Npov-1));
                        if j < Npov then sh := j
                          else ShowMessage('Помилка визначення поверхонь!');
                     End;
         ts := '';
         j:=-1;
         repeat
             j:=j+1;
             try
               ts := Pov[j];
             except
               break;
             end;
         until (UnitZiSet.PZi[i].N2=ts) or (j>(Npov-1));
         if j < Npov Then
                        sv:=j
                     Else
                     Begin
                        j := -1;
                        n2 := UnitZiSet.PZi[i].N2;
                        i2 := AnsiPos('.',n2,1);
                        Insert('a',n2,i2-1);
                        repeat
                            j:=j+1;
                        until (n2=Pov[j]) or (j>(Npov-1));
                        if j < Npov then sv := j
                          else ShowMessage('Помилка визначення поверхонь!');
                     end;
                     //ShowMessage('Проверте вводимые данные!');

         If ChecSelfCell(sv,sh,Num) = True then
            Begin
                WriteORL;
            End
            Else
            Begin
                mFindORL(sv,sh,Num);
                WriteORL;
            End;
     End;
// ORL Zi
 except
  ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
  //Results_Eror;
 end;
End;
{..............................................................................}

{..............................................................................}
Procedure mFindORL(sv,sh,Num : Integer);
var
    N    : Char;         // направление движения поиска
    cv,
    ch   : Integer;      // временные координаты
    Forl : Boolean;      // найдено ли ОРЛ
    Iteration : Integer; // общее количество итераций
    Sign : Char;         // знак звена цепи
    Mb   : Boolean;      // флаг отката на один елемент
    i    : Integer;      // щетчик цыкла при выходе за приделы матрицы
    NulM : Boolean;      // если пробуем обратится к минусовому елементу масива
    RollBack : Boolean;   // переменная на откат назад
Begin
 try
     cv   := sv;  // мометным координатам присваиваем значение начальных
     ch   := sh;  // мометным координатам присваиваем значение начальных
     Forl := False;
     Mb   := False;
     NulM := False;
     Iteration := 0;
     RollBack := True;

     N := 'R';
  repeat
    Iteration := Iteration + 1;
    RollBackFLG := False;
    case N of
    {.................движение в верх...............................}
    'U': Begin
             repeat
                 ch := ch - 1;
                 if ch = -1 then
                          Begin
                              NulM := True;
                              ch := 0;
                          End;
             until (Matrix[ch,cv].Names<>'0') or (NulM = True);
             If (Matrix[ch,cv].Names <> '0') and (ch >= 0) and (NulM = False) then
                   Begin
                       Sign := GetSign (cv,ch,sv,sh,'U');
                       WriteTempOrl(Sign,
                                    Matrix[ch,cv].Names,
                                    N,
                                    Matrix[ch,cv].index,
                                    '0',
                                    '0',
                                    ch,
                                    cv,
                                    True);
                       Forl := IsEnd(sv,sh,cv,ch,'U');
                       If Forl = False Then N := SetDierction(False,False,'U')
                           else N := 'E';
                   End;
             If (ch < 0) or (NulM = True) Then
                   Begin
                       if (IsFirstElement) then WriteTempOrl('0',
                                                             '0',
                                                             '0',
                                                              0,
                                                             'U',
                                                             '0',
                                                              0,
                                                              0,
                                                              False)
                           else WriteTempOrl('0',
                                             '0',
                                             '0',
                                              0,
                                             '0',
                                             'U',
                                              0,
                                              0,
                                             False);

                       repeat
                           RollBack := IsRollBack;
                           if (RollBack) Then
                               Begin
                                   cv := RollBackVer;
                                   ch := RollBackHor;
                                   N  := RollBackDIR;
                                   DelElement;
                               End;
                       until RollBack = False;
                       if Not RollBackFLG then
                            Begin
                                N := SetDierction(True,RollBack,'U');
                                cv := GetLastVer(sv);
                                ch := GetLastHor(sh);
                                RollBackFLG := False;
                            End;
                       RollBack := True;
                       NulM := False;
                   End;
         End;  {.................движение в верх...............................}
    {.................движение в низ................................}
    'D': Begin
             repeat
                 ch := ch + 1;
                 If ch > Npov -1 Then
                         Begin
                             ch := ch - 1;
                             NulM := True;
                         End;
             until (Matrix[ch,cv].Names<>'0') or (NulM = True);
             If (Matrix[ch,cv].Names <> '0') and (NulM = False) and (ch <= Npov - 1) then
                   Begin
                       Sign := GetSign (cv,ch,sv,sh,'D');
                       WriteTempOrl(Sign,
                                    Matrix[ch,cv].Names,
                                    N,
                                    Matrix[ch,cv].index,
                                    '0',
                                    '0',
                                    ch,
                                    cv,
                                    True);
                       Forl := IsEnd(sv,sh,cv,ch,'D');
                       If Forl = False Then N := SetDierction(False,False,'D')
                           else N := 'E';
                   End;
             If (ch > Npov - 1) or (NulM = True) Then
                   Begin
                       if (IsFirstElement) then WriteTempOrl('0',
                                                             '0',
                                                             '0',
                                                              0,
                                                             'D',
                                                             '0',
                                                              0,
                                                              0,
                                                              False)
                           else WriteTempOrl('0',
                                             '0',
                                             '0',
                                              0,
                                             '0',
                                             'D',
                                              0,
                                              0,
                                             False);

                       repeat
                           RollBack := IsRollBack;
                           if (RollBack) Then
                               Begin
                                   cv := RollBackVer;
                                   ch := RollBackHor;
                                   N  := RollBackDIR;
                                   DelElement;
                               End;
                       until RollBack = False;
                       if Not RollBackFLG then
                            Begin
                                N := SetDierction(True,RollBack,'D');
                                cv := GetLastVer(sv);
                                ch := GetLastHor(sh);
                                RollBackFLG := False;
                            End;
                       RollBack := True;
                       NulM := False;
                   End;
         End; {.................движение в низ................................}
    {.................движение в лево...............................}
    'L': Begin
             repeat
                 cv := cv - 1;
                 if cv = -1 then
                          Begin
                              NulM := True;
                              cv := 0;
                          End;
             until (Matrix[ch,cv].Names<>'0') or (NulM = True);
             If (Matrix[ch,cv].Names<>'0') and (NulM = False) and (cv >= 0) then
                   Begin
                       Sign := GetSign (cv,ch,sv,sh,'L');
                       WriteTempOrl(Sign,
                                    Matrix[ch,cv].Names,
                                    N,
                                    Matrix[ch,cv].index,
                                    '0',
                                    '0',
                                    ch,
                                    cv,
                                    True);
                       Forl := IsEnd(sv,sh,cv,ch,'L');
                       If Forl = False Then N := SetDierction(False,False,'L')
                           else N := 'E';
                   End;
             If (cv < 0) or (NulM = True) Then
                   Begin
                       if (IsFirstElement) then WriteTempOrl('0',
                                                             '0',
                                                             '0',
                                                              0,
                                                             'L',
                                                             '0',
                                                              0,
                                                              0,
                                                              False)
                           else WriteTempOrl('0',
                                             '0',
                                             '0',
                                              0,
                                             '0',
                                             'L',
                                              0,
                                              0,
                                             False);
                       repeat
                           RollBack := IsRollBack;
                           if (RollBack) Then
                               Begin
                                   cv := RollBackVer;
                                   ch := RollBackHor;
                                   N  := RollBackDIR;
                                   DelElement;
                               End;
                       until RollBack = False;
                       if Not RollBackFLG then
                            Begin
                               N := SetDierction(True,RollBack,'L');
                               cv := GetLastVer(sv);
                               ch := GetLastHor(sh);
                               RollBackFLG := False;
                            End;
                       RollBack := True;
                       NulM := False;
                   End;
         End; {.................движение в лево...............................}
    {.................движение в право..............................}
    'R': Begin
             repeat
                 cv := cv + 1;
                 If cv > NPov - 1 Then
                         Begin
                             cv := cv - 1;
                             NulM := True;
                         End;
             until (Matrix[ch,cv].Names<>'0') or (NulM = True);
             If (Matrix[ch,cv].Names<>'0') and (cv <= Npov - 1) and (NulM = False) then
                   Begin
                       Sign := GetSign (cv,ch,sv,sh,'R');
                       WriteTempOrl(Sign,
                                    Matrix[ch,cv].Names,
                                    N,
                                    Matrix[ch,cv].index,
                                    '0',
                                    '0',
                                    ch,
                                    cv,
                                    True);
                       Forl := IsEnd(sv,sh,cv,ch,'R');
                       If Forl = False Then N := SetDierction(False,False,'R')
                           else N := 'E';
                   End;
             If (cv > Npov - 1) or (NulM = True) Then
                   Begin
                       if (IsFirstElement) then WriteTempOrl('0',
                                                             '0',
                                                             '0',
                                                              0,
                                                             'R',
                                                             '0',
                                                              0,
                                                              0,
                                                              False)
                           else WriteTempOrl('0',
                                             '0',
                                             '0',
                                              0,
                                             '0',
                                             'R',
                                              0,
                                              0,
                                             False);

                       repeat
                           RollBack := IsRollBack;
                           if (RollBack) Then
                               Begin
                                   cv := RollBackVer;
                                   ch := RollBackHor;
                                   N  := RollBackDIR;
                                   DelElement;
                               End;
                       until RollBack = False;
                       if Not RollBackFLG then
                            Begin
                                N := SetDierction(NulM,RollBack,'R');
                                cv := GetLastVer(sv);
                                ch := GetLastHor(sh);
                                RollBackFLG := False;
                            End;
                       RollBack := True;
                       NulM := False;
                   End;
         End; {.................движение в право..............................}
    Else
    End;
  until ((Forl = True) or (Iteration > 30) or (Length(TmpORL.LpCDir[0]) = 2));

  if (Iteration > 30) and (Forl = false) then
  begin
      ShowMessage ('ОРЛ для ' + TmpORL.LpC + IntToStr(TmpORL.LpN) + ' неможливо знайти.' +
                   'Перевірте вихідні данні.' +
                   'Для ' + TmpORL.LpC + IntToStr(TmpORL.LpN) + ' буде показано максимально наближена відповідь');
  end;
  except
  ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
  //KResults_Eror(Sender);
 end;
End;
{..............................................................................}

{..............................................................................}
Procedure WriteTempOrl(Rp0,Rp1,Rp3:char;
                       Rp2:Integer;
                       LpCDir,RpCDir:String;
                       FHor,FVer : Integer;
                       AddChange : Boolean);
var
    i      : Integer;
    Count  : Integer;
    zCount : Integer;
Begin
    i     := 10;
    Count := 0;
    repeat
         i := i - 1;
    Until (TmpORL.Rp1[i] <> '0') or (i = -1);

    If AddChange = True Then Count := i + 1;
    if Not AddChange Then
        Begin
            i := 10;
            repeat
                i := i - 1;
            Until (TmpORL.Rp1[i] <> '0') or (i = -1);
            If i = -1 then
                         Count := 0
                      Else Count := i;
        End;

    If Not (Rp0 = '0')  Then TmpORL.Rp0[Count] := Rp0;
    If Not (Rp1 = '0')  Then TmpORL.Rp1[Count] := Rp1;
    If Not (Rp3 = '0')  Then TmpORL.Rp3[Count] := Rp3;
    If Not (Rp2 =  0 )  Then TmpORL.Rp2[Count] := Rp2;
    If Not (FHor = 0 )  Then TmpORL.FHor[Count]:= FHor;
    If Not (FVer = 0 )  Then TmpORL.FVer[Count]:= FVer;

    If Not (LpCDir = '0') then
        Begin
            If (Length(TmpORL.LpCDir[Count]) = 1)
                Then
                   TmpORL.LpCDir[Count] := TmpORL.LpCDir[Count] + LpCDir
                Else
                   TmpORL.LpCDir[Count] := LpCDir;
        End;
    If Not (RpCDir = '0') then
        Begin
            If (Length(TmpORL.RpCDir[Count]) = 1)
                Then
                   TmpORL.RpCDir[Count] := TmpORL.RpCDir[Count] + RpCDir
                Else
                   TmpORL.RpCDir[Count] := RpCDir;
        End;
End;
{..............................................................................}

{..............................................................................}
Procedure DelElement;
var
    Count : Integer;
Begin
    Count := 10;
    Repeat
         Count := Count - 1;
    Until (TmpORL.Rp1[Count] <> '0') or (Count = -1);
    If Count = -1 then Exit Else
        Begin
            TmpORL.Rp0[Count]    := '0';
            TmpORL.Rp1[Count]    := '0';
            TmpORL.Rp2[Count]    :=  0;
            TmpORL.Rp3[Count]    := '0';
            TmpORL.RpCDir[Count] := '';
        End;
End;
{..............................................................................}

{..............................................................................}
Procedure WriteORL;
var
    Count : Integer;
    c     : Integer;
    Add   : Boolean;
Begin
    if (o > NAi + NZi - 1 ) then o := 0;
    Add := False;
        Count := 10;
        ORL[o].Lp1 := TmpORL.LpC;
        ORL[o].Lp2 := TmpORL.LpN;
        TmpORL.LpC := '0';
        TmpORL.LpN := 0;
        repeat
             repeat
                  Count := Count - 1;
             Until (TmpORL.Rp1[Count] <> '0');
             c := Count + 1;
             if Not (Add) then
                 Begin
                     SetLength(ORL[o].Rp0,c);
                     SetLength(ORL[o].Rp1,c);
                     SetLength(ORL[o].Rp2,c);
                     SetLength(ORL[o].Kompens,c);
                     Add := True;
                 End;

             if (Count <> -1) then
                Begin
                  ORL[o].Rp0[Count] := TmpORL.Rp0[Count];
                  ORL[o].Rp1[Count] := TmpORL.Rp1[Count];
                  ORL[o].Rp2[Count] := TmpORL.Rp2[Count];
                End;
             if (Count = -1) then Count := 0;

             TmpORL.Rp0[Count]    := '0';
             TmpORL.Rp1[Count]    := '0';
             TmpORL.Rp2[Count]    := 0;
             TmpORL.Rp3[Count]    := '0';
             TmpORL.RpCDir[Count] := '';
             TmpORL.LpCDir[0]     := '';
             TmpORL.FVer[Count]   := 0;
             TmpORL.FHor[Count]   := 0;

        until Count = 0;
    o := o + 1;
End;
{..............................................................................}

{..............................................................................}
function StrRoundReal(r:real; prec:byte):string;
var i:real;
begin
  i:=intpower(10, prec);
  result:=floattostr(Round(r * i) / i);
end;
{..............................................................................}

{..............................................................................
function Str2Char(Str:String; n:integer):Char;
Begin
  Str2Char:=Str[n];
End;
{..............................................................................}

{..............................................................................
function Compare(SLn:string; o:integer):boolean;
var
    i : integer;
    c : boolean;
    SLi : string;
begin
  c:=false;
  if Length(ORL[o].Rp1)<>0
  then
    for i:=0 to Length(ORL[o].Rp1)-1 do
      begin
        SLi:=ORL[o].Rp1[i]+inttostr(ORL[o].Rp2[i]);
        if (SLn=SLi) then c:=true;
      end;
  Compare:=c;
end;
{..............................................................................}

{..............................................................................}
procedure w_calc;
var
  q,o,mc:integer;
  tmpW,k_im:real;
begin
 try
  mc:=0; k_im:=0;
  case SettingsUnit.Set1.MethodCalc of   //визначення методу розрахунку >begin
    0,1:mc:=SettingsUnit.Set1.MethodCalc;
    2:case Unit_NewCalc.Mtype of
        0,1: mc:=0;
        2..4:mc:=1;
      end;
  end;

  if mc=1 then
  begin
   // k_im:=0;
    case Unit_NewCalc.Mtype of
        0,1: k_im:=1.75;
        2  : k_im:=1.2;
        3,4: k_im:=1;
    end;
  end;
                                     //визначення методу розрахунку >end
  for o:=0 to NAi+NZi do
  case ORL[o].Lp1 of
  'A':begin               //розражунок полів розсіювання для констр. розм >begin
       tmpW:=0;
       case mc of             //в залежності від методу розрах.
        0:begin                              //Макс-мін
           for q:=0 to (Length(ORL[o].Rp1))-1 do
            case ORL[o].Rp1[q] of
              'B':tmpW:=tmpW+UnitBiSet.PBi[ORL[o].Rp2[q]-1].W;
              'F':begin
                   tmpW:=tmpW+UnitFiSet.PFi[ORL[o].Rp2[q]-1].W;
                   if ORL[o].Kompens[q]=1 then
                    tmpW:=tmpW-(2*0.6*UnitFiSet.PFi[ORL[o].Rp2[q]-1].W);
                  end;
            end;
           UnitAiSet.PAi[ORL[o].Lp2-1].W:=tmpW;
          end;
        1:begin                              //імовірнісний
           for q:=0 to (Length(ORL[o].Rp1))-1 do
            case ORL[o].Rp1[q] of
              'B':tmpW:=tmpW+sqr(UnitBiSet.PBi[ORL[o].Rp2[q]-1].W);
              'F':begin
                   tmpW:=tmpW+sqr(UnitFiSet.PFi[ORL[o].Rp2[q]-1].W);
                   if ORL[o].Kompens[q]=1 then
                    tmpW:=tmpW-sqr(2*0.6*UnitFiSet.PFi[ORL[o].Rp2[q]-1].W);
                  end;
            end;
           UnitAiSet.PAi[ORL[o].Lp2-1].W:=k_im*sqrt(tmpW);
          end;
       end;            //в залежності від методу розрах.
      end;             //розражунок полів розсіювання для констр. розм >end
  'Z':begin            //розражунок полів розсіювання для припусків >begin
       tmpW:=0;
       case mc of             //в залежності від методу розрах.
        0:begin                              //Макс-мін
           for q:=0 to (Length(ORL[o].Rp1))-1 do
            case ORL[o].Rp1[q] of
              'B':tmpW:=tmpW+UnitBiSet.PBi[ORL[o].Rp2[q]-1].W;
              'F':begin
                   tmpW:=tmpW+UnitFiSet.PFi[ORL[o].Rp2[q]-1].W;
                   if ORL[o].Kompens[q]>0 then
                    tmpW:=tmpW-(2*0.6*UnitFiSet.PFi[ORL[o].Rp2[q]-1].W);
                  end;
            end;
           UnitZiSet.PZi[ORL[o].Lp2-1].W:=tmpW;
          end;
        1:begin                              //імовірнісний
           for q:=0 to (Length(ORL[o].Rp1))-1 do
            case ORL[o].Rp1[q] of
              'B':tmpW:=tmpW+sqr(UnitBiSet.PBi[ORL[o].Rp2[q]-1].W);
              'F':begin
                   tmpW:=tmpW+sqr(UnitFiSet.PFi[ORL[o].Rp2[q]-1].W);
                   if ORL[o].Kompens[q]>0 then
                    tmpW:=tmpW-sqr(2*0.6*UnitFiSet.PFi[ORL[o].Rp2[q]-1].W);
                  end;
            end;
           UnitZiSet.PZi[ORL[o].Lp2-1].W:=k_im*sqrt(tmpW);
          end;
       end;
      end;             //розражунок полів розсіювання для припусків >end
 end;
 tmpW:=0;
 except
 ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
 //KResults_Eror;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure Rm_calc;     //Визначення фактичних величин технологічних розмірів
var o,q,q1,qn,s,i,j,k,x:integer; tmpRm1,tmpRm2:real; mes:string;
begin
 try
k:=0;
for o:=0 to NAi-1 do begin
  case UnitAiSet.PAi[ORL[o].Lp2-1].Kind of    //розрахунок Ам факт >begin
   -1:;
    0:UnitAiSet.PAi[ORL[o].Lp2-1].Amf:=UnitAiSet.PAi[ORL[o].Lp2-1].Amin
      +(UnitAiSet.PAi[ORL[o].Lp2-1].W/2);
    1:UnitAiSet.PAi[ORL[o].Lp2-1].Amf:=UnitAiSet.PAi[ORL[o].Lp2-1].Amin
      -(UnitAiSet.PAi[ORL[o].Lp2-1].W/2);
    2: UnitAiSet.PAi[ORL[o].Lp2-1].Amf:=UnitAiSet.PAi[ORL[o].Lp2-1].Am;
  end;                                       //розрахунок Ам факт >end
if (Length(ORL[o].Rp1))=1 then begin   //для дволанкових ОРЛ >begin
  UnitFiSet.PFi[ORL[o].Rp2[0]-1].Fm:=UnitAiSet.PAi[ORL[o].Lp2-1].Amf;
  k:=k+1;
end;
end;                                     //для дволанкових ОРЛ >end
for o:=0 to Length(UnitZiSet.PZi)-1 do begin //Розрахунок середнух значень припусків
 if UnitZiSet.PZi[o].Zmin>0 then begin
  UnitZiSet.PZi[o].Zm:=UnitZiSet.PZi[o].Zmin+(UnitZiSet.PZi[o].W/2);
  UnitZiSet.PZi[o].Zmax:=UnitZiSet.PZi[o].Zmin+UnitZiSet.PZi[o].W;
 end;
end;

//для багатоланкових ОРЛ >begin
x:=0;
repeat
for s:=0 to NFi-1 do begin
 if UnitFiSet.PFi[s].Fm=0 then begin
  i:=UnitFiSet.PFi[s].NFi;
  j:=0;
  for o:=0 to NAi+Zn-2 do begin
   tmpRm1:=0;
   tmpRm2:=0;
   qn:=0;
   for q:=0 to Length(ORL[o].Rp1)-1 do
    if (ORL[o].Rp1[q]='F') and ((ORL[o].Rp2[q]=i)) and (findORL(o,q)=true) then
    begin
     j:=1;
     qn:=q;
    end;
   if j=1 then begin
    k:=k+1;
    case ORL[o].Lp1 of
     'A':tmpRm1:=UnitAiSet.PAi[ORL[o].Lp2-1].Amf;
     'Z':tmpRm1:=UnitZiSet.PZi[ORL[o].Lp2-1].Zm;
    end;
    for q:=0 to Length(ORL[o].Rp1)-1 do
     if q<>qn then
     case ORL[o].Rp1[q] of
     'F':if ORL[o].Rp0[q]='+' then
         tmpRm2:=tmpRm2+UnitFiSet.PFi[ORL[o].Rp2[q]-1].Fm else
         tmpRm2:=tmpRm2-UnitFiSet.PFi[ORL[o].Rp2[q]-1].Fm;
     'B':if ORL[o].Rp0[q]='+' then
         tmpRm2:=tmpRm2+UnitBiSet.PBi[ORL[o].Rp2[q]-1].Bm else
         tmpRm2:=tmpRm2-UnitBiSet.PBi[ORL[o].Rp2[q]-1].Bm;
     end;
    if ORL[o].Rp0[qn]='-' then
     UnitFiSet.PFi[ORL[o].Rp2[qn]-1].Fm:=tmpRm2-tmpRm1 else
     UnitFiSet.PFi[ORL[o].Rp2[qn]-1].Fm:=tmpRm1-tmpRm2;
    break;
   end;
  end;
 end;
end;

for s:=0 to NBi-1 do begin
 if UnitBiSet.PBi[s].Bm=0 then begin
  i:=UnitBiSet.PBi[s].NBi;
  j:=0;
  for o:=0 to NAi+Zn-2 do begin
   tmpRm1:=0;
   tmpRm2:=0;
   qn:=0;
   for q:=0 to Length(ORL[o].Rp1)-1 do
    if (ORL[o].Rp1[q]='B') and ((ORL[o].Rp2[q]=i)) and (findORL(o,q)=true) then
    begin
     j:=1;
     qn:=q;
    end;
   if j=1 then begin
    k:=k+1;
    case ORL[o].Lp1 of
     'A':tmpRm1:=UnitAiSet.PAi[ORL[o].Lp2-1].Amf;
     'Z':tmpRm1:=UnitZiSet.PZi[ORL[o].Lp2-1].Zm;
    end;
    for q:=0 to Length(ORL[o].Rp1)-1 do
     if q<>qn then
     case ORL[o].Rp1[q] of
     'F':if ORL[o].Rp0[q]='+' then
         tmpRm2:=tmpRm2+UnitFiSet.PFi[ORL[o].Rp2[q]-1].Fm else
         tmpRm2:=tmpRm2-UnitFiSet.PFi[ORL[o].Rp2[q]-1].Fm;
     'B':if ORL[o].Rp0[q]='+' then
         tmpRm2:=tmpRm2+UnitBiSet.PBi[ORL[o].Rp2[q]-1].Bm else
         tmpRm2:=tmpRm2-UnitBiSet.PBi[ORL[o].Rp2[q]-1].Bm;
     end;
    if ORL[o].Rp0[qn]='-' then
     UnitBiSet.PBi[ORL[o].Rp2[qn]-1].Bm:=tmpRm2-tmpRm1 else
     UnitBiSet.PBi[ORL[o].Rp2[qn]-1].Bm:=tmpRm1-tmpRm2;
    break;
   end;
  end;
 end;
end;
x:=x+1;
until (k=NBi+NFi) or (x>10000);  //}

for s:=0 to NFi-1 do begin   //розрахунок допусків ТР
 if UnitFiSet.PFi[s].Fm>0 then begin
  UnitFiSet.PFi[s].Fmax:=UnitFiSet.PFi[s].Fm+(UnitFiSet.PFi[s].W/2);
  UnitFiSet.PFi[s].Fmin:=UnitFiSet.PFi[s].Fm-(UnitFiSet.PFi[s].W/2);
  case UnitFiSet.PFi[s].Kind of
   -1:;
    0:begin
       UnitFiSet.PFi[s].ES:=0;
       UnitFiSet.PFi[s].EI:=-UnitFiSet.PFi[s].W;
      end;
    1:begin
       UnitFiSet.PFi[s].ES:=UnitFiSet.PFi[s].W;
       UnitFiSet.PFi[s].EI:=0;
      end;
    2:begin
       UnitFiSet.PFi[s].ES:=UnitFiSet.PFi[s].W/2;
       UnitFiSet.PFi[s].EI:=-UnitFiSet.PFi[s].W/2;
      end;
  end;
  UnitFiSet.PFi[s].Em:=(UnitFiSet.PFi[s].ES+UnitFiSet.PFi[s].EI)/2;
  UnitFiSet.PFi[s].Size:=UnitFiSet.PFi[s].Fmax-UnitFiSet.PFi[s].ES;
 end;
end;                          //розрахунок допусків ТР

for s:=0 to NBi-1 do begin   //розрахунок допусків ТР
 if UnitBiSet.PBi[s].Bm>0 then begin
  UnitBiSet.PBi[s].Bmax:=UnitBiSet.PBi[s].Bm+(UnitBiSet.PBi[s].W/2);
  UnitBiSet.PBi[s].Bmin:=UnitBiSet.PBi[s].Bm-(UnitBiSet.PBi[s].W/2);
  UnitBiSet.PBi[s].Size:=UnitBiSet.PBi[s].Bmax-UnitBiSet.PBi[s].ES;
 end;
end;                          //розрахунок допусків ТР
//для багатоланкових ОРЛ >end  }
 except
 ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
  //KResults_Eror;
 end;
end;
{..............................................................................}

{..............................................................................}
function findORL(o,x:integer):boolean;//Функція, що визначає к-сть невідомих в ОРЛ
var q1,ans:integer;
begin
findORL:=false;
ans:=0;
case ORL[o].Lp1 of
 'A':if UnitAiSet.PAi[ORL[o].Lp2-1].Amf=0 then ans:=ans+1;
 'Z':if UnitZiSet.PZi[ORL[o].Lp2-1].Zm=0 then ans:=ans+1;
end;
for q1:=0 to Length(ORL[o].Rp1)-1 do
 case ORL[o].Rp1[q1] of
  'F':if UnitFiSet.PFi[ORL[o].Rp2[q1]-1].Fm=0 then ans:=ans+1;
  'B':if UnitBiSet.PBi[ORL[o].Rp2[q1]-1].Bm=0 then ans:=ans+1;
 end;
if ans=1 then findORL:=true;
q1:=0;
end;                                  //Функція, що визначає к-сть невідомих в ОРЛ
{..............................................................................}

{..............................................................................
procedure fill_matrix;
var
    i,j,a:integer;
    c,d,k:integer;
    t:string;
begin
    Dname:=MainUnit.Dname;
    NZag:=MainUnit.NZag;
    NDet:=MainUnit.NDet;
    NBi:=MainUnit.NBi;
    NAi:=MainUnit.NAi;
    NFi:=MainUnit.NFi;

    zn:=0;
    for a:=0 to NDet-1 do
    begin
      Zn:=Zn+MainUnit.POb[a].Ob;
    end;

    Npov:=NDet+Zn;       //Заповнення масиву кодованих назв поверхонь
    SetLength(Pov,NPov);
    k:=0;

    for c:=0 to (NDet-1) do
    begin
      if MainUnit.POb[c].Ob=0 then
        begin
          t:=inttostr(c+1)+'.0';
          Pov[k]:=t;
          k:=k+1;
        end
        else
        begin
          t:=inttostr(c+1)+'.0';
          Pov[k]:=t;
          k:=k+1;
          for d:=1 to MainUnit.POb[c].Ob do
            begin
              if d<>MainUnit.POb[c].Ob then
                begin
                  t:=inttostr(c+1)+'.'+inttostr(d);
                  Pov[k]:=t;
                  k:=k+1;
                end
                else
                begin
                  t:=inttostr(c+1)+'.'+inttostr(d)+'f';
                  Pov[k]:=t;
                  k:=k+1;
                end;
            end;
        end;
    end;               //Заповнення масиву кодованих назв поверхонь

  SetLength(Matrix,NPov,NPov);   //Заповнення маприці розм. зв'язків
  for i:=0 to Npov-1 do
    for j:=0 to Npov-1 do
      begin
        Matrix[i,j].Names:='0';
        Matrix[i,j].index:=0;
      end;

{запис розм. заготовки
  for i:=0 to NBi-1 do
    begin
      h0:=-1;
      v0:=-1;
      a:=i+1;
      j:=-1;

      repeat
          j:=j+1;
      until (MainUnit.PBi[i].N1=Pov[j]) or (j>(Npov-1));
      if j<Npov then h0:=j;

      j:=-1;
      repeat
          j:=j+1;
      until (MainUnit.PBi[i].N2=Pov[j]) or (j>(Npov-1));
      if j<Npov then v0:=j;

      if (h0>=0) and (v0>=0) then
        begin
          Matrix[h0,v0].Names:='B';
          Matrix[h0,v0].index:=a;
          Matrix[v0,h0].Names:='B';
          Matrix[v0,h0].index:=a;
        end;
    end;
{запис розм. заготовки}

{запис технологічних розм.
  for i:=0 to NFi-1 do
    begin
      h0:=-1;
      v0:=-1;
      a:=i+1;

      j:=-1;
      repeat
          j:=j+1;
      until (MainUnit.PFi[i].N1=Pov[j]) or (j>(Npov-1));
      if j<Npov then h0:=j;

      j:=-1;
      repeat
          j:=j+1;
      until (MainUnit.PFi[i].N2=Pov[j]) or (j>(Npov-1));
      if j<Npov then v0:=j;

      if (h0>=0) and (v0>=0) then
        begin
          Matrix[h0,v0].Names:='F';
          Matrix[h0,v0].index:=a;
          Matrix[v0,h0].Names:='F';
          Matrix[v0,h0].index:=a;
        end;
    end;
{запис технологічних розм.
end;

{..............................................................................
procedure Fi_oper;
var s,i:integer;
begin
 for s:=0 to Length(UnitFiSet.PFi)-1 do
  for i:=0 to Length(UnitTB.PTB)-1 do begin
   if (UnitFiSet.PFi[s].N1=UnitTB.PTB[i].OX) then UnitFiSet.PFi[s].Oper:=i+1;
   if (UnitFiSet.PFi[s].N2=UnitTB.PTB[i].OX) then UnitFiSet.PFi[s].Oper:=i+1;
  end;
end;
{..............................................................................}

{..............................................................................}
procedure kompens;  // визначення ланок, що взаємокомпенсуються
var
   o,q,i:integer;
   k:boolean;
begin
 try
 k:=false;
 for o:=0 to Length(ORL)-1 do begin    // для всіх ОРЛ
  if Length(ORL[o].Rp1)>1 then   // Якщо ОРЛ - багатоланковий
   case ORL[o].Lp1 of
    'A':begin
         for q:=0 to Length(ORL[o].Rp1)-1 do
          if ORL[o].Rp0[q]='-' then begin       //Якшо знайдена зменшуюча ланка
           for i:=0 to Length(ORL[o].Rp1)-1 do
            if (ORL[o].Rp0[i]='+') and (CheckPov(o,q,i,0)=true)
            and (UnitFiSet.PFi[ORL[o].Rp2[i]-1].Oper=UnitFiSet.PFi[ORL[o].Rp2[q]-1].Oper) then
            if (UnitFiSet.PFi[ORL[o].Rp2[i]-1].W>UnitFiSet.PFi[ORL[o].Rp2[q]-1].W)
            then ORL[o].Kompens[q]:=1 else ORL[o].Kompens[i]:=1;
          end;
        end;
    'Z':begin
         //k:=false;
         for q:=0 to Length(ORL[o].Rp1)-1 do begin
          if (ORL[o].Rp0[q]='-') then begin    //Якшо знайдена зменшуюча ланка
           case ORL[o].Rp1[q] of
            'F':begin
                 for i:=0 to Length(ORL[o].Rp1)-1 do begin
                  if (ORL[o].Rp0[i]='+') and (ORL[o].Rp1[i]='F') and (CheckPov(o,q,i,0)=true)
                      and (UnitFiSet.PFi[ORL[o].Rp2[i]-1].Oper<>UnitFiSet.PFi[ORL[o].Rp2[q]-1].Oper) then
                   if (UnitFiSet.PFi[ORL[o].Rp2[i]-1].W>UnitFiSet.PFi[ORL[o].Rp2[q]-1].W)
                    then begin
                     ORL[o].Kompens[q]:=1;
                     k:=true;                 //є компенсація
                    end else begin
                     ORL[o].Kompens[i]:=1;
                     k:=true;                 //є компенсація
                    end;
                  if (ORL[o].Rp0[i]='+') and (ORL[o].Rp1[i]='B') and (CheckPov(o,q,i,1)=true) then
                   if (UnitBiSet.PBi[ORL[o].Rp2[i]-1].W>UnitFiSet.PFi[ORL[o].Rp2[q]-1].W)
                    then begin
                     ORL[o].Kompens[q]:=1;
                     k:=true;                  //є компенсація
                    end else begin
                     ORL[o].Kompens[i]:=1;
                     k:=true;                  //є компенсація
                    end;
                 end;
                end;
            'B':for i:=0 to Length(ORL[o].Rp1)-1 do
                 if (ORL[o].Rp0[i]='+') and (ORL[o].Rp1[i]='F') and (CheckPov(o,q,i,2)=true)
                     and (UnitFiSet.PFi[ORL[o].Rp2[i]-1].Oper<>UnitFiSet.PFi[ORL[o].Rp2[q]-1].Oper) then
                  if (UnitFiSet.PFi[ORL[o].Rp2[i]-1].W>UnitFiSet.PFi[ORL[o].Rp2[q]-1].W)
                  then begin
                   ORL[o].Kompens[q]:=1;
                   k:=true;                  //є компенсація
                  end else begin
                   ORL[o].Kompens[i]:=1;
                   k:=true;                  //є компенсація
                  end;
           end;
          end;
         end;
        end;
   end;
   if (ORL[o].Lp1='Z') and (k=false) then //якщо компенсацію не було виявл. для Z
   for q:=0 to Length(ORL[o].Rp1)-1 do
   if (ORL[o].Rp1[q]='F') and (CheckPov(o,q,0,3)=true) then ORL[o].Kompens[q]:=2;
 end;
 except
    ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
  //KResults_Eror;
 end;
end;
{..............................................................................}

{..............................................................................}
function CheckPov(orl_,l1,l2,t:integer):boolean;  //визначення чи є спільні поверхні
var C,p1,p2:boolean; tb1,b1,b2,f1,f2,z1,z2:string;
begin
 C:=false;
 p1:=false;
 p2:=false;
 if t=0 then    //обидва технолог. розм.
  if (UnitTB.PTB[UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].Oper-1].OX=
  UnitTB.PTB[UnitFiSet.PFi[ORL[orl_].Rp2[l2]-1].Oper-1].OX) then begin
  tb1:=UnitTB.PTB[UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].Oper-1].OX;

  if (UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].N1=tb1) or
     (UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].N2=tb1) then p1:=true;

  if (UnitFiSet.PFi[ORL[orl_].Rp2[l2]-1].N1=tb1) or
     (UnitFiSet.PFi[ORL[orl_].Rp2[l2]-1].N2=tb1) then p2:=true;

  if p1 and p2 then C:=true;
 end;
 if t=1 then begin    //другий розм -заготовки
  f1:=UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].N1;
  f2:=UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].N2;
  b1:=UnitBiSet.PBi[ORL[orl_].Rp2[l2]-1].N1;
  b2:=UnitBiSet.PBi[ORL[orl_].Rp2[l2]-1].N2;
  if (f1=b1) or (f1=b2) or (f2=b1) or (f2=b2) then C:=true;
 end;
 if t=2 then begin    //перший розм -заготовки
  b1:=UnitBiSet.PBi[ORL[orl_].Rp2[l1]-1].N1;
  b2:=UnitBiSet.PBi[ORL[orl_].Rp2[l1]-1].N2;
  f1:=UnitFiSet.PFi[ORL[orl_].Rp2[l2]-1].N1;
  f2:=UnitFiSet.PFi[ORL[orl_].Rp2[l2]-1].N2;
  if (f1=b1) or (f1=b2) or (f2=b1) or (f2=b2) then C:=true;
 end;
 if t=3 then begin    //тыльки технологычн. розм та припуск
  tb1:=UnitTB.PTB[UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].Oper-1].OX;
  f1:=UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].N1;
  f2:=UnitFiSet.PFi[ORL[orl_].Rp2[l1]-1].N2;
  z1:=UnitZiSet.PZi[ORL[orl_].Lp2-1].N1;
  z2:=UnitZiSet.PZi[ORL[orl_].Lp2-1].N2;

  if (f1=tb1) then begin
   p1:=true; //чи заданий від бази
   if (f2=z1) or (f2=z2) then p2:=true; //чи є спільна з припуском поверхня
  end;
  if (f2=tb1) then begin
   p1:=true; //чи заданий від бази
   if (f1=z1) or (f1=z2) then p2:=true; //чи є спільна з припуском поверхня
  end;

  if p1 and p2 then C:=true;
 end;
 CheckPov:=C;
end;
{..............................................................................}

{..............................................................................}
procedure TForm12.BitBtn1Click(Sender: TObject);
var
    ct,cl,i,j,f,a,o,s,i9,j9,n,n1,p,q,ko,ko1,des,Nsl,y : integer;
   // tmp_f : TStrings;
    r : pchar;
    ORLi : string;
    Sym : char;
    SL : integer;
begin
 try
 BitBtn3Click(Sender);
    if Mainunit.m1=true then
        begin
            Form12.Visible:=false;
            Mainunit.m1:=false;
        end
        else
        begin

            SetLength(ORL,NDet+NZi);
            for i:=0 to NDet+NZi-1 do
                begin
                    SetLength(ORL[i].chain1,0);
                    SetLength(ORL[i].chain2,0);
                    SetLength(ORL[i].chain3,0);
                    SetLength(ORL[i].Rp0,0);
                    SetLength(ORL[i].Rp1,0);
                    SetLength(ORL[i].Rp2,0);
                    SetLength(ORL[i].Kompens,0);
                end;
            MainUnit.Form1.ToolButton_Ai.Enabled:=true;
            MainUnit.Form1.ToolButton_Bi.Enabled:=true;
            MainUnit.Form1.ToolButton_Fi.Enabled:=true;
            MainUnit.Form1.ToolButton_Zi.Enabled:=true;
            MainUnit.Form1.ToolButton_TB.Enabled:=true;
            MainUnit.Form1.Ai_ch.Enabled:=true;
            MainUnit.Form1.Bi_ch.Enabled:=true;
            MainUnit.Form1.Fi_ch.Enabled:=true;
            MainUnit.Form1.Zi_ch.Enabled:=true;
            MainUnit.Form1.TB_ch.Enabled:=true;
            MainUnit.Form1.N_refresh.Enabled:=true;
{-------------формування ОРЛ для припусків - start----------------}
        GetORL;
{-------------формування ОРЛ для припусків - finish---------------}
        if Set1.Kompens1=true then kompens;
{------------ запис ОРЛ - start--------------}
        for o:=0 to NAi+NZi do
            begin
                case ORL[o].Lp1 of
                  'A' : begin
                        ORL[o].chain1:='['+ORL[o].Lp1+inttostr(ORL[o].Lp2)+'] = ';
                        ORL[o].chain2:='('+UnitAiSet.PAi[ORL[o].Lp2-1].N1+'-'
                              +UnitAiSet.PAi[ORL[o].Lp2-1].N2+') = ';
                        ORL[o].chain3:='[ω'+ORL[o].Lp1+inttostr(ORL[o].Lp2)+'] = ';
                        end;
                  'Z' : begin
                        if UnitZiSet.PZi[ORL[o].Lp2-1].Kind=1 then
                            ORL[o].chain1:='['+UnitZiSet.PZi[ORL[o].Lp2-1].Name+'*] = '
                            else
                            ORL[o].chain1:='['+UnitZiSet.PZi[ORL[o].Lp2-1].Name+'] = ';
                        ORL[o].chain2:='('+UnitZiSet.PZi[ORL[o].Lp2-1].N1+'-'
                            +UnitZiSet.PZi[ORL[o].Lp2-1].N2+') = ';
                        if UnitZiSet.PZi[ORL[o].Lp2-1].Kind=1 then
                            ORL[o].chain3:='[ω'+UnitZiSet.PZi[ORL[o].Lp2-1].Name+'*] = '
                            else
                            ORL[o].chain3:='[ω'+UnitZiSet.PZi[ORL[o].Lp2-1].Name+'] = ';
                        end;
            end;
        for q:=0 to (Length(ORL[o].Rp1))-1 do
            begin
                case ORL[o].Rp1[q] of
                    'B' : begin
                          ORL[o].chain1:=ORL[o].chain1+ORL[o].Rp0[q]+ORL[o].Rp1[q]
                                +inttostr(ORL[o].Rp2[q])+' ';
                          if (ORL[o].Rp0[q]='+') or (ORL[o].Rp0[q]=' ') then
                              ORL[o].chain2:=ORL[o].chain2+ORL[o].Rp0[q]
                                    +'('+UnitBiSet.PBi[ORL[o].Rp2[q]-1].N1+'-'
                                    +UnitBiSet.PBi[ORL[o].Rp2[q]-1].N2+') '
                              else
                              ORL[o].chain2:=ORL[o].chain2+ORL[o].Rp0[q]
                                     +'('+UnitBiSet.PBi[ORL[o].Rp2[q]-1].N2+'-'
                                     +UnitBiSet.PBi[ORL[o].Rp2[q]-1].N1+') ';
                          end;
                    'F' : begin
                          ORL[o].chain1:=ORL[o].chain1+ORL[o].Rp0[q]+ORL[o].Rp1[q]
                                +inttostr(ORL[o].Rp2[q])+' ';
                          if (ORL[o].Rp0[q]='+') or (ORL[o].Rp0[q]=' ') then
                              ORL[o].chain2:=ORL[o].chain2+ORL[o].Rp0[q]
                                    +'('+UnitFiSet.PFi[ORL[o].Rp2[q]-1].N1+'-'
                                    +UnitFiSet.PFi[ORL[o].Rp2[q]-1].N2+') '
                              else
                              ORL[o].chain2:=ORL[o].chain2+ORL[o].Rp0[q]
                                    +'('+UnitFiSet.PFi[ORL[o].Rp2[q]-1].N2+'-'
                                    +UnitFiSet.PFi[ORL[o].Rp2[q]-1].N1+') ';
                          end;
            end;
        if q=0 then
            ORL[o].chain3:=ORL[o].chain3+'ω'+ORL[o].Rp1[q]
                  +inttostr(ORL[o].Rp2[q])+' '
               else
            ORL[o].chain3:=ORL[o].chain3+'+ ω'+ORL[o].Rp1[q]
                  +inttostr(ORL[o].Rp2[q])+' ';
        if (ORL[o].Kompens[q]>0) then
            ORL[o].chain3:=ORL[o].chain3+'- 2*k*ω'+ORL[o].Rp1[q]
                  +inttostr(ORL[o].Rp2[q])+' ';
       end;
     end;
{------------ запис ОРЛ - finish --------------}

    w_calc;  //розрахунок полів розсіювання

//розрахунок psi
    for s:=0 to NAi-1 do
       if (UnitAiSet.PAi[s].W<>0) and (UnitAiSet.PAi[s].T<>0) then
    UnitAiSet.PAi[s].Psi:=UnitAiSet.PAi[s].T/UnitAiSet.PAi[s].W;  //!!!!!!!!!!!! формула перещета полей розсеивания
//розрахунок psi

    Rm_calc;//Визначення розмірів

    Form12.Visible:=false;
    if MainUnit.Rw=false then
    MainUnit.Form1.Caption:='РМА ТП v4.0 - '+Dname;
    ct:=(MainUnit.Form1.Height-31-20) div 2;
    cl:=(MainUnit.Form1.Width-10);
    MainUnit.Form1.Image1.Visible:=false;

    MainUnit.Form1.StringGrid1.Visible:=true;
    MainUnit.Form1.StringGrid1.Width:=cl;
    MainUnit.Form1.StringGrid1.Height:=ct-54;

    MainUnit.Form1.StringGrid2.Visible:=true;
    MainUnit.Form1.StringGrid2.Top:=ct+8+2;
    MainUnit.Form1.StringGrid2.Height:=ct-29;
    MainUnit.Form1.StringGrid2.Width:=cl;

    MainUnit.Form1.Label1.Visible:=true;
    MainUnit.Form1.Label2.Visible:=true;
    MainUnit.Form1.Label2.Top:=ct-7;

{------ Заповнення таблиць результатів ------}

    MainUnit.Form1.StringGrid1.Refresh;
    MainUnit.Form1.StringGrid2.Refresh;

    MainUnit.Form1.StringGrid1.ColCount:=4;
    MainUnit.Form1.StringGrid1.RowCount:=NDet+NZi;
    MainUnit.Form1.StringGrid1.Cells[0,0]:='№';
    MainUnit.Form1.StringGrid1.ColWidths[0]:=30;
    MainUnit.Form1.StringGrid1.ColWidths[1]:=300;
    MainUnit.Form1.StringGrid1.ColWidths[2]:=340;
    MainUnit.Form1.StringGrid1.ColWidths[3]:=300;
    MainUnit.Form1.StringGrid1.Cells[1,0]:='Операційні розмірні ланцюги';
    MainUnit.Form1.StringGrid1.Cells[2,0]:='Запис ОРЛ в кодовій формі';
    MainUnit.Form1.StringGrid1.Cells[3,0]:='Рівняння полів розсіювання замикаючих ланок';
    for o:=0 to NAi+NZi do
        begin
            MainUnit.Form1.StringGrid1.Cells[0,o+1]:=inttostr(o+1);
            MainUnit.Form1.StringGrid1.Cells[1,o+1]:=ORL[o].chain1;
            MainUnit.Form1.StringGrid1.Cells[2,o+1]:=ORL[o].chain2;
            MainUnit.Form1.StringGrid1.Cells[3,o+1]:=ORL[o].chain3;
        end;

    with MainUnit.Form1.StringGrid2 do
        begin
            ColCount:=17;
            RowCount:=NBi+NAi+NFi+NZi+1+3; // "3" - строки розподілу
            ColWidths[0]:=25;
            ColWidths[1]:=49;
            ColWidths[2]:=83;
            ColWidths[3]:=83;
            ColWidths[4]:=92;
            ColWidths[5]:=88;
            ColWidths[6]:=110;
            ColWidths[7]:=76;
            ColWidths[8]:=60;
            ColWidths[9]:=60;
            ColWidths[10]:=60;
            ColWidths[11]:=60;
            ColWidths[12]:=60;
            ColWidths[13]:=60;
            ColWidths[14]:=60;
            ColWidths[15]:=50;
            ColWidths[16]:=180;
            Cells[0,0]:='№';
            Cells[1,0]:='Познач.';
            Cells[2,0]:='Код розміру';
            Cells[3,0]:='Номінал, мм';
            Cells[4,0]:='Max розм., мм';
            Cells[5,0]:='Min розм., мм';
            Cells[6,0]:='Серед. розм., мм';
            Cells[7,0]:='Допуск, мм';
            Cells[8,0]:='ES, мм';
            Cells[9,0]:='EI, мм';
            Cells[10,0]:='Em, мм';
            Cells[11,0]:='ω, мм';
            Cells[12,0]:='ωек, мм';
            Cells[13,0]:='ρвб, мм';
            Cells[14,0]:='εб, мм';
            Cells[15,0]:='   ψ';
            Cells[16,0]:='Примітки';
            for i:=1 to NAi do
                begin
                    Cells[0,i]:=inttostr(i);
                    Cells[1,i]:='A'+inttostr(i);
                    Cells[2,i]:='('+UnitAiSet.PAi[i-1].N1+' - '+UnitAiSet.PAi[i-1].N2+')';
                    Cells[3,i]:=floattostr(UnitAiSet.PAi[i-1].Size);
                    Cells[4,i]:=floattostr(UnitAiSet.PAi[i-1].Amax);
                    Cells[5,i]:=floattostr(UnitAiSet.PAi[i-1].Amin);
                    Cells[6,i]:=floattostr(UnitAiSet.PAi[i-1].Am);
                    Cells[7,i]:=floattostr(UnitAiSet.PAi[i-1].T);
                    Cells[8,i]:=floattostr(UnitAiSet.PAi[i-1].ES);
                    Cells[9,i]:=floattostr(UnitAiSet.PAi[i-1].EI);
                    Cells[10,i]:=floattostr(UnitAiSet.PAi[i-1].Em);
                    Cells[11,i]:=StrRoundReal(UnitAiSet.PAi[i-1].W,2);
                    Cells[12,i]:='    -';
                    Cells[13,i]:='    -';
                    Cells[14,i]:='    -';
                    Cells[15,i]:=StrRoundReal(UnitAiSet.PAi[i-1].Psi,2);
                    if (UnitAiSet.PAi[i-1].Psi<>0) then
                        if ((UnitAiSet.PAi[i-1].Psi)<1.199999999) then
                            Cells[16,i]:='точність не забезпечується' else
                    Cells[16,i]:='точність забезпечується';
                end;
            y:=NAi+1;
            for i:=1 to NBi do
                begin
                    Cells[0,i+y]:=inttostr(i+y-1);
                    Cells[1,i+y]:='B'+inttostr(i);
                    Cells[2,i+y]:='('+UnitBiSet.PBi[i-1].N1+' - '+UnitBiSet.PBi[i-1].N2+')';
                    Cells[3,i+y]:=StrRoundReal(UnitBiSet.PBi[i-1].Size,2);
                    Cells[4,i+y]:=StrRoundReal(UnitBiSet.PBi[i-1].Bmax,2);
                    Cells[5,i+y]:=StrRoundReal(UnitBiSet.PBi[i-1].Bmin,2);
                    Cells[6,i+y]:=StrRoundReal(UnitBiSet.PBi[i-1].Bm,2);
                    Cells[7,i+y]:=floattostr(UnitBiSet.PBi[i-1].T);;
                    Cells[8,i+y]:=floattostr(UnitBiSet.PBi[i-1].ES);
                    Cells[9,i+y]:=floattostr(UnitBiSet.PBi[i-1].EI);
                    Cells[10,i+y]:=floattostr(UnitBiSet.PBi[i-1].Em);
                    Cells[11,i+y]:=StrRoundReal(UnitBiSet.PBi[i-1].W,2);;
                    Cells[12,i+y]:='    -';
                    Cells[13,i+y]:='    -';
                    Cells[14,i+y]:='    -';
                    Cells[15,i+y]:='    -';
                    Cells[16,i+y]:='';
                end;
            y:=NAi+NBi+2;
            for i:=1 to NFi do
                begin
                    Cells[0,i+y]:=inttostr(i+y-2);
                    Cells[1,i+y]:='F'+inttostr(i);
                    Cells[2,i+y]:='('+UnitFiSet.PFi[i-1].N1+' - '+UnitFiSet.PFi[i-1].N2+')';
                    Cells[3,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].Size,3);
                    Cells[4,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].Fmax,3);
                    Cells[5,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].Fmin,3);
                    Cells[6,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].Fm,3);
                    Cells[7,i+y]:=floattostr(UnitFiSet.PFi[i-1].W);
                    Cells[8,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].ES,3);
                    Cells[9,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].EI,3);
                    Cells[10,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].Em,3);
                    Cells[11,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].W,3);
                    Cells[12,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].Wek,3);
                    Cells[13,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].dRvb,3);
                    Cells[14,i+y]:=StrRoundReal(UnitFiSet.PFi[i-1].Eb,3);
                    Cells[15,i+y]:='    -';
                    Cells[16,i+y]:='Операція '+UnitTB.PTB[UnitFiSet.PFi[i-1].Oper-1].NameOper;
                end;
          y:=NAi+NBi+NFi+3;
          for i:=1 to NZi do
              begin
                  Cells[0,i+y]:=inttostr(i+y-3);
                  if UnitZiSet.PZi[i-1].Kind=0 then
                        Cells[1,i+y]:=UnitZiSet.PZi[i-1].Name
                      else
                         Cells[1,i+y]:=UnitZiSet.PZi[i-1].Name+'*';
                  Cells[2,i+y]:='('+UnitZiSet.PZi[i-1].N1+' - '+UnitZiSet.PZi[i-1].N2+')';
                  Cells[3,i+y]:='    -';
                  Cells[4,i+y]:=StrRoundReal(UnitZiSet.PZi[i-1].Zmax,2);
                  Cells[5,i+y]:=StrRoundReal(UnitZiSet.PZi[i-1].Zmin,2);
                  Cells[6,i+y]:=StrRoundReal(UnitZiSet.PZi[i-1].Zm,2);
                  Cells[7,i+y]:=StrRoundReal(UnitZiSet.PZi[i-1].W,2);
                  Cells[8,i+y]:='    -';
                  Cells[9,i+y]:='    -';
                  Cells[10,i+y]:='    -';
                  Cells[11,i+y]:=StrRoundReal(UnitZiSet.PZi[i-1].W,2);
                  Cells[12,i+y]:='    -';
                  Cells[13,i+y]:='    -';
                  Cells[14,i+y]:='    -';
                  Cells[15,i+y]:='    -';
                  Cells[16,i+y]:='';
              end;
          end;
          MainUnit.Form1.StringGrid1.Refresh;
          MainUnit.Form1.StringGrid2.Refresh;

          MainUnit.Form1.N16.Enabled:=true;
          MainUnit.Form1.ToolButton_Matrix.Enabled:=true;
          MainUnit.Form1.View1.Enabled:=true;
          MainUnit.Form1.ToolButton_Zvit.Enabled:=true;
          MainUnit.Form1.Toolbutton_ReCalc.Enabled:=true;
    end;
  //Form1.Visible:=true;
 except
   ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
  //KResults_Eror;
 end;
end;
{..............................................................................}

{..............................................................................}
procedure TForm12.BitBtn2Click(Sender: TObject);
var
  Excel:Variant;
  i,j:integer;
begin
 Excel:=CreateOleObject('Excel.Application');
 Excel.Visible:=true;
 Excel.Workbooks.add(-4167);
 Excel.Cells[1,1]:='Матриця розмірних зв''язків деталі "'+MainUnit.Dname+'"';
 for i:=0 to Npov do
  for j:=0 to Npov do begin
   if ((i=0) or (j=0)) and (i<>j) then begin
   Excel.Cells[i+3,j+1].Font.Color:=clBlue;
   Excel.Cells[i+3,j+1].Borders.item[1].Weight:=2;
   Excel.Cells[i+3,j+1].Borders.item[8].Weight:=2;
   Excel.Cells[i+3,j+1]:='|'+StringGrid1.Cells[j,i]+'|';
   end else if i=j then begin
   Excel.Cells[i+3,j+1].Interior.Color:=clGray;
   Excel.Cells[i+3,j+1].Borders.item[1].Weight:=2;
   Excel.Cells[i+3,j+1].Borders.item[5].Weight:=2;
   Excel.Cells[i+3,j+1].Borders.item[8].Weight:=2;
   end else
   Excel.Cells[i+3,j+1]:=StringGrid1.Cells[j,i];
   Excel.Cells[i+3,j+1].Borders.item[2].Weight:=2;
   Excel.Cells[i+3,j+1].Borders.item[9].Weight:=2;
  end;
end;
{..............................................................................}

{..............................................................................
procedure TForm12.KResults_Eror(Sender: TObject);
begin
   ShowMessage('Перевірте правильність введених даних');
   Form12.Close;
   Form11.Show;
end;
{..............................................................................}

{..............................................................................}
function AnsiPos(const Substr, S: string; FromPos: integer): Integer;
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
