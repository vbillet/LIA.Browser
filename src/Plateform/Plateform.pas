unit Plateform;

interface

uses
  FileSystem,
  {$IFDEF ANDROID}
    FileSystem.Android;
   // Capabilities.Android;
  {$ELSE}
    FileSystem.Win;
//    Capabilities.Win;
  {$ENDIF}

type

IPlateform = interface
  function GetFileSystem : TFileSystem;
end;

TPlateform = class //(TInterfacedObject, IPlateform)
  private
    class var FInstance: TPlateform;
    constructor Create;
  protected
    {$IFDEF ANDROID}FFileSystem: TAndroidFileSystem; {$ELSE}FFileSystem: TWindowsFileSystem;{$ENDIF}
  public
    class function Get: TPlateform;
    property FileSystem: {$IFDEF ANDROID}TAndroidFileSystem{$ELSE}TWindowsFileSystem{$ENDIF} read FFileSystem;
end;

implementation

{ TPlateform }

constructor TPlateform.Create;
begin
  {$IFDEF ANDROID}
    FFileSystem := TAndroidFileSystem.Create;
  {$ELSE}
    FFileSystem := TWindowsFileSystem.Create;
  {$ENDIF}
end;

class function TPlateform.Get: TPlateform;
begin
  if not Assigned(FInstance) then FInstance := TPlateform.Create;
  result := FInstance;
end;

end.
