unit Glv.Openapi.Server;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Generics.Collections;

type
  TOpenapiVariable = record
    Key: UnicodeString;
    Value: Variant;
    constructor Create(const AKey: UnicodeString; const AValue: Variant);
  end;

  TOpenapiVariables = TDictionary<string, TOpenapiVariable>;

  TOpenapiServer = class
  strict private
    FUrl: UnicodeString;
    FDescription: UnicodeString;
    FVariables: TOpenapiVariables;
  public
    constructor Create(
      const AUrl: UnicodeString;
      const ADescription: UnicodeString;
      const AVariables: TOpenapiVariables); overload;
    constructor Create; overload;
    destructor Destroy; override;
    property Url: UnicodeString read FUrl write FUrl;
    property Variables: TOpenapiVariables read FVariables;
    property Description: UnicodeString read FDescription write FDescription;
  end;

implementation

uses
  SysUtils;

{ ==== TOpenapiVariable ===================================================== }

constructor TOpenapiVariable.Create(
  const AKey: UnicodeString; const AValue: Variant);
begin
  Self.Key := AKey;
  Self.Value := AValue;
end;

{ ==== TOpenapiServer ======================================================= }

constructor TOpenapiServer.Create;
begin
  Self.Create('', '', TOpenapiVariables.Create());
end;

constructor TOpenapiServer.Create(
  const AUrl: UnicodeString;
  const ADescription: UnicodeString;
  const AVariables: TOpenapiVariables);
begin
  inherited Create;
  FUrl := AUrl;
  FDescription := ADescription;
  FVariables := AVariables;
end;

destructor TOpenapiServer.Destroy;
begin
  FUrl:= '';
  FDescription:= '';
  FreeAndNil(FVariables);
  inherited Destroy;
end;

{ =========================================================================== }

end.

