unit MainWin;

interface

uses
//**************************************************************************************************
// Couches Plateformes
// Refs :
// * https://en.delphipraxis.net/topic/8065-how-can-i-handle-the-javascript-result/
//**************************************************************************************************
  {$IFDEF ANDROID}
    AndroidAPI.JNI.Webkit, AndroidAPI.JNI.Embarcadero, Androidapi.JNIBridge,
    Androidapi.Helpers,    Androidapi.JNI.JavaTypes,   FMX.WebBrowser.Android,
  {$ENDIF}
//**************************************************************************************************
// Couche d'abstraction de plateforme
//**************************************************************************************************
    FMX.Types,             FMX.Controls,               FMX.Forms,
    FMX.Graphics,          FMX.Dialogs,                FMX.WebBrowser,
    FMX.Platform,          FMX.Controls.Presentation,  FMX.StdCtrls,
    FMX.Objects,           FMX.Edit,
//**************************************************************************************************
// Couche delphi
//**************************************************************************************************
    System.SysUtils,       System.Types,               System.UITypes,
    System.Classes,        System.ioutils;

type
//**************************************************************************************************
// Définition des objets de callBack spécifiques aux plateformes
//**************************************************************************************************
  {$IFDEF ANDROID}
    TJavaScriptResultEvent = procedure(Sender: TObject; const JavaScriptResult: string) of object;

    TJavaScriptValueCallback = class(TJavaLocal, JValueCallback)
    private
      FOnResult: TJavaScriptResultEvent;
    public
      { JValueCallback }
      procedure onReceiveValue(value: JObject); cdecl;
    public
      property OnResult: TJavaScriptResultEvent read FOnResult write FOnResult;
    end;
  {$ENDIF}

//**************************************************************************************************
// Définition des extentions JavaScript
//**************************************************************************************************
  IMyIntf = interface(JObject)
    ['{b328eb21-a99e-47b6-b8b0-ef82df62c215}']
    procedure showMsg(Param1:JString);
  end;

  TMyIntf = class(TJObject,JObject)
    function equals(obj: JObject): Boolean; cdecl;
    function getClass: Jlang_Class; cdecl;
    function hashCode: Integer; cdecl;
    procedure notify; cdecl;
    procedure notifyAll; cdecl;
    function toString: JString; cdecl;
    procedure wait(timeout: Int64); overload; cdecl;
    procedure wait(timeout: Int64; nanos: Integer); overload; cdecl;
    procedure wait; overload; cdecl;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
//**************************************************************************************************
// Définition de la classe fenêtre du Navigateur
//**************************************************************************************************
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Nav: TWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FWaitForJS: Boolean;
    FJSResult: string;
  {$IFDEF ANDROID}
    FJavaScriptValueCallback: TJavaScriptValueCallback;
  {$ENDIF}
    procedure JSResultHandler(Sender: TObject; const JavaScriptResult: string);
    //[[PRIVATE]]
  protected
    function CallJS(JSCommand: string) : string;
  public
    //[[PUBLIC]]
  end;

var
  Form1: TForm1;
  //[[VARGLOBALES]]

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}
{$R *.Surface.fmx MSWINDOWS}
{$R *.XLgXhdpiTb.fmx ANDROID}

//**************************************************************************************************
// Implémentation des objets de callBack spécifiques aux plateformes
//**************************************************************************************************
{$IFDEF ANDROID}
procedure TJavaScriptValueCallback.onReceiveValue(value: JObject);
begin
  if Assigned(FOnResult) then
    FOnResult(Self, JStringToString(TJString.Wrap(value)).DeQuotedString('"'));
end;
{$ENDIF}


//**************************************************************************************************
// Implémentation des constructeurs et destructeurs de la fenêtre
//**************************************************************************************************
procedure TForm1.FormCreate(Sender: TObject);
var
{$IFDEF ANDROID}
  LWebView: JWebView;
{$ENDIF}
begin
  inherited;
  FWaitForJS := false;

