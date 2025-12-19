unit Glv.Openapi.Routes;

{$I 'glv_openapi_lib.inc'}

interface

uses
  TypInfo,
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

  TOpenApiMethodHelper = record helper for TOpenApiMethod
    {}
    function ToHttpStr: UnicodeString;
    {}
    class function RawStrings: TArray<UnicodeString>; static;
    {}
    function IsRealMethod: Boolean;
  end;

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

function TOpenApiMethodHelper.ToHttpStr: UnicodeString;
begin
  Result := UTF8Decode(GetEnumName(TypeInfo(Self), Ord(Self)));
  Result := Copy(Result, 4);
  Result := LowerCase(Result);
end;

class function TOpenApiMethodHelper.RawStrings: TArray<UnicodeString>;
begin
  REsult := [
    oamGET.ToHttpStr,
    oamPOST.ToHttpStr,
    oamPUT.ToHttpStr,
    oamDELETE.ToHttpStr,
    oamHEAD.ToHttpStr,
    oamOPTION.ToHttpStr
  ];
end;

function TOpenApiMethodHelper.IsRealMethod: Boolean;
begin
  Result := (Self <> oamUnknown) and (Self <> oamUnsuported);
end;

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

