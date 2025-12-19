unit Glv.OpenApi.Test;

{$I 'glv_openapi_test.inc'}

interface

uses
  FpJson,
  Glv.Testing.Cross,
  Glv.Openapi.Ifaces;

type

  {
   МОДУЛЬНЫЕ ТЕСТЫ
  }

  {
   Testing empty JSON openapi object
   document representation.
  }
  TEmptyJsonOpenapiDocumentTest = class(TCrossTestCase)
  protected
    FOpenapi: IOpenapiDocument;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestVersionReturnNothing;
  end;

  {
   Tests for default preloaded FAKE
   asset as Open API Json document
  }
  TDefaultJsonServersTest = class(TCrossTestCase)
  protected
    FServers: IServers;
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCountWorks;
    procedure TestAccessServerObject;
  end;

  TEmptyJsonServersTest = class(TCrossTestCase)
  protected
    FServers: IServers;
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCountWorks;
    procedure TestAtEmptyServersJsonReturnNonNullObject;
  end;

  TDefaultJsonInfoTest = class(TCrossTestCase)
  protected
    FInfo: IInfo;
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestDescription;
    procedure TestTitle;
    procedure TestVersion;
  end;

  TDefaultJsonPathsTest = class(TCrossTestCase)
  protected
    FPaths: IPaths;
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCountOfPathsCombinationsMatch;
  end;

  TDefaultJsonPathTest = class(TCrossTestCase)
  protected
    FPath: IPath;
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestUrl;
    procedure TestOperationId;
    procedure TestMethod;
    procedure TestDescription;
    procedure TestTags;
  end;

  TFpJson_EmptyJSONObjectTest = class(TCrossTestCase)
  strict private
    FJson: TJSONObject;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestAssigned;
    procedure TestItems;
  end;

  TFpJson_FilledJSONObjectTest = class(TCrossTestCase)
  strict private
    FJson: TJSONObject;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCountAfterFill;
    procedure TestFirstItem;
    procedure TestSeconItem;
    procedure TestKeys;
    procedure TestEnumerator;
  end;

  TPrimitiveTest = class(TCrossTestCase)
  published
    procedure TestGetAsString;
    procedure TestDeleteAsString;
    procedure TestPutAsString;

    procedure TestRawStrings;
  end;

  {
   ИНТЕГРАЦИОННЫЕ ТЕСТЫ
  }

  TDefaultJsonOpenapiDocumentTest = class(TCrossTestCase)
  protected
    FOpenapi: IOpenapiDocument;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAssetExists;
    procedure TestAssetHasUtf8BomEncoding;
    procedure TestVersion;
    procedure TestInfoNotNull;
    procedure TestInfo;
    procedure TestServersNotNil;
    procedure TestServers;
    procedure TestPathsNotNil;
    procedure TestPaths;
  end;

implementation

uses
  SysUtils,
  Classes,
  Variants,
  JsonParser,
  Glv.Openapi.FpcJson,
  Glv.Openapi.Version,
  Glv.Openapi.Server,
  Glv.Openapi.Routes,
  Test.Env,
  Test.Fakes;

{ ==== TEmptyJsonOpenapiDocumentTest ======================================== }

procedure TEmptyJsonOpenapiDocumentTest.SetUp;
begin
  FOpenapi := TJsonOpenapiDocument.Create(
    CreateFakeEmptyJsonObject()
  );
end;

procedure TEmptyJsonOpenapiDocumentTest.TearDown;
begin
  FOpenapi := nil;
end;

procedure TEmptyJsonOpenapiDocumentTest.TestVersionReturnNothing;
const
  MSG_VERSION_NOT_MATCH: string = 'Версия спецификации не совпала!';
begin
  CheckEquals('', UTF8Encode(FOpenapi.Openapi.Version), MSG_VERSION_NOT_MATCH);
end;

{ ==== TDefaultJsonServersTest ============================================== }

procedure TDefaultJsonServersTest.Setup;
begin
  FServers := TJsonServers.Create(
    CreateFakeServersJson()
  );
end;

procedure TDefaultJsonServersTest.TearDown;
begin
  FServers := nil;
