program test;

{$I 'glv_openapi_test.inc'}

uses
  Windows,
  Glv.OpenApi.Test,
  Glv.Testing.App,
  Test.Env,
  Test.Fakes;

begin
{$IFDEF WINDOWS}
  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);
{$ENDIF WINDOWS}
  Glv.Testing.App.Run('Tests for GLV Openapi Library');
{$IFDEF DEBUG}
  ReadLn;
{$ENDIF DEBUG}
end.
