unit Glv.Openapi.Ifaces;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Glv.Openapi.Version;

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
    function GetSummary: UnicodeString;
    property Summary: UnicodeString read GetSummary;
  end;

  IPaths = interface
  end;

  IPath = interface
  end;

  IServers = interface
  end;

  IComponents = interface
  end;

implementation

end.

