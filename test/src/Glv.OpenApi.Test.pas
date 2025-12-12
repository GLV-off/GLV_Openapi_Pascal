unit Glv.OpenApi.Test;

{$I 'glv_openapi_test.inc'}

interface

uses
  Glv.Testing.Cross,
  Glv.Openapi.Ifaces;

type
  TEmptyJsonOpenapiDocumentTest = class(TCrossTestCase)
  protected
    FOpenapi: IOpenapiDocument;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestVersionReturnNothing;
  end;

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

implementation

uses
  SysUtils,
  Classes,
  jsonparser,
  Glv.Openapi.FpcJson,
  Glv.Openapi.Version,
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

{ =========================================================================== }

initialization

CrossRegTest(TEmptyJsonOpenapiDocumentTest, 'Unit');
CrossRegTest(TDefaultJsonOpenapiDocumentTest, 'Unit');
CrossRegTest(TDefaultJsonInfoTest, 'Unit');

end.

