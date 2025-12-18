unit Glv.Openapi.Routes;

{$I 'glv_openapi_lib.inc'}

interface

uses
  SysUtils,
  Generics.Defaults,
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
  public

  end;

  TParameters = class(TObjectDictionary<UnicodeString, TParameter>)
  public
    constructor Create;
  end;

  TTag = UnicodeString;

  TTags = TArray<TTag>;

  TOpenapiRoute = class
  strict private
    FMethod: TOpenApiMethod;
    FPath: UnicodeString;
    FOperationID: UnicodeString;
    FParameters: TParameters;
    FTags: TTags;
    FHeaders: THeaders;
  public
    constructor Create(
      const AMethod: TOpenApiMethod;
      const APath: UnicodeString;
      const AOperationID: UnicodeString;
      const AParameters: TParameters;
      const ATags: TTags;
      const AHeaders: THeaders);
    destructor Destroy; override;
  end;

  TOpenapiRoutes = TObjectDictionary<UnicodeString, TOpenApiRoute>;

  TOpenapiPath = class
  strict private
    FPath: UnicodeString;
    FRoutes: TOpenapiRoutes;
  public
    constructor Create(
      const APath: UnicodeString;
      const ARoutes: TOpenapiRoutes
    );
    destructor Destroy; override;
  end;

implementation

constructor TParameters.Create;
begin
  inherited Create([doOwnsValues]);
end;

constructor TOpenapiRoute.Create(
  const AMethod: TOpenApiMethod;
  const APath: UnicodeString;
  const AOperationID: UnicodeString;
  const AParameters: TParameters;
  const ATags: TTags;
  const AHeaders: THeaders);
begin
  inherited Create;
  FMethod := AMethod;
  FPath := APath;
  FOperationID := AOperationID;
  FParameters := AParameters;
  FTags := ATags;
  FHeaders := AHeaders;
end;

destructor TOpenapiRoute.Destroy;
begin
  FreeAndNil(FHeaders);
  FreeaNdNil(FParameters);
  inherited Destroy;
end;

constructor TOpenapiPath.Create(
  const APath: UnicodeString;
  const ARoutes: TOpenapiRoutes);
begin
  inherited Create;
  FPath := APath;
  FRoutes := ARoutes;
end;

destructor TOpenapiPath.Destroy;
begin
  FPath := '';
  FreeAndNil(FRoutes);
  inherited Destroy;
end;

end.

