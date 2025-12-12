unit Glv.Openapi.Server;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Generics.Collections;

type
  TOpenapiVariable = record
    Key: UnicodeString;
    Value: Variant;
  end;

  TOpenapiVariables = TDictionary<string, TOpenapiVariable>;

  TOpenapiServer = class
  strict private
    FDescription: UnicodeString;
    FUrl: UnicodeString;
    FVariables: TOpenapiVariables;
  public
    constructor Create;
    destructor Destroy; override;
    property Url: UnicodeString read FUrl write FUrl;
    property Variables: TOpenapiVariables read FVariables;
    property Description: UnicodeString read FDescription;
  end;

implementation

uses
  SysUtils;

constructor TOpenapiServer.Create;
begin
  inherited Create;
  FVariables := TOpenapiVariables.Create();
  FDescription:= '';
  FUrl:= '';
end;

destructor TOpenapiServer.Destroy;
begin
  FUrl:= '';
  FDescription:= '';
  FreeAndNil(FVariables);
  inherited Destroy;
end;

end.

