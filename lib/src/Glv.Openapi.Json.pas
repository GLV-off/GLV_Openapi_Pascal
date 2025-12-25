unit Glv.Openapi.Json;

{$I 'glv_openapi_lib.inc'}

interface

uses
  SysUtils,
  Classes,
{$IFDEF FPC}
  Glv.Openapi.FpcJson;
{$ELSE FPC}
  Glv.Openapi.DelphiJson;
{$ENDIF FPC}

type
{$IFDEF FPC}
  TJsonOpenapiDocument = Glv.Openapi.FpcJson.TJsonOpenapiDocument;
{$ELSE FPC}
  TJsonOpenapiDocument = Glv.Openapi.DelphiJson.TJsonOpenapiDocument;
{$ENDIF FPC}

function LoadJsonFromStream(const AStream: TStream): TJsonOpenapiDocument;

implementation

uses
  JsonParser,
  FpJson;

function LoadJsonFromStream(const AStream: TStream): TJsonOpenapiDocument;
var
  JsonObject: TJSONObject;
  JsonData: TJSONData;
begin
  JsonData := nil;
  try
    JsonData := GetJSON(AStream);
    if Assigned(JsonData) and JsonData.InheritsFrom(TJSONObject) then
    begin
      JsonObject := TJSONObject(JsonData);
      Result := TJsonOpenapiDocument.Create(JsonObject);
    end
    else
    begin
      Result := TJsonOpenapiDocument.Create();
    end;
  except
    on E: Exception do
    begin
      WriteLn('Parsing json from stream failed: ', E.Classname, E.Message);
    end;
  end;
end;

end.

