unit Glv.Openapi.Routes;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Generics.Collections;

type
  TOpenApiMethod = (
    oamUnsuported,
    oamUnknown,
    oamGET,
    oamPOST,
    oamPUT,
    oamDELETE,
    oamHEAD,
    oamOPTION
  );

  THeader = UnicodeString;

  THeaders = TDictionary<UnicodeString, THeader>;

  TParameter = class(TInterfacedObject)

  end;

  TParameters = class(TObjectList<TParameter>)
  public
    constructor Create;
  end;

  TTag = UnicodeString;

  TTags = TArray<TTag>;

implementation

constructor TParameters.Create;
begin
  inherited Create(True);
end;

end.

