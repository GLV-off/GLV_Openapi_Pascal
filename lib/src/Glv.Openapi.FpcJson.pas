unit Glv.Openapi.FpcJson;

{$I 'glv_openapi_lib.inc'}

interface

uses
  FpJson,
  Glv.Openapi.Version,
  Glv.Openapi.Server,
  Glv.Openapi.Ifaces,
  Glv.Openapi.Wrap;

type
  {

  }
  TJsonOpenapiDocument = class(TBaseOpenapiDocument)
  strict private
    FJson: TJSONObject;
  strict protected
    function GetOpenapi: TOpenapiVersion; override;
    function GetInfo: IInfo; override;
    function GetServers: IServers; override;
    function GetPaths: IPaths; override;
    function GetComponents: IComponents; override;
  public
    constructor Create(const AJson: TJSONObject); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

  {

  }
  TJsonInfo = class(TBaseInfo)
  strict private
    FJson: TJSONObject;
  strict protected
    function GetTitle: UnicodeString; override;
    function GetDescription: UnicodeString; override;
    function GetVersion: UnicodeString; override;
  public
    constructor Create(const AJson: TJSONObject);
    destructor Destroy; override;
  end;

  {

  }
  TJsonServers = class(TBaseServers)
  strict protected
    FJson: TJSONArray;
    function GetCount: Integer; override;
    function GetServer(const AIdx: Integer): TOpenapiServer; override;
  public
    constructor Create(const AJson: TJSONArray); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  Variants;

{ ==== TJsonOpenapiDocument ================================================= }

constructor TJsonOpenapiDocument.Create(const AJson: TJSONObject);
begin
  inherited Create;
  FJson := AJson;
end;

constructor TJsonOpenapiDocument.Create;
begin
  Self.Create(TJSONObject.Create());
end;

destructor TJsonOpenapiDocument.Destroy;
begin
  FreeAndNil(FJson);
  inherited Destroy;
end;

function TJsonOpenapiDocument.GetOpenapi: TOpenapiVersion;
var
  Tmp: TJSONString;
begin
  if FJson.Find('openapi', Tmp) then
    Result := TOpenapiVersion.Create(Tmp.Value)
  else
    Result := TOpenapiVersion.Create('');
end;

function TJsonOpenapiDocument.GetInfo: IInfo;
var
  TmpJson: TJSONObject;
begin
  if FJson.Find('info', TmpJson) then
    Result := TJsonInfo.Create(TJSONObject(TmpJson.Clone))
  else
    Result := TJsonInfo.Create(TJSONObject.Create());
end;

function TJsonOpenapiDocument.GetServers: IServers;
var
  TmpJson: TJSONArray;
begin
  if FJson.Find('servers', TmpJson) then
    Result := TJsonServers.Create(TJSONArray(TmpJson.Clone))
  else
    Result := TJsonServers.Create();
end;

function TJsonOpenapiDocument.GetPaths: IPaths;
begin
  Result := nil;
end;

function TJsonOpenapiDocument.GetComponents: IComponents;
begin
  Result := nil;
end;

{ ==== TJsonInfo ============================================================ }

constructor TJsonInfo.Create(const AJson: TJSONObject);
begin
  inherited Create;
  FJson := AJson;
end;

destructor TJsonInfo.Destroy;
begin
  FreeAndNil(FJson);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }

function TJsonInfo.GetTitle: UnicodeString;
begin
  Result := UTF8Decode(FJson.Get('title', ''));
end;

function TJsonInfo.GetDescription: UnicodeString;
begin
  Result := UTF8Decode(FJson.Get('description', ''));
end;

function TJsonInfo.GetVersion: UnicodeString;
begin
  Result := UTF8Decode(FJson.Get('version', ''));
end;

function TJsonServers.GetCount: Integer;
begin
  Result := FJson.Count;
end;

function TJsonServers.GetServer(const AIdx: Integer): TOpenapiServer;
var
  Item: TJSONData;
  Tmp: TJSONString;
  Obj: TJSONObject;
begin
  if (AIdx >= 0) and (AIdx < FJson.Count) then
  begin
    Item := FJson[AIdx];
    if Item.InheritsFrom(TJSONObject) then
    begin
      Obj := TJSONObject(Item);
      Result := TOpenapiServer.Create();
      if Obj.Find('url', Tmp) then
        Result.Url := Tmp.Value;
      if Obj.Find('description', Tmp) then
        Result.Description := Tmp.Value;
    end
    else
      Result := TOpenapiServer.Create();
  end
  else
  begin
    Result := TOpenapiServer.Create();
  end;
end;

constructor TJsonServers.Create(const AJson: TJSONArray);
begin
  inherited Create;
  FJson := AJson;
end;

constructor TJsonServers.Create;
begin
  Self.Create(TJSONArray.Create());
end;

destructor TJsonServers.Destroy;
begin
  FreeAndNil(FJson);
  inherited Destroy;
end;

{ =========================================================================== }

end.

