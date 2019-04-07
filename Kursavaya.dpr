program Kursavaya;

uses
  Forms,
  Tree in 'Tree.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Древо жизни';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
