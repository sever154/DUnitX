{***************************************************************************}
{                                                                           }
{           DUnitX                                                          }
{                                                                           }
{           Copyright (C) 2013 Vincent Parrett                              }
{                                                                           }
{           vincent@finalbuilder.com                                        }
{           http://www.finalbuilder.com                                     }
{                                                                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

unit DUnitX.MemoryLeakMonitor.Default;

interface

{$I DUnitX.inc}

uses
  classes,
  DUnitX.TestFramework;

type
  TDUnitXDefaultMemoryLeakMonitor = class(TInterfacedObject,IMemoryLeakMonitor)
  private
  	FPreMemoryManagerState	: TMemoryManagerState;
    FPostMemoryManagerState	: TMemoryManagerState;

    FSetupMemoryAllocated			: Int64;
    FTearDownMemoryAllocated	: Int64;
    FTestMemoryAllocated			: Int64;

    procedure CompareMemoryState;
  public
    procedure PreSetup;
    procedure PostSetup;
    procedure PreTest;
    procedure PostTest;
    procedure PreTearDown;
    procedure PostTearDown;

    function SetupMemoryAllocated: Int64;
    function TearDownMemoryAllocated: Int64;
    function TestMemoryAllocated: Int64;
  end;



  procedure RegisterDefaultProvider;

implementation

uses
  DUnitX.IoC;


procedure RegisterDefaultProvider;
begin
  TDUnitXIoC.DefaultContainer.RegisterType<IMemoryLeakMonitor>(
    function : IMemoryLeakMonitor
    begin
      result := TDUnitXDefaultMemoryLeakMonitor.Create;
    end);
end;

procedure TDUnitXDefaultMemoryLeakMonitor.CompareMemoryState;
var
	I	: Integer;
begin
  if Length(FPreMemoryManagerState.SmallBlockTypeStates)
  	<> Length(FPostMemoryManagerState.SmallBlockTypeStates) then
      begin
        FSetupMemoryAllocated := 2;
      end
  else
    begin
    	for I := 0 to Length(FPreMemoryManagerState.SmallBlockTypeStates) do
      begin
      	if FPreMemoryManagerState.SmallBlockTypeStates[I].AllocatedBlockCount <>
        	FPostMemoryManagerState.SmallBlockTypeStates[I].AllocatedBlockCount then
            begin
            	Inc(FSetupMemoryAllocated, (FPostMemoryManagerState.SmallBlockTypeStates[I].UseableBlockSize) * (FPostMemoryManagerState.SmallBlockTypeStates[I].AllocatedBlockCount - FPreMemoryManagerState.SmallBlockTypeStates[I].AllocatedBlockCount));
            end;
      end;
    end;
end;
{ TDUnitXDefaultMemoryLeakMonitor }

procedure TDUnitXDefaultMemoryLeakMonitor.PostSetup;
begin
//	ScanForMemoryLeaks;
	GetMemoryManagerState(FPostMemoryManagerState);
	CompareMemoryState;
end;

procedure TDUnitXDefaultMemoryLeakMonitor.PostTearDown;
begin
//	ScanForMemoryLeaks;
end;

procedure TDUnitXDefaultMemoryLeakMonitor.PostTest;
begin

end;

procedure TDUnitXDefaultMemoryLeakMonitor.PreSetup;
begin
	GetMemoryManagerState(FPreMemoryManagerState);
//  if  then

end;

procedure TDUnitXDefaultMemoryLeakMonitor.PreTearDown;
begin

end;

procedure TDUnitXDefaultMemoryLeakMonitor.PreTest;
begin

end;

function TDUnitXDefaultMemoryLeakMonitor.SetupMemoryAllocated: Int64;
begin
  Result := FSetupMemoryAllocated;
end;

function TDUnitXDefaultMemoryLeakMonitor.TearDownMemoryAllocated: Int64;
begin
  Result := 0;
end;

function TDUnitXDefaultMemoryLeakMonitor.TestMemoryAllocated: Int64;
begin
  Result := 0;
end;

end.
