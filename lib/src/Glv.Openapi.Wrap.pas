unit Glv.Openapi.Wrap;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Glv.Openapi.Version,
  Glv.Openapi.Server,
  Glv.Openapi.Ifaces;

type
  {

  }
  TBaseOpenapiDocument = class(TInterfacedObject, IOpenapiDocument)
  strict protected
    function GetOpenapi: TOpenapiVersion; virtual; abstract;
    function GetInfo: IInfo; virtual; abstract;
    function GetServers: IServers; virtual; abstract;
    function GetPaths: IPaths; virtual; abstract;
    function GetComponents: IComponents; virtual; abstract;
  public
    property Openapi: TOpenapiVersion read GetOpenapi;
    property Info: IInfo read GetInfo;
    property Servers: IServers read GetServers;
    property Paths: IPaths read GetPaths;
    property Components: IComponents read GetComponents;
  end;

  TBaseInfo = class abstract (TInterfacedObject, IInfo)
  strict protected
    function GetTitle: UnicodeString; virtual; abstract;
    function GetDescription: UnicodeString; virtual; abstract;
    function GetVersion: UnicodeString; virtual; abstract;
  public
    property Title: UnicodeString read GetTitle;
    property Description: UnicodeString read GetDescription;
    property Version: UnicodeString read GetVersion;
  end;

  TBaseServers = class abstract(TInterfacedObject, IServers)
  strict protected
    function GetCount: Integer; virtual; abstract;
    function GetServer(const AIdx: Integer): TOpenapiServer; virtual; abstract;
  public
    property Server[const AIdx: Integer]: TOpenapiServer read GetServer;
    property Count: Integer read GetCount;
  end;

  {

  }
  TWrapOpenapiDocument = class(TBaseOpenapiDocument)
  strict private
    FOrigin: IOpenapiDocument;
  strict protected
    function GetOpenapi: TOpenapiVersion; override;
    function GetInfo: IInfo; override;
    function GetServers: IServers; override;
    function GetPaths: IPaths; override;
    function GetComponents: IComponents; override;
  public
    constructor Create(const AOrigin: IOpenapiDocument);
    destructor Destroy; override;
  end;

  TDefaultOpenapiDocument = class(TBaseOpenapiDocument)
  strict private
    FOpenapi: TOpenapiVersion;
    FInfo: IInfo;
    FServers: IServers;
    FPaths: IPaths;
    FComponents: IComponents;
  strict protected
    function GetOpenapi: TOpenapiVersion; override;
    function GetInfo: IInfo; override;
    function GetServers: IServers; override;
    function GetPaths: IPaths; override;
    function GetComponents: IComponents; override;
  public
    constructor Create(
      const AOpenapi: TOpenapiVersion
    );
    destructor Destroy; override;
  end;

implementation

{ ==== TWrapOpenapiDocument ================================================= }

constructor TWrapOpenapiDocument.Create(const AOrigin: IOpenapiDocument);
begin
  inherited Create;
  FOrigin := AOrigin;
end;

destructor TWrapOpenapiDocument.Destroy;
begin
  FOrigin := nil;
  inherited Destroy;
end;

function TWrapOpenapiDocument.GetOpenapi: TOpenapiVersion;
begin
  Result := FOrigin.Openapi;
end;

function TWrapOpenapiDocument.GetInfo: IInfo;
begin
  Result := FOrigin.Info;
end;

function TWrapOpenapiDocument.GetServers: IServers;
begin
  Result := FOrigin.Servers;;
end;

function TWrapOpenapiDocument.GetPaths: IPaths;
begin
  Result := FOrigin.Paths;
end;

function TWrapOpenapiDocument.GetComponents: IComponents;
begin
  Result := FOrigin.Components;
end;

function TDefaultOpenapiDocument.GetOpenapi: TOpenapiVersion;
begin
  Result := FOpenapi;
end;

function TDefaultOpenapiDocument.GetInfo: IInfo;
begin
  Result := FInfo;
end;

function TDefaultOpenapiDocument.GetServers: IServers;
begin
  Result := FServers;
end;

function TDefaultOpenapiDocument.GetPaths: IPaths;
begin
  Result := FPaths;
end;

function TDefaultOpenapiDocument.GetComponents: IComponents;
begin
  Result := FComponents;
end;

constructor TDefaultOpenapiDocument.Create(
  const AOpenapi: TOpenapiVersion
);
begin
  inherited Create;
  FOpenapi := AOpenapi;
end;

destructor TDefaultOpenapiDocument.Destroy;
begin
  FOpenapi.Version := '';
  FInfo := nil;
  FServers := nil;
  FPaths := nil;
  FComponents := nil;
  inherited Destroy;
end;

{ =========================================================================== }

end.

