unit u_Word_Excel;      //��������� ������� �� ����� � MS Word

interface

uses
  ComObj;

var
  W:variant;
  Function CreateWord:boolean; //�������� �� ������������ MS Word
  Function VisibleWord (visible:boolean):boolean; //������ MS Word
  Function AddDoc:boolean; //��������� ��������� MS Word
  Function SetTextToDoc(text_: string;InsertAfter_: boolean): boolean;//����� ������ � �������� MS Word
  Function SaveDocAs(file_:string):boolean; //���������� ��������� MS Word
  Function CloseDoc:boolean; //�������� ��������� ��������� MS Word
  Function CloseWord:boolean; //�������� MS Word
  Function OpenDoc (file_:string):boolean; //�������� ��������� MS Word
  Function StartOfDoc:boolean; //����������� ������� �� ������� ��������� MS Word
  Function FindTextDoc (text_:string):boolean; //����������� � �������� ������ � �������� MS Word
  Function PasteTextDoc (text_:string):boolean; //������� ������ ���� ������� ��� ������ �������� MS Word
  Function FindAndPasteTextDoc
 (findtext_,pastetext_:string): boolean; //����� + ������� ������ ���������� ������ MS Word
  Function PrintDialogWord:boolean; //���� ��������� MS Word
  Function CreateTable(NumRows, NumColumns:integer;
  var index:integer):boolean; //��������� ������� � MS Word
  Function SetSizeTable(Table:integer; RowsHeight,
  ColumnsWidth:real):boolean; //������ ������� � MS Word
  Function SetHeightRowTable(Table,Row:integer;
  RowHeight:real):boolean; //�������  ������ ������ ������� � MS Word
  Function SetWidthColumnTable(Table,Column: integer;
  ColumnWidth:real):boolean; //������� ������ ������� ������� � MS Word
  Function GetSizeTable(Table:integer;var RowsHeight,
  ColumnsWidth: real):boolean; //���������� ������ ������ �� ������ ������� ������� � MS Word
  Function SetTextToTable(Table:integer;Row, Column:integer;
  text:string):boolean; //����� ������ � ������� MS Word
  Function SetMergeCellsTable(Table:integer;
  Row1,Column1,Row2,Column2:integer):boolean; //�������� ������ � MS Word

implementation

Function CreateWord:boolean;
begin
 CreateWord:=true;
 try
 W:=CreateOleObject('Word.Application');
 except
 CreateWord:=false;
 end;
End;

Function VisibleWord (visible:boolean):boolean;
begin
 VisibleWord:=true;
 try
 W.visible:= visible;
 except
 VisibleWord:=false;
 end;
End;

Function AddDoc:boolean;
Var Doc_:variant;
begin
 AddDoc:=true;
 try
 Doc_:=W.Documents;
 Doc_.Add;
 except
 AddDoc:=false;
 end;
End;

Function SetTextToDoc(text_:string;InsertAfter_:boolean):boolean;
var Rng_:variant;
begin
 SetTextToDoc:=true;
 try
 Rng_:=W.ActiveDocument.Range;
 if InsertAfter_
  then Rng_.InsertAfter(text_)
  else Rng_.InsertBefore(text_);
 except
 SetTextToDoc:=false;
 end;
End;

Function SaveDocAs(file_:string):boolean;
begin
 SaveDocAs:=true;
 try
 W.ActiveDocument.SaveAs(file_);
 except
 SaveDocAs:=false;
 end;
End;

Function CloseDoc:boolean;
begin
 CloseDoc:=true;
 try
 W.ActiveDocument.Close;
 except
 CloseDoc:=false;
 end;
End;

Function CloseWord:boolean;
begin
 CloseWord:=true;
 try
 W.Quit;
 except
 CloseWord:=false;
 end;
End;

Function OpenDoc (file_:string):boolean;
 Var Doc_:variant;
begin
 OpenDoc:=true;
 try
  Doc_:=W.Documents;
  Doc_.Open(file_);
 except
  OpenDoc:=false;
 end;
End;

