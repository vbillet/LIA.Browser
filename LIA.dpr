program LIA;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'src\MainForm.pas' {NavMainForm},
  Androidapi.JNI.SGWebClient in 'Lib\SGWeb\Androidapi.JNI.SGWebClient.pas',
  SG.ScriptGate.Android in 'Lib\SGWeb\SG.ScriptGate.Android.pas',
  SG.ScriptGate.Android.SGWebClientBridge in 'Lib\SGWeb\SG.ScriptGate.Android.SGWebClientBridge.pas',
  SG.ScriptGate.iOS in 'Lib\SGWeb\SG.ScriptGate.iOS.pas',
  SG.ScriptGate.Mac in 'Lib\SGWeb\SG.ScriptGate.Mac.pas',
  SG.ScriptGate in 'Lib\SGWeb\SG.ScriptGate.pas',
  SG.ScriptGate.Win in 'Lib\SGWeb\SG.ScriptGate.Win.pas',
  SG.ScriptGateLog in 'Lib\SGWeb\SG.ScriptGateLog.pas',
  SG.WebBrowserHelper in 'Lib\SGWeb\SG.WebBrowserHelper.pas',
  Plateform in 'src\Plateform\Plateform.pas',
  FileSystem in 'src\Plateform\FileSystem.pas',
  FileSystem.Android in 'src\Plateform\Android\FileSystem.Android.pas',
  FileSystem.Win in 'src\Plateform\Win\FileSystem.Win.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNavMainForm, NavMainForm);
  Application.Run;
end.
