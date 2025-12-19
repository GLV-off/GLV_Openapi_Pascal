unit Glv.Openapi.FpJsonFuncs;

{$I 'glv_openapi_lib.inc'}

interface

uses
  FpJson;

{}
function CountOf(const AJson: TJSONObject; const AKeys: TArray<UnicodeString>): Integer;

implementation

function CountOfImpl(const AJson: TJSONObject; const AKeys: TArray<UnicodeString>): Integer; forward;
function CountOfJsonObject(const AJson: TJSONObject; const AKeys: TArray<UnicodeString>): Integer; forward;

function CountOf(const AJson: TJSONObject; const AKeys: TArray<UnicodeString>): Integer;
begin
  Result := 0;
  if AJson.Count <= 0 then
    Exit;

  Result := CountOfImpl(AJson, AKeys);
end;

function CountOfImpl(const AJson: TJSONObject; const AKeys: TArray<UnicodeString>): Integer;
var
  I: Integer;
  J: Integer;
  jData: TJSONData;
begin
  Result := 0;
  for I := 0 to AJson.Count - 1 do
  begin
    for J := 0 to Length(AKeys) - 1 do
    begin
      if AJson.Names[I] = UTF8Encode(AKeys[J]) then
        Inc(Result);
    end;
    jData := AJson.Items[I];
    if jData.InheritsFrom(TJSONObject) then
      Result := Result + CountOf(TJSONObject(jData), AKeys);
  end;
end;

function CountOfJsonObject(const AJson: TJSONObject; const AKeys: TArray<UnicodeString>): Integer;
var
  I: Integer;
  J: Integer;
  Key: TJSONStringType;
begin
  Result := 0;
  for I := 0 to AJson.Count - 1 do
  begin
    Key := AJson.Names[i];
    for J := 0 to Length(AKeys) -  1 do
    begin
      if Key = AKeys[J] then
        Inc(Result, 1);
    end;
  end;
end;

end.

