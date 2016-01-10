object Form11: TForm11
  Left = 522
  Top = 380
  BorderIcons = []
  Caption = #1030#1085#1092#1086#1088#1084#1072#1094#1110#1103' '#1087#1088#1086' '#1090#1077#1093#1085#1086#1083#1086#1075#1110#1095#1085#1110' '#1086#1087#1077#1088#1072#1094#1110#1111
  ClientHeight = 286
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 342
    Top = 255
    Width = 91
    Height = 25
    Hint = #1047#1072#1074#1077#1088#1096#1080#1090#1080' '#1074#1074#1077#1076#1077#1085#1085#1103' '#1076#1072#1085#1080#1093' '#1110' '#1087#1088#1086#1074#1077#1089#1090#1080' '#1088#1086#1079#1088#1072#1093#1091#1085#1086#1082
    Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1080
    DoubleBuffered = True
    Layout = blGlyphRight
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 262
    Top = 255
    Width = 75
    Height = 25
    Hint = #1055#1086#1074#1077#1088#1085#1091#1090#1080#1089#1100' '#1085#1072' '#1087#1086#1087#1077#1088#1077#1076#1085#1102' '#1092#1086#1088#1084#1091
    Caption = #1053#1072#1079#1072#1076
    DoubleBuffered = True
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object TabControl1: TTabControl
    Left = 8
    Top = 8
    Width = 425
    Height = 241
    TabOrder = 2
    OnChange = TabControl1Change
    object Bevel1: TBevel
      Left = 8
      Top = 59
      Width = 409
      Height = 46
    end
    object Label1: TLabel
      Left = 16
      Top = 75
      Width = 215
      Height = 13
      Caption = #1055#1086#1074#1077#1088#1093#1085#1103', '#1097#1086' '#1108'  '#1058#1041'  '#1074' '#1086#1073#1088#1072#1085#1086#1084#1091' '#1085#1072#1087#1088#1103#1084#1082#1091
    end
    object Label3: TLabel
      Left = 16
      Top = 40
      Width = 32
      Height = 13
      Caption = 'Label3'
    end
    object Label2: TLabel
      Left = 16
      Top = 111
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object ComboBox1: TComboBox
      Left = 304
      Top = 72
      Width = 89
      Height = 21
      Hint = #1054#1073#1077#1088#1110#1090#1100' '#1087#1086#1074#1077#1088#1093#1085#1102' '#1073#1072#1079#1080
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object CheckListBox1: TCheckListBox
      Left = 48
      Top = 128
      Width = 329
      Height = 97
      Hint = #1054#1073#1077#1088#1110#1090#1100' '#1090#1077#1093#1085#1086#1083#1086#1075#1110#1095#1085#1110' '#1088#1086#1079#1084#1110#1088#1080', '#1097#1086' '#1091#1090#1074#1086#1088#1102#1102#1090#1100#1089#1103' '#1085#1072' '#1076#1072#1085#1110#1081' '#1086#1087#1077#1088#1072#1094#1110#1111
      Columns = 6
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = CheckListBox1Click
    end
  end
end