end;

procedure TDefaultJsonServersTest.TestCountWorks;
begin
  CheckEquals(1, FServers.Count, 'Число сущностей не совпало с ожиданием!');
end;

procedure TDefaultJsonServersTest.TestAccessServerObject;
const
  MSG_URL: string = 'fake_url';
  MSG_DESC: string = 'fake_description';
var
  S: TOpenapiServer;
begin
  S := FServers.Server[0];
  try
    CheckEquals(MSG_URL, UTF8Encode(S.Url), 'Поле url не соответствует ожиданию!');
    CheckEquals(MSG_DESC, UTF8Encode(S.Description), 'Поле description не соответствует ожиданию!');
    { todo: glv: Проверить Variables }
  finally
    FreeAndNil(S);
  end;
end;

{ ==== TEmptyJsonServersTest ================================================ }

procedure TEmptyJsonServersTest.Setup;
begin
  FServers := TJsonServers.Create(
    CreateFakeEmptyJsonArray()
  );
end;

procedure TEmptyJsonServersTest.TearDown;
begin
  FServers := nil;
end;

procedure TEmptyJsonServersTest.TestCountWorks;
begin
  CheckEquals(0, FServers.Count, 'Число сущностей не совпало с ожиданием!');
end;

procedure TEmptyJsonServersTest.TestAtEmptyServersJsonReturnNonNullObject;
var
  S: TOpenapiServer;
begin
  S := FServers.Server[0];
  try
    CheckNotNull(S, 'Объект оказался nil!');
  finally
    FreeAndNil(S);
  end;
end;

{ ==== TDefaultJsonInfoTest ================================================= }

procedure TDefaultJsonInfoTest.Setup;
begin
  FInfo := TJsonInfo.Create(CreateFakeInfoJson());
end;

procedure TDefaultJsonInfoTest.TearDown;
begin
  FInfo := nil;
end;

procedure TDefaultJsonInfoTest.TestDescription;
begin
  CheckEquals('fake_description', FInfo.Description, 'Поле description не соответствует действительности!');
end;

procedure TDefaultJsonInfoTest.TestTitle;
begin
  CheckEquals('fake_title', FInfo.Title, 'Поле title не соответствует действительности!');
end;

procedure TDefaultJsonInfoTest.TestVersion;
begin
  CheckEquals('1.0.0', FInfo.Version, 'Поле version не соответствует действительности!');
end;

{ ==== TDefaultJsonPathsTest ================================================ }

procedure TDefaultJsonPathsTest.Setup;
begin
  FPaths := TJsonPaths.Create(
    CreateFakeJsonPaths()
  );
end;

procedure TDefaultJsonPathsTest.TearDown;
begin
  FPaths := nil;
end;

procedure TDefaultJsonPathsTest.TestCountOfPathsCombinationsMatch;
begin
  CheckEquals(4, FPaths.Count, 'Count of paths not match!');
end;

{ ==== TDefaultJsonPathTest ================================================= }

procedure TDefaultJsonPathTest.Setup;
begin
  FPath := TJsonPath.Create(
    '/help',
    oamGET,
    CreateFakeJsonPath()
  );
end;

procedure TDefaultJsonPathTest.TearDown;
begin
  FPath := nil;
end;

procedure TDefaultJsonPathTest.TestUrl;
begin
  CheckEquals('/help', UTF8Encode(FPath.Url), 'URL не совпадает с ожиданием!');
end;

procedure TDefaultJsonPathTest.TestOperationId;
begin
  CheckEquals('getHelp', UTF8Encode(FPath.OperationID));
end;

procedure TDefaultJsonPathTest.TestMethod;
begin
  CheckEquals(Ord(oamGET), Ord(FPath.Method), 'Метод не совпал с ожиданием!');
end;

procedure TDefaultJsonPathTest.TestDescription;
begin
  CheckEquals('fake_description', UTF8Encode(FPath.Description));
end;

procedure TDefaultJsonPathTest.TestTags;
var
  Tags: TTags;
