unit FileSystem;

interface

uses
  System.IOUtils;

type

IFileSystem = interface
  ['{C0000001-4A66-4E7A-B838-AA81F3253C62}']
  function GetRoot: string;
  function GetAssetsFolder: string;
  function GetDataFolder: string;
  function OpenFile(pFileName: string): string;
  function SaveFile(pFileName, pContent: string): Boolean;
end;

TFileSystem = class(TInterfacedObject, IFileSystem)
  function GetRoot: string;
  function GetAssetsFolder: string;
  function GetDataFolder: string;
  function OpenFile(pFileName: string): string;
  function SaveFile(pFileName, pContent: string): Boolean;
end;

implementation

{ TFileSystem }

function TFileSystem.GetRoot: string;
begin
  // Rien ici, c'est le système qui donne la racine de l'application
  result := TPath.GetHomePath;
end;

function TFileSystem.GetAssetsFolder: string;
begin
  // Rien ici, c'est le système qui donne l'emplacement des assets
  result := '';
end;

function TFileSystem.GetDataFolder: string;
begin
  // Rien ici, c'est le système qui donne l'emplacement des données utilisateurs
  result := '';
end;

function TFileSystem.OpenFile(pFileName: string): string;
begin
  // On contrôle que l'on ne sort pas de la racine de l'application.
  // On n'ouvre pas de fichiers en dehors de l'application (DataFolder ou AssetsFolder)
  result := '';
end;

function TFileSystem.SaveFile(pFileName, pContent: string): Boolean;
begin
  result := false;
end;

end.
