program MyBrowser;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainWin in 'MainWin.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