begin
  Tags := FPath.Tags;
  try
    CheckEquals(1, Length(Tags), 'Число тэгов не ожиданное!');
    CheckEquals('help', UTF8Encode(Tags[0]), 'Значение тэга не совпадает с ожидаемым!');
  finally
    SetLength(Tags, 0);
  end;
end;

{ ==== TDefaultJsonOpenapiDocumentTest ====================================== }

procedure TDefaultJsonOpenapiDocumentTest.SetUp;
begin
  FOpenapi := TJsonOpenapiDocument.Create(GetFakeJsonSpec());
end;

procedure TDefaultJsonOpenapiDocumentTest.TearDown;
begin
  FOpenapi := nil;
end;

procedure TDefaultJsonOpenapiDocumentTest.TestAssetExists;
const
  MSG_ASSET_NOT_FOUND: string = 'Тестовый ассет не найден!';
begin
  CheckTrue(
  { .. } FileExists(
  { .... } UTF8Encode(
  { ...... } TEnv.GetAsset(TEST_ASSET_FAKE_SPEC_JSON)
  { .... } )
  { .. } ),
  { .. } MSG_ASSET_NOT_FOUND
  {} );
end;

procedure TDefaultJsonOpenapiDocumentTest.TestAssetHasUtf8BomEncoding;
begin
  CheckTrue(True);
end;

procedure TDefaultJsonOpenapiDocumentTest.TestVersion;
begin
  CheckEquals('3.1.1', UTF8Encode(FOpenapi.Openapi.Version), 'Версия спецификации не соответствует!');
end;

procedure TDefaultJsonOpenapiDocumentTest.TestInfoNotNull;
var
  Info: IInfo;
begin
  Info := FOpenapi.Info;
  CheckNotNull(Info, 'info объект вернулся пустым!');
end;

procedure TDefaultJsonOpenapiDocumentTest.TestInfo;
const
  TEST_INFO_TITLE: UnicodeString = 'Тестовый ассет спецификации Open API';
  TEST_INFO_DESC: UnicodeString = 'Тестовый ассет и его описание';
  TEST_INFO_VERSION: UnicodeString = '1.2.3';
var
  Info: IInfo;
begin
  Info := FOpenapi.Info;
  CheckEquals(TEST_INFO_TITLE, Info.Title, UTF8Encode('info.title Не соответствует!'));
  CheckEquals(TEST_INFO_DESC, Info.Description, UTF8Encode('info.description Не соответствует!'));
  CheckEquals(TEST_INFO_VERSION, Info.Version, UTF8Encode('info.version Не соответствует!'));

end;

procedure TDefaultJsonOpenapiDocumentTest.TestServersNotNil;
var
  Servers: IServers;
begin
  Servers := FOpenapi.Servers;
  CheckNotNull(Servers, 'servers не нуль');
end;

procedure TDefaultJsonOpenapiDocumentTest.TestServers;
var
  Servers: IServers;
  Server: TOpenapiServer;
begin
  Servers := FOpenapi.Servers;
  CheckEquals(1, Servers.Count, 'Число элементов не соответствует!');
  Server := Servers.Server[0];
  try
    CheckEquals('http://localhost/test', Server.Url);
    CheckEquals('Тестовый сервер', Server.Description);
  finally
    FreeAndNil(Server);
  end;
end;

procedure TDefaultJsonOpenapiDocumentTest.TestPathsNotNil;
begin
  CheckNotNull(FOpenApi.Paths, 'Объект paths оказался nil!');
end;

procedure TDefaultJsonOpenapiDocumentTest.TestPaths;
const
  MSG_NOT_ASSIGNED: string = 'Блок path не задан';
  MSG_ITEMS_LEN: string = 'Число элементов несоответствует действиетльности!';
var
  Paths: IPaths;
  Items: TArray<IPath>;
begin
  Paths := FOpenapi.Paths;
  try
    CheckNotNull(Paths, MSG_NOT_ASSIGNED);
    Items := Paths.ByUrl['/help'];
    CheckEquals(0, Length(Items), MSG_ITEMS_LEN);
  finally
    Paths := nil;
    SetLength(Items, 0);
  end;
end;

{ ==== TFpJson_EmptyJSONObjectTest ====================================================== }

