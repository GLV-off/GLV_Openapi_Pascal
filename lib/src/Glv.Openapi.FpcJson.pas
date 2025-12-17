unit Glv.Openapi.FpcJson;

{$I 'glv_openapi_lib.inc'}

interface

uses
  FpJson,
  Generics.Collections,
  Glv.Openapi.Version,
  Glv.Openapi.Server,
  Glv.Openapi.Ifaces,
  Glv.OPenapi.Routes,
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

  {
  }
  TJsonPaths = class(TBasePaths)
  strict private
    FJson: TJSONObject;
  strict protected
    function GetItems: TEnumerable<IPath>; override;
    function GetByUrl(const AUrl: UnicodeString): TArray<IPath>; override;
    function GetByIdx(const AIdx: Integer): IPath; override;
    function GetCount: Integer; override;
  public
    constructor Create(const AJson: TJSONObject); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

  {

  }
  TJsonPath = class(TBasePath)
  strict private
    FUrl: UnicodeString;
    FMethod: TOpenApiMethod;
    FJson: TJSONObject;
  strict protected
    function GetUrl: UnicodeString; override;
    function GetMethod: TOpenApiMethod; override;
    function GetHeaders: THeaders; override;
    function GetParameters: TParameters; override;
    function GetOperationID: UnicodeString; override;
    function GetDescription: UnicodeString; override;
    function GetTags: TTags; override;
  public
    constructor Create(
      const AUrl: UnicodeString;
      const AMethod: TOpenApiMethod;
      const AJson: TJSONObject); overload;
    constructor Create(
      const AUrl: UnicodeString;
      const AMethod: TOpenApiMethod); overload;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  Variants;

{ ==== FUNCTION'S =========================================================== }

function CountOf(const AJson: TJSONObject; const AKeys: TArray<string>): Integer;
var
  J: Integer;
  I: Integer;
  Obj: TJSONObject;
  X: TJSONData;
  SubCount: Integer;
  Tmp: TJSONData;
begin
  Result := 0;
  for I := 0 to AJson.Count - 1 do
  begin
    SubCount := 0;
    X := AJson.Items[I];
    if X.InheritsFrom(TJSONObject) then
    begin
      Obj := TJSONObject(X);
      for J := 0 to Length(AKeys) - 1 do
      begin
        if Obj.Find(AKeys[J], Tmp) then
          Inc(SubCount, CountOf(Obj, AKeys))
      end;
      if SubCount <= 0 then
        Inc(SubCount, 1);
    end;
    Inc(Result, SubCount);
  end;
end;

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
var
  Tmp: TJSONObject;
begin
  if FJson.Find('paths', Tmp) then
    Result := TJsonPaths.Create(TJSONObject(Tmp.Clone))
  else
    Result := TJsonPaths.Create();
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

function TJsonPaths.GetItems: TEnumerable<IPath>;
var
  List: TList<IPath>;
begin
  List := TList<IPath>.Create();
  //List.Capacity :=
  Result := List;
end;

function TJsonPaths.GetByUrl(const AUrl: UnicodeString): TArray<IPath>;
begin
  Result := nil;
  SetLength(Result, 0);
end;

function TJsonPaths.GetByIdx(const AIdx: Integer): IPath;
begin
  Result := TJsonPath.Create('', oamGET);
end;

function TJsonPaths.GetCount: Integer;
begin
  Result := CountOf(FJSON, ['get', 'post', 'put', 'delete']);
end;

constructor TJsonPaths.Create(const AJson: TJSONObject);
begin
  inherited Create;
  FJson := AJson;
end;

constructor TJsonPaths.Create;
begin
  Self.Create(TJSONObject.Create());
end;

destructor TJsonPaths.Destroy;
begin
  FreeAndNil(FJson);
  inherited Destroy;
end;

{ ==== TJsonPath ============================================================ }

constructor TJsonPath.Create(
  const AUrl: UnicodeString;
  const AMethod: TOpenApiMethod;
  const AJson: TJSONObject);
begin
  inherited Create;
  FUrl := AUrl;
  FMethod := AMethod;
  FJson := AJson;
end;

constructor TJsonPath.Create(
  const AUrl: UnicodeString;
  const AMethod: TOpenApiMethod);
begin
  Self.Create(AUrl, AMethod, TJSONObject.Create());
end;

destructor TJsonPath.Destroy;
begin
  FreeAndNil(FJson);
  FUrl := '';
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }

function TJsonPath.GetUrl: UnicodeString;
begin
  Result := FUrl;
end;

function TJsonPath.GetMethod: TOpenApiMethod;
begin
  Result := FMethod;
end;

function TJsonPath.GetHeaders: THeaders;
begin
  Result := THeaders.Create();
end;

function TJsonPath.GetParameters: TParameters;
begin
  Result := TParameters.Create();
end;

function TJsonPath.GetOperationID: UnicodeString;
var
  Tmp: TJSONString;
begin
  if FJson.Find('operationId', Tmp) then
    Result := Tmp.Value
  else
    Result := '';
end;

function TJsonPath.GetDescription: UnicodeString;
var
  Tmp: TJSONString;
begin
  if FJson.Find('description', Tmp) then
    Result := Tmp.Value
  else
    Result := '';
end;

function TJsonPath.GetTags: TTags;
var
  Items: TTags;
  Tmp: TJSONArray;
  TmpItem: TJSONData;
  TmpStr: TJSONString;
  I: Integer;
begin
{$IFDEF FPC}
  Result := [];
{$ENDIF FPC}
  if FJson.Find('tags', Tmp) then
  begin
    SetLength(Result, Tmp.Count);
    for I := 0 to Tmp.Count - 1 do
    begin
      TmpItem := Tmp[I];
      if TmpItem.InheritsFrom(TJSONString) then
      begin
        TmpStr := TJSONString(TmpItem);
        Result[I] := TmpStr.Value;
      end;
    end;
  end
  else
    SetLength(Result, 0);
end;

{ =========================================================================== }

end.

