unit Glv.OpenApi.Test;

{$I 'glv_openapi_test.inc'}

interface

uses
  Classes,
  SysUtils,
  Glv.Testing.Cross;

type
  TTestCase1= class(TCrossTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestCase1.TestHookUp;
begin
  Fail('Напишите ваш тест');
end;

procedure TTestCase1.SetUp;
begin

end;

procedure TTestCase1.TearDown;
begin

end;

initialization

CrossRegTest(TTestCase1, 'Unit');

end.

