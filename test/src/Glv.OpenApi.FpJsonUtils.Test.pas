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
  public type
    TAssertMethod = procedure(var AJson: TJSONObject) of object;

    {}
    procedure RunAssertion(const AMethod: TAssertMethod);
  public
    {}
    procedure EmptyJsonReturnZero(var AJson: TJSONObject);
    {}
    procedure SingleFieldReturn_1(var AJson: TJSONObject);

    procedure TwoFieldReturn_2(var AJson: TJSONObject);
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
begin
  RunAssertion(EmptyJsonReturnZero);
end;

procedure TCountOfTest.TestSingleFieldReturn_1;
begin
  RunAssertion(SingleFieldReturn_1);
end;

procedure TCountOfTest.TestTwoFieldReturn_2;
begin
  RunAssertion(TwoFieldReturn_2);
end;

{ --------------------------------------------------------------------------- }

procedure TCountOfTest.EmptyJsonReturnZero(var AJson: TJSONObject);
const
  MSG_COUNT_NOT_MATCH: UnicodeString = 'Wrong counf of elements! Expect zero!';
begin
  CheckEquals(0, CountOf(AJson, ['get', 'post']), MSG_COUNT_NOT_MATCH);
end;

procedure TCountOfTest.SingleFieldReturn_1(var AJson: TJSONObject);
const
  MSG_COUNT_NOT_MATCH: string = 'Число элементов посчитано не правильно!';
begin
  AJson.Add('get', CreateFakeJsonPath());
  CheckEquals(1, CountOf(AJson, ['get', 'post']), MSG_COUNT_NOT_MATCH);
end;

procedure TCountOfTest.TwoFieldReturn_2(var AJson: TJSONObject);
const
  MSG_COUNT_NOT_MATCH: string = 'Count Of evaluate wrong number of elements';
begin
  AJson.Add('get', CreateFakeJsonPath());
  AJson.Add('post', CreateFakeJsonPath());
  CheckEquals(2, CountOf(AJson, ['get', 'post']), MSG_COUNT_NOT_MATCH);
end;

{ --------------------------------------------------------------------------- }

procedure TCountOfTest.RunAssertion(const AMethod: TAssertMethod);
var
  Json: TJSONObject;
begin
  Json := TJSONObject.Create;
  try
    if Assigned(Json) and Assigned(AMethod) then
      AMethod(Json);
  finally
    FreeAndNil(Json);
  end;
end;

{ =========================================================================== }

initialization

CrossRegTest(TCountOfTest, 'Unit');

end.

