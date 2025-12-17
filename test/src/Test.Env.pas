unit Test.Env;

{$I 'glv_openapi_test.inc'}

interface

type
  {
   Окружение тестового приложения
  }
  TEnv = record
    {

    }
    class function GetRoot: UnicodeString; static;

    {

    }
    class function GetAssetDir: UnicodeString; static;

    {
     Получить
    }
    class function GetAsset(const APath: UnicodeString): UnicodeString; static;
  end;

implementation

uses
  SysUtils;

class function TEnv.GetRoot: UnicodeString;
begin
  Result := UTF8Decode(ExtractFilePath(ParamStr(0)));
end;

class function TEnv.GetAssetDir: UnicodeString;
begin
  Result := GetRoot() + '..\..\..\Assets\';
end;

class function TEnv.GetAsset(const APath: UnicodeString): UnicodeString;
begin
  Result := GetAssetDir() + APath;
end;

end.

