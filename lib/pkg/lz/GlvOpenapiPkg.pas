{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit GlvOpenapiPkg;

{$warn 5023 off : no warning about unused units}
interface

uses
  Glv.Openapi, Glv.Openapi.Ifaces, Glv.Openapi.Json, Glv.Openapi.Version, 
  Glv.Openapi.FpcJson, Glv.Openapi.Wrap, Glv.Openapi.Server, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('GlvOpenapiPkg', @Register);
end.
