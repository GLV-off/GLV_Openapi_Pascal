unit Glv.Openapi.Ifaces;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Generics.Collections,
  Glv.Openapi.Version,
  Glv.Openapi.Server,
  Glv.Openapi.Routes;

type
  IInfo = interface;
  IServers = interface;
  IPaths = interface;
  IPath = interface;
  IComponents = interface;

  IOpenapiDocument = interface
    function GetOpenapi: TOpenapiVersion;
    function GetInfo: IInfo;
    function GetServers: IServers;
    function GetPaths: IPaths;
    function GetComponents: IComponents;

    property Openapi: TOpenapiVersion read GetOpenapi;
    property Info: IInfo read GetInfo;
    property Servers: IServers read GetServers;
    property Paths: IPaths read GetPaths;
    property Components: IComponents read GetComponents;
  end;

  IInfo = interface
    function GetTitle: UnicodeString;
    function GetDescription: UnicodeString;
    function GetVersion: UnicodeString;

    property Title: UnicodeString read GetTitle;
    property Description: UnicodeString read GetDescription;
    property Version: UnicodeString read GetVersion;
  end;

  IPath = interface
    function GetUrl: UnicodeString;
    function GetMethod: TOpenApiMethod;
    function GetHeaders: THeaders;
    function GetParameters: TParameters;
    function GetOperationID: UnicodeString;
    function GetDescription: UnicodeString;
    function GetTags: TTags;

    property Url: UnicodeString read GetUrl;
    property Method: TOpenApiMethod read GetMethod;
    property Headers: THeaders read GetHeaders;
    property Parameters: TParameters read GetParameters;
    property OperationID: UnicodeString read GetOperationID;
    property Description: UnicodeString read GetDescription;
    property Tags: TTags read GetTags;
  end;

  IPaths = interface
    function GetItems: TEnumerable<IPath>;
    function GetByUrl(const AUrl: UnicodeString): TArray<IPath>;
    function GetByIdx(const AIdx: Integer): IPath;
    function GetCount: Integer;

    property Items: TEnumerable<IPath> read GetItems;
    property ByUrl[const AUrl: UnicodeString]: TArray<IPath> read GetByUrl;
    property ByIdx[const AIdx: Integer]: IPath  read GetByIdx;
    property Count: Integer read GetCount;
  end;

  IServers = interface
    function GetCount: Integer;
    function GetServer(const AIdx: Integer): TOpenapiServer;

    property Server[const AIdx: Integer]: TOpenapiServer read GetServer;
    property Count: Integer read GetCount;
  end;

  IComponents = interface
  end;

implementation

end.

