unit Demo.App;

{$I 'glv_openapi_demo.inc'}

interface

procedure Run;

implementation

uses
  SysUtils,
  Generics.Collections,
  Glv.Openapi,
  Glv.Openapi.Routes,
  Demo.Env;

procedure RunImpl; forward;
procedure LoadingOpenapiSpecification(const APath: UnicodeString); forward;
procedure WriteOpenapiDocument(const ADocument: IOpenapiDocument); forward;
procedure WriteOpenapi(const AOpenapi: TOpenapiVersion); forward;
procedure WriteInfo(const AInfo: IInfo); forward;
procedure WriteServers(const AServers: IServers); forward;
procedure WritePaths(const APaths: IPaths); forward;
procedure WritePath(const APath: IPath); forward;

procedure Run;
begin
  try
    RunImpl();
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
{$IFDEF DEBUG}
  ReadLn;
{$ENDIF DEBUG}
end;

procedure RunImpl;
begin
  LoadingOpenapiSpecification(
    TEnv.GetAsset('demo_spec.json')
  );
end;

procedure LoadingOpenapiSpecification(const APath: UnicodeString);
var
  Spec: IOpenapiDocument;
begin
  Spec := LoadJsonFromFile(APath);
  try
    WriteOpenapiDocument(Spec);
  finally
    Spec := nil;
  end;
end;

procedure WriteOpenapiDocument(const ADocument: IOpenapiDocument);
begin
  WriteOpenapi(ADocument.Openapi);
  WriteInfo(ADocument.Info);
  WriteServers(ADocument.Servers);
  WritePaths(ADocument.Paths);
  WriteLn('<todo>');
end;

procedure WriteOpenapi(const AOpenapi: TOpenapiVersion);
begin
  WriteLn('openapi: ', AOpenapi.Version);
end;

procedure WriteInfo(const AInfo: IInfo);
const
  SHIFT: string = '  ';
begin
  WriteLn('info:');
  WriteLn(SHIFT, 'version: ', AInfo.Version);
  WriteLn(SHIFT, 'description: ', AInfo.Description);
  WriteLn(SHIFT, 'title: ', AInfo.Title);
end;

procedure WriteServers(const AServers: IServers);
const
  SHIFT: string = '  ';
begin
  WriteLn('servers:');
  WriteLn(SHIFT,'<todo-servers>');
end;

procedure WritePaths(const APaths: IPaths);
var
  Itr: TEnumerable<IPath>;
  Path: IPath;
begin
  WriteLn('paths:');
  Itr := APaths.Items;
  for Path in Itr do
    WritePath(Path);
end;

procedure WritePath(const APath: IPath);
const
  SHIFT: string = '  ';
begin
  WriteLn(SHIFT, APath.Url);
  WriteLn('method: ', APath.Method.ToHttpStr());
  WriteLn('headers: <todo-headers>');
  WriteLn('operationId: ', APath.OperationID);
  WriteLn('description: ', APath.Description);
  WriteLn('tags: ', '<todo-tags>');

  //property Headers: THeaders read GetHeaders;
  //property Parameters: TParameters read GetParameters;
  //property OperationID: UnicodeString read GetOperationID;
  //property Description: UnicodeString read GetDescription;
  //property Tags: TTags read GetTags;
end;

end.

