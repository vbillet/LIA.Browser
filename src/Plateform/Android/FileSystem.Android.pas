unit FileSystem.Android;

interface

uses
  System.IOUtils,
  FileSystem;

type

TAndroidFileSystem = class(TFileSystem)
  public
    function GetRoot: string;
    function GetAssetsFolder: string;
    function GetDataFolder: string;
    function OpenFile(pFileName: string): string;
    function SaveFile(pFileName, pContent: string): Boolean;
end;

implementation

{ TAndroidFileSystem }

function TAndroidFileSystem.GetAssetsFolder: string;
begin
  result := inherited;
  result := TPath.GetDocumentsPath;
end;

function TAndroidFileSystem.GetDataFolder: string;
begin
  result := inherited;
  result := TPath.GetPublicPath;
end;

function TAndroidFileSystem.GetRoot: string;
begin
  result := inherited;
  result := '/';
end;

function TAndroidFileSystem.OpenFile(pFileName: string): string;
begin
  result := inherited;
end;

function TAndroidFileSystem.SaveFile(pFileName, pContent: string): Boolean;
begin
  result := inherited;
end;

end.
