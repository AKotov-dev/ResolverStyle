unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ComCtrls, ExtCtrls, AsyncProcess, FileUtil, DefaultTranslator;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label7: TLabel;
    MageiaStyle: TAsyncProcess;
    ROSAStyle: TAsyncProcess;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    SNetworkd: TProcess;
    SResolved: TProcess;
    MageiaBTN: TSpeedButton;
    ROSABtn: TSpeedButton;
    StaticText1: TStaticText;
    ResolvConfTimer: TTimer;
    SResolvedTimer: TTimer;
    SNetworkdTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ResolvConfTimerTimer(Sender: TObject);
    procedure SNetworkdTimerTimer(Sender: TObject);
    procedure MageiaBTNClick(Sender: TObject);
    procedure ROSABtnClick(Sender: TObject);
    procedure SResolvedTimerTimer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ResolvConfTimerTimer(Sender: TObject);
begin
  if FileExists('/etc/resolv.conf') then
  begin
    Memo1.Lines.LoadFromFile('/etc/resolv.conf');
    Memo1.SelStart := Length(Memo1.Text);
  end
  else
    Memo1.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption := Application.Title;
  SetCurrentDir(ExtractFileDir(Application.ExeName));
end;

//Статус systemd-networkd
procedure TForm1.SNetworkdTimerTimer(Sender: TObject);
var
  S: TStringList;
begin
  try
    S := TStringList.Create;
    SNetworkd.Execute;
    S.LoadFromStream(SNetworkd.Output);
    if S[0] = 'active' then
    begin
      Label6.Font.Color := clRed;
      Label6.Caption := 'on';
    end
    else
    begin
      Label6.Font.Color := clGreen;
      Label6.Caption := 'off';
    end;
  finally
    S.Free;
  end;
end;

//Apply Mageia Style
procedure TForm1.MageiaBTNClick(Sender: TObject);
begin
  MageiaStyle.Execute;
end;

//Apply ROSA Style
procedure TForm1.ROSABtnClick(Sender: TObject);
begin
  RosaStyle.Execute;
end;

//Статус systemd-resolved
procedure TForm1.SResolvedTimerTimer(Sender: TObject);
var
  S: TStringList;
begin
  try
    S := TStringList.Create;
    SResolved.Execute;
    S.LoadFromStream(SResolved.Output);
    if S[0] = 'active' then
    begin
      Label4.Font.Color := clRed;
      Label4.Caption := 'on';
    end
    else
    begin
      Label4.Font.Color := clGreen;
      Label4.Caption := 'off';
    end;
  finally
    S.Free;
  end;
end;

end.
