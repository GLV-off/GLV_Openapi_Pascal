unit Test.Fakes;

{$I 'glv_openapi_test.inc'}

interface

uses
  FpJson;

const
  TEST_ASSET_FAKE_SPEC_JSON: UnicodeString = 'fake_spec.json';

function GetFakeJsonSpec: TJSONObject;

function CreateFakeInfoJson: TJSONObject;

function CreateFakeEmptyJsonObject: TJSONObject;

implementation

uses
  SysUtils,
  Classes,
  JsonParser,
  Test.Env;

function GetFakeJsonSpec: TJSONObject;

var
  Path: UnicodeString;
  Stream: TFileStream;
  JsonValue: TJSONData;
begin
  Path := TEnv.GetAsset(TEST_ASSET_FAKE_SPEC_JSON);
  Stream := TFileStream.Create(UTF8Encode(Path), fmOpenRead);
  try
    try
      { todo: skip UTF8_Bom }
      JsonValue := GetJSON(Stream, True);
    except
      on E: Exception do
      begin
        JsonValue := nil;
      end;
    end;
  finally
    FreeAndNil(Stream);
  end;

  if not Assigned(JsonValue) then
    Exit(TJSONObject.Create());

  if JsonValue.InheritsFrom(TJSONObject) then
    Result := TJSONObject(JsonValue)
  else
    Result := TJSONObject.Create();
end;

function CreateFakeInfoJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('title', 'fake_title');
  Result.Add('version', '1.0.0');
  Result.Add('description', 'fake_description');
end;

function CreateFakeEmptyJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
end;

end.

