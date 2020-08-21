object FormMain: TFormMain
  Left = 213
  Top = 130
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26426#26800#33218#30340#25805#20316
  ClientHeight = 463
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 528
    Height = 444
    Align = alClient
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 444
    Width = 528
    Height = 19
    Panels = <>
  end
  object MainMenu1: TMainMenu
    Left = 488
    Top = 16
    object MenuGame: TMenuItem
      Caption = #28216#25103
      object MenuGameCreateAll: TMenuItem
        Caption = #21019#24314#25152#26377
        OnClick = MenuGameCreateAllClick
      end
      object MenuGameDestroyAll: TMenuItem
        Caption = #38144#27585#25152#26377
        OnClick = MenuGameDestroyAllClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MenuGameFromLeftToRight: TMenuItem
        Caption = #20174#24038#21040#21491
        OnClick = MenuGameFromLeftToRightClick
      end
      object MenuGameFromRightToLeft: TMenuItem
        Caption = #20174#21491#21040#24038
        OnClick = MenuGameFromRightToLeftClick
      end
      object MenuGameAutoDecide: TMenuItem
        Caption = #33258#21160#21028#26029
        OnClick = MenuGameAutoDecideClick
      end
      object MenuGameReset: TMenuItem
        Caption = #37325#32622#36135#29289
        OnClick = MenuGameResetClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object MenuGameRun: TMenuItem
        Caption = #27491#24335#36816#34892
        OnClick = MenuGameRunClick
      end
      object MenuGameRearrange: TMenuItem
        Caption = #37325#25918#36135#29289
        OnClick = MenuGameRearrangeClick
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object MenuGameExit: TMenuItem
        Caption = #36864#20986#28216#25103
        OnClick = MenuGameExitClick
      end
    end
    object MenuArm: TMenuItem
      Caption = #26426#26800#33218
      object MenuArmCreate: TMenuItem
        Caption = #21019#24314#26426#26800#33218
        OnClick = MenuArmCreateClick
      end
      object MenuArmDestroy: TMenuItem
        Caption = #38144#27585#26426#26800#33218
        OnClick = MenuArmDestroyClick
      end
    end
    object MenuProduct: TMenuItem
      Caption = #36135#29289
      object MenuProductCreate: TMenuItem
        Caption = #21019#24314#36135#29289
        OnClick = MenuProductCreateClick
      end
      object MenuProductDestroy: TMenuItem
        Caption = #38144#27585#36135#29289
        OnClick = MenuProductDestroyClick
      end
    end
    object MenuHelp: TMenuItem
      Caption = #24110#21161
      object MenuHelpAbout: TMenuItem
        Caption = #20851#20110
        OnClick = MenuHelpAboutClick
      end
    end
  end
end
