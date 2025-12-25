unit Glv.Openapi;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Classes,
  Glv.Openapi.Version,
  Glv.Openapi.Ifaces;

type
  TOpenapiVersion = Glv.Openapi.Version.TOpenapiVersion;
  IOpenapiDocument = Glv.Openapi.Ifaces.IOpenapiDocument;
  IInfo = Glv.Openapi.Ifaces.IInfo;
  IServers = Glv.Openapi.Ifaces.IServers;
  IPaths = Glv.Openapi.Ifaces.IPaths;
  IPath = Glv.Openapi.Ifaces.IPath;

{

}
function LoadJsonFromFile(const AFilepath: UnicodeString): IOpenapiDocument;

function LoadJsonFromStream(const AStream: TStream): IOpenapiDocument;

implementation

uses
  SysUtils,
  Glv.Openapi.Json;

function LoadJsonFromFile(const AFilepath: UnicodeString): IOpenapiDocument;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(UTF8Encode(AFilepath), fmOpenRead or fmShareCompat);
  try
    Result := LoadJsonFromStream(Stream);
  finally
    FreeAndNil(Stream);
  end;
end;

function LoadJsonFromStream(const AStream: TStream): IOpenapiDocument;
begin
  Result := Glv.OpenApi.Json.LoadJsonFromStream(AStream);
end;

end.

