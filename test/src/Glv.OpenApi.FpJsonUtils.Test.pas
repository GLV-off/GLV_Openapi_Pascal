unit Glv.OpenApi.FpJsonUtils.Test;

{$I 'glv_openapi_test.inc'}

interface

uses
  FpJson,
  SysUtils,
  Glv.Testing.Cross;

type
  {
   Tests for the "CountOf" function
   counting pairs with objects by
   a list in a JSON object
  }
  TCountOfTest = class(TCrossTestCase)
  published
    {}
    procedure TestEmptyJsonReturnZero;
    {}
    procedure TestSingleFieldReturn_1;
    {}
    procedure TestTwoFieldReturn_2;
  end;

implementation

uses
  Glv.Openapi.FpJsonFuncs,
  Test.Fakes;

{ =========================================================================== }

procedure TCountOfTest.TestEmptyJsonReturnZero;
const
  MSG_COUNT_NOT_MATCH: UnicodeString = 'Wrong counf of elements! Expect zero!';
var
  Json: TJSONObject;
begin
  Json := TJSONObject.Create();
  try
    CheckEquals(0, CountOf(Json, ['get', 'post']), MSG_COUNT_NOT_MATCH);
  finally
    FreeAndNil(Json);
  end;
end;

procedure TCountOfTest.TestSingleFieldReturn_1;
const
  MSG_COUNT_NOT_MATCH: string = 'Число элементов посчитано не правильно!';
var
  Json: TJSONObject;
begin
  Json := TJSONObject.Create();
  try
    Json.Add('get', CreateFakeJsonPath());
    CheckEquals(1, CountOf(Json, ['get', 'post']), MSG_COUNT_NOT_MATCH);
  finally
    FreeAndNil(Json);
  end;
end;

procedure TCountOfTest.TestTwoFieldReturn_2;
const
  MSG_COUNT_NOT_MATCH: string = 'Число элементов посчитано не правильно!';
var
  Json: TJSONObject;
begin
  Json := TJSONObject.Create();
  try
    Json.Add('get', CreateFakeJsonPath());
    Json.Add('post', CreateFakeJsonPath());
    CheckEquals(2, Json.Count, MSG_COUNT_NOT_MATCH);
  finally
    FreeAndNil(Json);
  end;
end;

{ =========================================================================== }

initialization

CrossRegTest(TCountOfTest, 'Unit');

end.

