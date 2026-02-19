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


  TJsonInfo = class(TBaseInfo)
  strict private
    FJson: TJSONObject;
  strict protected
    function GetTitle: unicodestring; override;
    function GetDescription: unicodestring; override;
    function GetVersion: unicodestring; override;
  public
    constructor Create(const AJson: TJSONObject);
    destructor Destroy; override;
  end;


  TJsonServers = class(TBaseServers)
  strict protected
    FJson: TJSONArray;
    function GetCount: integer; override;
    function GetServer(const AIdx: integer): TOpenapiServer; override;
  public
    constructor Create(const AJson: TJSONArray); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;


  TJsonPaths = class(TBasePaths)
  strict private
    FItems: TList<IPath>;
    FJson: TJSONObject;
  strict protected
    function GetItems: TEnumerable<IPath>; override;
    function GetByUrl(const AUrl: unicodestring): TPathArray; override;
    function GetByIdx(const AIdx: integer): IPath; override;
    function GetCount: integer; override;
    procedure Parse;
  public
    constructor Create(const AItems: TList<IPath>; const AJson: TJSONObject); overload;
    constructor Create(const AJson: TJSONObject); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;


  TJsonPath = class(TBasePath)
  strict private
    FUrl: unicodestring;
    FMethod: TOpenApiMethod;
    FJson: TJSONObject;
  strict protected
    function GetUrl: unicodestring; override;
    function GetMethod: TOpenApiMethod; override;
    function GetHeaders: THeaders; override;
    function GetParameters: TParameters; override;
    function GetOperationID: unicodestring; override;
    function GetDescription: unicodestring; override;
    function GetTags: TTags; override;
  public
    constructor Create(const AUrl: unicodestring;
      const AMethod: TOpenApiMethod; const AJson: TJSONObject); overload;
    constructor Create(const AUrl: unicodestring;
      const AMethod: TOpenApiMethod); overload;
    destructor Destroy; override;
  end;


implementation

uses
  SysUtils,
  Variants,
  Glv.Openapi.FpJsonFuncs;

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

function TJsonInfo.GetTitle: unicodestring;
begin
  Result := UTF8Decode(FJson.Get('title', ''));
end;

function TJsonInfo.GetDescription: unicodestring;
begin
  Result := UTF8Decode(FJson.Get('description', ''));
end;

function TJsonInfo.GetVersion: unicodestring;
begin
  Result := UTF8Decode(FJson.Get('version', ''));
end;

{ ==== TJsonServers ========================================================= }

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

function TJsonServers.GetCount: integer;
begin
  Result := FJson.Count;
end;

function TJsonServers.GetServer(const AIdx: integer): TOpenapiServer;
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

{ =========================================================================== }

constructor TJsonPaths.Create(const AItems: TList<IPath>; const AJson: TJSONObject);
begin
  inherited Create;
  FItems := AItems;
  FJson := AJson;
  Parse();
end;

constructor TJsonPaths.Create(const AJson: TJSONObject);
begin
  inherited Create;
  FItems := TList<IPath>.Create();
  FJson := AJson;
  Parse();
end;

constructor TJsonPaths.Create;
begin
  Self.Create(TJSONObject.Create());
end;

destructor TJsonPaths.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FJson);
  inherited Destroy;
end;

function TJsonPaths.GetItems: TEnumerable<IPath>;
begin
  Result := FItems;
end;

function TJsonPaths.GetByUrl(const AUrl: unicodestring): TPathArray;
var
  Count: Integer;
  K: Integer;
  I: Integer;
  Path: IPath;
  tmpUrl: UnicodeString;
begin
  Count := 0;
  K := 0;
  Result := [];

  for I := 0 to FItems.Count - 1 do
  begin
    Path :=FItems[I];
    tmpUrl := Path.Url;
    if Path.Url = AUrl then
      Inc(Count);
  end;

  SetLength(Result, Count);
  for I := 0 to count - 1 do
  begin
    if FItems[I].Url = AUrl then
    begin
      Result[K] := FItems[I];
      Inc(K);
    end;
  end;
end;

function TJsonPaths.GetByIdx(const AIdx: integer): IPath;
begin
  Result := TJsonPath.Create('', oamGET);
end;

function TJsonPaths.GetCount: integer;
begin
  Result := Glv.Openapi.FpJsonFuncs.CountOf(FJSON, TOpenApiMethod.RawStrings());
end;

procedure TJsonPaths.Parse;
var
  tmpData: TJSONData;
  tmpObj: TJSONObject;
  tmpMethod: TJSONData;
  tmpPath: IPath;
  I: Integer;
  tmpUrl: UnicodeString;
begin
  tmpData := nil;
  for I := 0 to FJson.Count - 1 do
  begin
    tmpUrl := UTF8Decode(FJson.Names[I]);
    if FJson.Find(UTF8Encode(tmpUrl), tmpData) then
    begin
      if tmpData.InheritsFrom(TJSONObject) then
      begin
        tmpObj := TJSONObject(tmpData);
        if tmpObj.Find('get', tmpMethod) then
        begin
          if tmpMethod.InheritsFrom(TJSONObject) then
          begin
            tmpPath := TJsonPath.Create(tmpUrl, oamGET, TJSONObject(tmpMethod.Clone()));
            FItems.Add(tmpPath);
          end;
        end;

        if tmpObj.Find('post', tmpMethod) then
        begin
          if tmpMethod.InheritsFrom(TJSONObject) then
          begin
            tmpPath := TJsonPath.Create(tmpUrl, oamPOST, TJSONObject(tmpMethod.Clone()));
            FItems.Add(tmpPath);

          end;
        end;

        if tmpObj.FInd('delete', tmpMethod) then
        begin
          if tmpMethod.InheritsFrom(TJSONObject) then
          begin
            tmpPath := TJsonPath.Create(tmpUrl, oamDELETE, TJSONObject(tmpMethod.Clone()));
            FItems.Add(tmpPath);
          end;
        end;

        if tmpObj.Find('put', tmpMethod) then
        begin
          if tmpMethod.InheritsFrom(TJSONObject) then
          begin
            tmpPath := TJsonPath.Create(tmpUrl, oamPUT, TJSONObject(tmpMethod.Clone()));
            FItems.Add(tmpPath);
          end;
        end;

        if tmpObj.Find('head', tmpMethod) then
        begin
          if tmpMethod.InheritsFrom(TJSONObject) then
          begin
            tmpPath := TJsonPath.Create(tmpUrl, oamHEAD, TJSONObject(tmpMethod.Clone()));
            FItems.Add(tmpPath);
          end;
        end;
      end;
    end
    else
    begin

    end;
  end;
end;

{ ==== TJsonPath ============================================================ }

constructor TJsonPath.Create(const AUrl: unicodestring;
  const AMethod: TOpenApiMethod; const AJson: TJSONObject);
begin
  inherited Create;
  FUrl := AUrl;
  FMethod := AMethod;
  FJson := AJson;
end;

constructor TJsonPath.Create(const AUrl: unicodestring;
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

function TJsonPath.GetUrl: unicodestring;
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

function TJsonPath.GetOperationID: unicodestring;
var
  Tmp: TJSONString;
begin
  if FJson.Find('operationId', Tmp) then
    Result := Tmp.Value
  else
    Result := '';
end;

function TJsonPath.GetDescription: unicodestring;
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
  I: integer;
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
