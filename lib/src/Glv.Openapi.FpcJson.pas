unit Glv.Openapi.FpcJson;

{$I 'glv_openapi_lib.inc'}

interface

uses
  Glv.Openapi.Ifaces;

type
  TJsonOpenapiDocument = class(TInterfacedObject, IOpenapiDocument)
  private
    FOrigin: IOpenapiDocument;
  public
    constructor Create(const AOrigin: IOpenapiDocument);
    destructor Destroy; override;
  end;

  TJsonPath = class(TInterfacedObject, IPath)
  public
  end;

  TJsonPaths = class(TInterfacedObject, IPaths)
  public
  end;

implementation

end.

