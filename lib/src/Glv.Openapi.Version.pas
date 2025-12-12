unit Glv.Openapi.Version;

{$I 'glv_openapi_lib.inc'}

interface

type
  {
  }
  TOpenapiVersion = record
    Version: UnicodeString;
    constructor Create(const AValue: UnicodeString);
  end;

implementation

constructor TOpenapiVersion.Create(const AValue: UnicodeString);
begin
  Self.Version := AValue;
end;

end.

