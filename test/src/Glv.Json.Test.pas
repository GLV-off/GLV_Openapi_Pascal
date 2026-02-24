unit Glv.Json.Test;

{$I 'glv_openapi_test.inc'}

interface

uses
  Glv.Json,
  Glv.Testing.Cross;

type
  {
  }
  TJsonBuilderTest = class(TCrossTestCase)
  strict private
    FBuilder: IJsonBuilder;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSimple;
  end;

implementation

procedure TJsonBuilderTest.SetUp;
begin
  inherited SetUp;
  FBuilder := TJsonBuilder.Create;
end;

procedure TJsonBuilderTest.TearDown;
begin
  FBuilder := nil;
  inherited TearDown;
end;

procedure TJsonBuilderTest.TestSimple;
var
  X: TJSONValue;
begin
  FBuilder.Build();
end;

initialization

CrossRegTest(TJsonBuilderTest, 'Unit');

end.

