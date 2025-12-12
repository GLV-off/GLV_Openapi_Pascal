unit Glv.Openapi.FpcJson;

{$I 'glv_openapi_lib.inc'}

interface

uses
  FpJson,
  Glv.Openapi.Version,
  Glv.Openapi.Ifaces;

type
  TJsonOpenapiDocument = class(TInterfacedObject, IOpenapiDocument)
  strict private
    FJson: TJSONObject;
  private
    function GetOpenapi: TOpenapiVersion; virtual; abstract;
    function GetInfo: IInfo; virtual; abstract;
    function GetServers: IServers; virtual; abstract;
    function GetPaths: IPaths; virtual; abstract;
    function GetComponents: IComponents; virtual; abstract;
  public
    constructor Create(const AJson: TJSONObject);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

constructor TJsonOpenapiDocument.Create(const AJson: TJSONObject);
begin
  inherited Create;
  FJson := AJson;
end;

destructor TJsonOpenapiDocument.Destroy;
begin
  FreeAndNil(FJson);
  inherited Destroy;
end;

end.

