# GLV - Openapi Библиотека - For Pascal (Delphi, FPC)

## Описание

Эта библиотека предоставляет базовую объектную модель для работы с распознанным файлом спецификаци Open API 3.1.0+

Доступ ко всем элементам спецификации организован через экземпляры интерфейсов для инкапсуляции.

## Сборка

Для использования в продуктах 

## Зависимости

| Зависимость    | Описание | Репозиторий                                          | 
| -------------- | -------- | ---------------------------------------------------- |
| TestingWrapper |          | https://github.com/GLV-off/GLV_Pascal_TestingWrapper |

### FPC Lazarus \ Code Typhon

Папка lib\pkg\lz - Файл пакета для Lazarus. открываете его в среде и пакет доступен для добавления.

## Как использовать

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
