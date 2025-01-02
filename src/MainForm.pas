unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IniFiles,
  System.IOUtils,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.WebBrowser, Plateform,

  SG.ScriptGate, SG.ScriptGate.Android.SGWebClientBridge, //Androidapi.JNI.JavaTypes,
  SG.ScriptGate.Android;

type
  {$RTTI EXPLICIT METHODS( [vcPublic])}
  TNavMainForm = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Nav: TWebBrowser;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FPlateform: TPlateform;
    FURL: string;
    FGate: TScriptGate;
    procedure ReadIniFile;
  public
    { Déclarations publiques }
    procedure OpenFile;
    procedure SaveFile(const pContenu: string);
    //procedure ShowMessage(const pMessage: string);
    property Plateform: TPlateform read FPlateform;
  end;
var
  NavMainForm: TNavMainForm;

implementation

{$R *.fmx}

procedure TNavMainForm.FormCreate(Sender: TObject);
begin
  FPlateform := TPlateform.Get;
  ReadIniFile;
  FGate := TScriptGate.Create(Self,Nav,'delphi');
  Nav.Navigate;
end;

procedure TNavMainForm.FormDestroy(Sender: TObject);
begin
  FPlateform.Free;
end;

procedure TNavMainForm.ReadIniFile;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(Plateform.FileSystem.GetAssetsFolder+'/ini/LIA.ini');
  try
    FURL := IniFile.ReadString('Application', 'URL', '');
    if FURL.substring(0,8) = 'https://' then
    begin
      Nav.URL := FURL;
    end else
    begin
      FURL := 'file://'+Plateform.FileSystem.GetAssetsFolder+FURL;
      Nav.URL := FURL;
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TNavMainForm.OpenFile;
var
  contenu: string;
  js: string;
begin
  contenu := TFile.ReadAllText(Plateform.FileSystem.GetDataFolder+'/save.txt');
  js := 'SetData(''' + Trim(contenu )+ ''');';
  FGate.CallScript(js,nil);
end;


procedure TNavMainForm.SaveFile(const pContenu: string);
var
  contenu: TStringList;
begin
  contenu := TStringList.Create;
  contenu.Text := pContenu;
//  showMessage(Plateform.FileSystem.GetDataFolder+'/save.txt '+Contenu.Text);
  contenu.SaveToFile(Plateform.FileSystem.GetDataFolder+'/save.txt');
  contenu.Free;
end;


procedure TNavMainForm.Button1Click(Sender: TObject);
var
  Lst: TStringList;
begin
  with  Plateform.FileSystem do
  begin
    Label1.Text := GetAssetsFolder;
//    Label2.Text := GetDataFolder+'/assets/internal/ini/LIA.ini';
    Label2.Text := GetDataFolder;
  end;
  CheckBox1.IsChecked := FileExists(Label1.Text+'/ini/LIA.ini');
  //CheckBox1.IsChecked := DirectoryExists(Label2.Text);
  Lst := TStringList.Create;
  Lst.Text := 'ceci est un exemple'+#13#10+'de texte';
  Lst.SaveToFile(Label2.Text+'/test.txt');
  CheckBox2.IsChecked := FileExists(Label2.Text+'/test.txt');
end;

end.