{$IFDEF ANDROID}
  FJavaScriptValueCallback          := TJavaScriptValueCallback.Create;
  FJavaScriptValueCallback.OnResult := JSResultHandler;
(*  if Supports(Nav, JWebView, LWebView) then
    LWebView.addJavascriptInterface(obj,'My');*)
{$ENDIF}
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
{$IFDEF ANDROID}
  FJavaScriptValueCallback.Free;

{$ENDIF}
  inherited;
end;

//**************************************************************************************************
function TForm1.CallJS(JSCommand: string) : string;
var
{$IFDEF ANDROID}
  LWebView: JWebView;
{$ENDIF}
begin
  result := 'ERRCALLJS';
  if FWaitForJS then exit;

  FWaitForJS := true;
  {$IFDEF ANDROID}
    if Supports(Nav, JWebView, LWebView) then
      LWebView.evaluateJavascript(StringToJString(JSCommand), FJavaScriptValueCallback);
  {$ENDIF}
end;


//**************************************************************************************************
// Implémentation du endPoints du callBack d'exécution JS
//**************************************************************************************************
procedure TForm1.JSResultHandler(Sender: TObject; const JavaScriptResult: string);
begin
  FJSResult  := JavaScriptResult;
  FWaitForJS := false;
end;

//**************************************************************************************************
// Fonctions de tests
//**************************************************************************************************
procedure TForm1.FormResize(Sender: TObject);
begin
  Screen.UpdateDisplayInformation;
  FormFactor.AdjustToScreenSize;
  Label2.Text := 'FormResize !!' + IntToStr(trunc(FormFactor.width )) + ','+ IntToStr( trunc(screen.WorkAreaWidth))+ ','+IntToStr( trunc(screen.DesktopWidth));
end;

procedure TForm1.FormShow(Sender: TObject);
var
  trouve: Boolean;
begin
  Label1.Text := 'Chemin : '+System.ioutils.TPath.Combine(System.ioutils.TPath.GetDocumentsPath,'toot');
  trouve := FileExists(System.ioutils.TPath.Combine(System.ioutils.TPath.GetDocumentsPath, 'fichiers/CC4.pdf'));

//  WindowState := wsMaximized;
  Height := trunc(screen.Height);
  width := trunc(screen.Width);

  if trouve then
    Label2.Text := 'Trouvé !!' + IntToStr(trunc(screen.Width)) + ','+ IntToStr( trunc(screen.Height))//+ ','+IntToStr( trunc(screen.))
  else
    Label2.Text := 'Non Trouvé !!';
  Nav.LoadFromStrings('''
  <h1>Hello !!!</h1>
  <script>
  function mafonc(){
    alert("mafonc");
    //navigate('#param1&param2&param3&param4');
    document.location='#param1&param2&param3&param4';
    //window.location.href='#param1&param2&param3&param4';
    alert("mafonc End");
  }
  </script>
  <button onclick='alert("hello"); mafonc();'>Click</button>
  ''','localhost');

  showMessage(CallJS('new Date().toISOString().slice(0,10).replace(/-/g,".");'));
end;

{ TMyIntf }

function TMyIntf.equals(obj: JObject): Boolean;
begin
  result := false;
end;

function TMyIntf.getClass: Jlang_Class;
begin

end;

function TMyIntf.hashCode: Integer;
begin

end;

procedure TMyIntf.notify;
begin

end;

procedure TMyIntf.notifyAll;
begin

end;

function TMyIntf.QueryInterface(const IID: TGUID; out Obj): HResult;
begin

end;

function TMyIntf.toString: JString;
begin

end;

procedure TMyIntf.wait;
begin

end;

procedure TMyIntf.wait(timeout: Int64; nanos: Integer);
begin

end;

procedure TMyIntf.wait(timeout: Int64);
begin

end;

function TMyIntf._AddRef: Integer;
begin

end;

function TMyIntf._Release: Integer;
begin

end;

end.
