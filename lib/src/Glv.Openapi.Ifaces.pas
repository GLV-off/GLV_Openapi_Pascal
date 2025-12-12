unit Glv.Openapi.Ifaces;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Glv.Openapi.Version,
  Glv.Openapi.Server;

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

  IPaths = interface
  end;

  IPath = interface
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

