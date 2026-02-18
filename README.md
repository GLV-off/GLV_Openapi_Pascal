# GLV - Openapi Library - For Pascal (Delphi, FPC)

## Description

This library adding basic object model to work with parsed Open API Specification 3.1.0+

Access to all elements arranged throug interface instances for encapsulation.

## Language 

docs\README_RU.md - Russian language description of project

## Dependencies

| Dependency     | Description | Repository                                           | 
| -------------- | ----------- | ---------------------------------------------------- |
| `TestingWrapper` | Used in autotests. Wrapper around DUnit and FPUnit for share testing code base. Under development. Want add support for DUnitX. | https://github.com/GLV-off/GLV_Pascal_TestingWrapper |

## How build

### Lazarus

Open `lib\pkg\lz\GlvOpenapiPkg.lpk` as package, build it and add to your project as package. Or specify in search path of your project path to `lib\src` folder.

### Code Typhon

Support is planing. At source level it fully ready to use. Package file not added yet but will be.

### Delphi

Open `lib\pkg\d12\GlvOpenapiPkg.dproj`, build it. Then you can refer to output path `lib\out\$(Platform)\$(Config)` at desired project or directly to sources by specify `lib\src` folder.

## How use

Example 1

``` pascal
uses
  Glv.Openapi;

procedure Demo
var
  Doc: IOpenapiDocument;
  OpenApiVer: TOpenapiVersion;
  Info: IInfo;
begin
  Doc := Glv.Openapi.LoadJsonFromFile('openapi_spec.json');
  try
    OpenApiVer := Doc.OpenapiVersion;
    WriteLn('openapi: ', OpenApiVer.Version);
  finally
    Doc := nil;
  end;
end;
```

## Auto test's

This project want to be coveret by autotesting.

If you want to run test's, you should download `Testingwrapper` package and install it.

## Contacts

TODO