Function StartOfDoc:boolean;
begin
 StartOfDoc:=true;
 try
  W.Selection.End:=0;
  W.Selection.Start:=0;
 except
  StartOfDoc:=false;
 end;
End;

Function FindTextDoc (text_:string):boolean;
begin
// FindTextDoc:=true;
 Try
  W.Selection.Find.Forward:=true;
  W.Selection.Find.Text:=text_;
  FindTextDoc := W.Selection.Find.Execute;
 except
  FindTextDoc:=false;
 end;
End;

Function PasteTextDoc (text_:string):boolean;
begin
 PasteTextDoc:=true;
 Try
  W.Selection.Delete;
  W.Selection.InsertAfter (text_);
 except
  PasteTextDoc:=false;
 end;
End;

Function FindAndPasteTextDoc
 (findtext_,pastetext_:string): boolean;
begin
 FindAndPasteTextDoc:=true;
 try
  W.Selection.Find.Forward:=true;
  W.Selection.Find.Text:= findtext_;
  if W.Selection.Find.Execute then begin
   W.Selection.Delete;
   W.Selection.InsertAfter (pastetext_);
  end else FindAndPasteTextDoc:=false;
 except
  FindAndPasteTextDoc:=false;
 end;
End;

Function PrintDialogWord:boolean;
 Const wdDialogFilePrint=88;
begin
 PrintDialogWord:=true;
 try
  W.Dialogs.Item(wdDialogFilePrint).Show;
 except
  PrintDialogWord:=false;
 end;
End;

Function CreateTable(NumRows, NumColumns:integer;
  var index:integer):boolean;
 var sel_, Range:variant;
begin
 CreateTable:=true;
 try
  sel_:=W.selection;
  W.ActiveDocument.Tables.Add (Range:=sel_.Range,NumRows:=NumRows,NumColumns:=NumColumns);
  index:=W.ActiveDocument. Tables.Count;
 except
  CreateTable:=false;
 end;
End;

Function SetSizeTable(Table:integer; RowsHeight,
  ColumnsWidth:real):boolean;
begin
 SetSizeTable:=true;
 try
  W.ActiveDocument.Tables.Item (Table).Columns.Width:=ColumnsWidth;
  W.ActiveDocument.Tables.Item(Table). Rows.Height:=RowsHeight;
 except
  SetSizeTable:=false;
 end;
End;

Function SetHeightRowTable(Table,Row:integer;
  RowHeight:real):boolean;
begin
 SetHeightRowTable:=true;
 try
  W.ActiveDocument.Tables.Item(Table).Rows.item(Row).Height:=RowHeight;
 except
  SetHeightRowTable:=false;
 end;
End;

Function SetWidthColumnTable(Table,Column: integer;
  ColumnWidth:real):boolean;
begin
 SetWidthColumnTable:=true;
 try
  W.ActiveDocument.Tables.Item(Table).Columns.
   Item(Column).Width:=ColumnWidth;
 except
  SetWidthColumnTable:=false;
 end;
End;

Function GetSizeTable(Table:integer;var RowsHeight,
  ColumnsWidth: real):boolean;
begin
 GetSizeTable:=true;
 try
  ColumnsWidth:=W.ActiveDocument. Tables.Item(Table).Columns.Width;
  RowsHeight:=W.ActiveDocument. Tables.Item(Table).Rows.Height;
 except
  GetSizeTable:=false;
 end;
End;

Function SetTextToTable(Table:integer;Row, Column:integer;
  text:string):boolean;
begin
 SetTextToTable:=true;
 try
  W.ActiveDocument.Tables.Item(Table).Columns.Item(Column).
   Cells.Item(Row).Range.Text:=text;
 except
  SetTextToTable:=false;
 end;
End;

Function SetMergeCellsTable(Table:integer;
          Row1,Column1,Row2,Column2:integer):boolean;
 var Cel:variant;
begin
 SetMergeCellsTable:=true;
 try
  Cel:=W.ActiveDocument.Tables.Item(Table).Cell(Row2,Column2);
  W.ActiveDocument.Tables.Item(Table). Cell(Row1,Column1).Merge(Cel);
 except
  SetMergeCellsTable:=false;
 end;
End;

end.
