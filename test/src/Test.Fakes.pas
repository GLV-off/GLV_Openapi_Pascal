unit Test.Fakes;

{$I 'glv_openapi_test.inc'}

interface

uses
  FpJson;

const
  TEST_ASSET_FAKE_SPEC_JSON: UnicodeString = 'fake_spec.json';
  TEST_ASSET_FAKE_SPEC_YAML: UnicodeString = 'fake_spec.yaml';

function GetFakeJsonSpec: TJSONObject;

function CreateFakeInfoJson: TJSONObject;

function CreateFakeServersJson: TJSONArray;

function CreateFakeServerObjectJson: TJSONObject;

function CreateFakeEmptyJsonArray: TJSONArray;

function CreateFakeEmptyJsonObject: TJSONObject;

function CreateFakeJsonPaths: TJSONObject;

function CreateFakeJsonPath: TJSONObject;

function CreateFakeTags: TJSONArray;

{
 JSON Примитивами
}

function NewObj: TJSONData; overload;
function NewObj(const AKey: UnicodeString;
                const AValue: TJSONData): TJSONData; overload;
function NewStr(const AValue: UnicodeString): TJSONData; overload;
function NewArr: TJSONData; overload;

implementation

uses
  SysUtils,
  Classes,
  JsonParser,
  Test.Env;

function NewObj: TJSONData;
begin
  Result := TJSONObject.Create();
end;

function NewObj(const AKey: UnicodeString;
                const AValue: TJSONData): TJSONData;
var
  Obj: TJSONObject;
begin
  Obj := TJSONObject.Create();
  Obj.Add(AKey, AValue);
  Result := Obj;
end;

function NewStr(const AValue: UnicodeString): TJSONData;
begin
  Result := TJSONString.Create(AValue);
end;

function NewArr: TJSONData;
begin
  Result := TJSONArray.Create();
end;

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

function CreateFakeServersJson: TJSONArray;
begin
  Result := TJSONArray.Create();
  Result.Add(CreateFakeServerObjectJson());
end;

function CreateVariables: TJSONObject; forward;

function CreateFakeServerObjectJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('url', 'fake_url');
  Result.Add('description', 'fake_description');
  Result.Add('variables', CreateVariables());
end;

function CreateVariables: TJSONObject;
begin
  Result := TJSONObject.Create;
end;

function CreateFakeEmptyJsonArray: TJSONArray;
begin
  Result := TJSONArray.Create();
end;

function CreateFakeEmptyJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
end;

function CreateFakeJsonPaths: TJSONObject;
var
  LocalObj: TJSONObject;
begin
  {
  Result := TJSONObject.Create;
  Result.Add('operationId', 'getHelp');
  Result.Add('description', 'fake_description');
  Result.Add('tags', CreateFakeTags());

  Result := TJSONArray.Create;
  Result.Add('help');


  Object('/help'
    Object('get',
      Object([
        Pair('operationId', 'getHelp'),
        Pair('description', 'getHelp'),
        Pair('tags', NewArray([NewStr('help')]))
      ])
    ),
    Object('get',
      Object([
        Pair('operationId', 'getHelp'),
        Pair('description', 'getHelp'),
        Pair('tags', NewArray([NewStr('help')]))
      ])
    ),
    Object('get',
      Object([
        Pair('operationId', 'getHelp'),
        Pair('description', 'getHelp'),
        Pair('tags', NewArray([NewStr('help')]))
      ])
    ),
  )
  }
  Result := TJSONObject.Create;
  LocalObj := TJSONObject.Create();
  LocalObj.Add('get', CreateFakeJsonPath());
  LocalObj.Add('post', CreateFakeJsonPath());
  LocalObj.Add('put', CreateFakeJsonPath());
  LocalObj.Add('delete', CreateFakeJsonPath());
  Result.Add('/help', LocalObj);
end;

function CreateFakeJsonPath: TJSONObject;
begin
  Result := TJSONObject.Create();
  Result.Add('operationId', 'getHelp');
  Result.Add('description', 'fake_description');
  Result.Add('tags', CreateFakeTags());
end;

function CreateFakeTags: TJSONArray;
begin
  Result := TJSONArray.Create;
  Result.Add('help');
end;

end.

