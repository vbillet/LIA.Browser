unit FileSystem.Win;

interface

uses
  System.IOUtils, System.SysUtils,
  FileSystem;

type

TWindowsFileSystem = class(TFileSystem, IFileSystem)
  public
    function GetRoot: string;
    function GetAssetsFolder: string;
    function GetDataFolder: string;
    function OpenFile(pFileName: string): string;
    function SaveFile(pFileName, pContent: string): Boolean;
end;

implementation

{ TWindowsFileSystem }

function TWindowsFileSystem.GetAssetsFolder: string;
begin
  result := inherited;
  result := ExtractFileDir(ParamStr(0))+'\assets';
end;

function TWindowsFileSystem.GetDataFolder: string;
begin
  result := inherited;
  result := ExtractFileDir(ParamStr(0))+'\data';
end;

function TWindowsFileSystem.GetRoot: string;
begin
  result := inherited;
  result := ExtractFileDir(ParamStr(0));
end;

function TWindowsFileSystem.OpenFile(pFileName: string): string;
begin
  result := inherited;
end;

function TWindowsFileSystem.SaveFile(pFileName, pContent: string): Boolean;
begin
  result := inherited;
end;

end.
