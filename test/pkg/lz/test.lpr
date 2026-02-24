program test;

{$I 'glv_openapi_test.inc'}

uses
  Glv.Testing.App,
  Glv.OpenApi.Test,
  Glv.OpenApi.FpJsonUtils.Test,
  Test.Env,
  Test.Fakes, Glv.Json.Test;
begin
  Glv.Testing.App.Run('Tests for GLV Openapi Library');
{$IFDEF DEBUG}
  ReadLn;
{$ENDIF DEBUG}
end.
