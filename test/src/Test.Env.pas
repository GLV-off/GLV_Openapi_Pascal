{
  Unit: Test.Env
  Description:
  Developer: GLV_off
  History: 2025-11-08 - Created
}
unit Test.Env;

{$I 'glv_openapi_test.inc'}

interface

type
  {
   Environment section of
   testing application
  }
  TEnv = record
    {
     Get Root directory executable
    }
    class function GetRoot: UnicodeString; static;

    {
     Get root directory for Asset directory.
     Path to it constructed on 'GetRoot' result
    }
    class function GetAssetDir: UnicodeString; static;

    {
     Get specific path to static asset.
     APath - Full filepath to asset in filesystem.
    }
    class function GetAsset(const APath: UnicodeString): UnicodeString; static;
  end;

implementation

uses
  SysUtils;

class function TEnv.GetRoot: UnicodeString;
{ Get Root directory executable }
begin
  Result := UTF8Decode(ExtractFilePath(ParamStr(0)));
end;

class function TEnv.GetAssetDir: UnicodeString;
{ Get root directory for Asset directory.
  Path to it constructed on 'GetRoot' result }
begin
  Result := GetRoot() + '..\..\..\Assets\';
end;

class function TEnv.GetAsset(const APath: UnicodeString): UnicodeString;
{ Get specific path to static asset.
  APath - Full filepath to asset in filesystem.}
begin
  Result := GetAssetDir() + APath;
end;

end.

