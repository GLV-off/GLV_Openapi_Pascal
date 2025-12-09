unit Glv.Openapi.Json;

{$I 'glv_openapi_lib.inc'}

interface

uses
{$IFDEF FPC}
  Glv.Openapi.FpcJson;
{$ELSE FPC}
  Glv.Openapi.DelphiJson;
{$ENDIF FPC}

implementation

end.

