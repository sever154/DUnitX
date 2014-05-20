program Project1;

{$APPTYPE CONSOLE}
uses
  SysUtils,
  DUnitX.AutoDetect.Console,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestRunner,
  DUnitX.TestFramework,
  Unit1 in '..\..\..\Embarcadero\Studio\Projects\Unit1.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
	ReportMemoryLeaksOnShutdown := True;
  try
    //Create the runner
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    //tell the runner how we will log things
    logger := TDUnitXConsoleLogger.Create(true);
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create;
    runner.AddLogger(logger);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;

    {$IFNDEF CI}
      //We don't want this happening when running under CI.
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