procedure TFpJson_EmptyJSONObjectTest.Setup;
begin
  FJson := TJSONObject.Create([]);
end;

procedure TFpJson_EmptyJSONObjectTest.TearDown;
begin
  FreeAndNil(FJson);
end;

procedure TFpJson_EmptyJSONObjectTest.TestAssigned;
begin
  CheckNotNull(FJson, 'FJSON оказался nil!');
end;

procedure TFpJson_EmptyJSONObjectTest.TestItems;
begin
  CheckEquals(0, FJson.Count);
end;

{ ==== TFpJson_FilledJSONObjectTest ========================================= }

procedure TFpJson_FilledJSONObjectTest.Setup;
begin
  FJson := TJSONObject.Create([]);
  FJson.Add('foo', 'bar');
  FJson.Add('first', 'value1');
  FJson.Add('second', TJSONObject.Create());
end;

procedure TFpJson_FilledJSONObjectTest.TearDown;
begin
  FreeAndNil(FJson);
end;

procedure TFpJson_FilledJSONObjectTest.TestCountAfterFill;
begin
  CheckEquals(3, FJson.Count, 'Count has unexpected value!');
end;

procedure TFpJson_FilledJSONObjectTest.TestFirstItem;
var
  Item: TJSONData;
begin
  CheckTrue(Fjson.Count > 0, 'Not enough items for test!');
  Item := FJson.Items[0];
  CheckTrue(Item.InheritsFrom(TJSONString), 'unexpected type for item');
  CheckEquals('bar', VarToStrDef(Item.Value, ''), 'unexpected value!');
end;

procedure TFpJson_FilledJSONObjectTest.TestSeconItem;
var
  Item: TJSONData;
begin
  CheckTrue(Fjson.Count >= 2, 'Not enough items for test!');
  Item := FJson.Items[2];
  CheckTrue(Item.InheritsFrom(TJSONObject), 'unexpected type for item');
  //CheckEquals('bar', VarToStrDef(Item.Value, ''), 'unexpected value!');
end;

procedure TFpJson_FilledJSONObjectTest.TestKeys;
begin
  CheckEquals('foo', FJson.Names[0], 'key not matching expectation''s');
end;

procedure TFpJson_FilledJSONObjectTest.TestEnumerator;
var
  Itr: TBaseJSONEnumerator;
  En : TJSONEnum;
begin
  { При получении интератора, хотябы раз
    нужно вызвать MoveNext }
  Itr := FJSon.GetEnumerator();
  Itr.MoveNext();
  En := Itr.Current;
  CheckEquals(0, En.KeyNum, 'KeyNum not match!');
end;

procedure TPrimitiveTest.TestGetAsString;
begin
  CheckEquals('get', oamGET.ToHttpStr());
end;

procedure TPrimitiveTest.TestDeleteAsString;
begin
  CheckEquals('delete', oamDELETE.ToHttpStr());
end;

procedure TPrimitiveTest.TestPutAsString;
begin
  CheckEquals('put', oamPUT.ToHttpStr());
end;

procedure TPrimitiveTest.TestRawStrings;
var
  RawStrings: TArray<UnicodeString>;
begin
  RawStrings := TOpenApiMethod.RawStrings();
  CheckEquals(6, Length(RawStrings));
end;

{ =========================================================================== }

initialization

CrossRegTest(TEmptyJsonOpenapiDocumentTest, 'Unit');
CrossRegTest(TDefaultJsonServersTest, 'Unit');
CrossRegTest(TEmptyJsonServersTest, 'Unit');
CrossRegTest(TDefaultJsonInfoTest, 'Unit');
CrossRegTest(TDefaultJsonPathsTest, 'Unit');
CrossRegTest(TDefaultJsonPathTest, 'Unit');
CrossRegTest(TFpJson_EmptyJSONObjectTest, 'Unit');
CrossRegTest(TFpJson_FilledJSONObjectTest, 'Unit');
CrossRegTest(TPrimitiveTest, 'Unit');

CrossRegTest(TDefaultJsonOpenapiDocumentTest, 'Int');

end.

