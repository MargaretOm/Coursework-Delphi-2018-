unit Tree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Menus, XPMan, ExtCtrls;

type
  TForm1 = class(TForm)
    FIOLabel: TLabel;
    FIOEdit: TEdit;
    DateLabel: TLabel;
    DateEdit: TEdit;
    SexMaleRadioButton: TRadioButton;
    SexFemaleRadioButton: TRadioButton;
    SexLabel: TLabel;
    AllUsersListBox: TListBox;
    RelationButton: TButton;
    RelationTypeComboBox: TComboBox;
    AddButton: TButton;
    ParentsListBox: TListBox;
    GoToProfileButton: TButton;
    BrotherSisterLabel: TLabel;
    ChildrenLabel: TLabel;
    GrandParentsLabel: TLabel;
    SaveButton: TButton;
    ActionList1: TActionList;
    actSave: TAction;
    actGoToProfile: TAction;
    ParentsLabel: TLabel;
    BrotherSisterListBox: TListBox;
    ChildrenListBox: TListBox;
    GrandParentsListBox: TListBox;
    HusbandWifeListBox: TListBox;
    GrandChildrenListBox: TListBox;
    GrandChildrenLabel: TLabel;
    HusbandWifeLabel: TLabel;
    DeleteProfileButton: TButton;
    MainMenu1: TMainMenu;
    FileMenuItem: TMenuItem;
    NewMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    actDelete: TAction;
    DeleteRalationButton: TButton;
    actDeleteRalation: TAction;
    actRalation: TAction;
    XPManifest1: TXPManifest;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    procedure Output;
    procedure OutputPerents;
    procedure OutputChildren;
    procedure OutputBrotherSister;
    procedure OutputGrandPerents;
    procedure OutputGrandChildren;
    procedure OutputHusbandWife;
    procedure ClearListBox;
    procedure EditUpdate;

    procedure AddButtonClick(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure actGoToProfileExecute(Sender: TObject);
    procedure actGoToProfileUpdate(Sender: TObject);
    procedure SaveMenuItemClick(Sender: TObject);
    procedure OpenMenuItemClick(Sender: TObject);
    procedure NewMenuItemClick(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actRalationExecute(Sender: TObject);
    procedure actRalationUpdate(Sender: TObject);
    procedure actDeleteRalationExecute(Sender: TObject);
    procedure actDeleteRalationUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TPeople = record
    ID : integer;
    FIO : string[45];
    DateBith : string[45];
    Pol : string[7];
    ID_Mother : integer;
    ID_Father : integer;
    ID_HusbandWife : integer;
  end;
  ListPeople = ^TListPeople;
  TListPeople = record
    People : TPeople;
    Next : ListPeople;
  end;

  TF1 = file of TPeople;

var
  Form1: TForm1;
   F1 : TF1;
  head, temp : ListPeople;
  items : 1..11;
  max_id : Integer;
  curr_id : Integer;
  flag0 : boolean;
implementation

{$R *.dfm}

{�������� ���� ������.}
procedure deletespisok;
begin
while (head <> nil) do
begin
  temp := head;
  head := temp^.next;
  Dispose(temp);
end;
end;

{������� ����� ����� �������� ������������� � ��������� �� ������.}
procedure relationDelete(userFIO : string);
var F, pol_people1, pol_people2 : String;
    flag1, flag2 : Boolean;
    id_people1, id_people2 : Integer;
begin
  flag1 := true;
  temp:=head;
  while (flag1) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag1:=false;
      id_people1 := temp^.People.ID;
      pol_people1 := temp^.People.Pol;
    end;
  end;

  flag2 := true;
  temp:=head;
  while (flag2) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.FIO = userFIO) then
    begin
      flag2 := false;
      id_people2 := temp^.People.ID;
      pol_people2 := temp^.People.Pol;
    end;
  end;

  flag1 := true;
  temp:=head;
  while (flag1) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID = id_people1) then
    begin
      if (temp^.People.ID_Mother = id_people2) then
      begin
        flag1:=false;
        temp^.People.ID_Mother := 0;
      end;
      if (temp^.People.ID_Father = id_people2) then
      begin
        flag1:=false;
        temp^.People.ID_Father := 0;
      end;
      if (temp^.People.ID_HusbandWife = id_people2) then
      begin
        flag1:=false;
        temp^.People.ID_HusbandWife := 0;
      end;
    end;
  end;

  flag2 := true;
  temp:=head;
  while (flag2) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID = id_people2) then
    begin
      if (temp^.People.ID_Mother = id_people1) then
      begin
        flag2:=false;
        temp^.People.ID_Mother := 0;
      end;
      if (temp^.People.ID_Father = id_people1) then
      begin
        flag2:=false;
        temp^.People.ID_Father := 0;
      end;
      if (temp^.People.ID_HusbandWife = id_people1) then
      begin
        flag2:=false;
        temp^.People.ID_HusbandWife := 0;
      end;
    end;
  end;

  if (flag1) and (flag2)  then
    ShowMessage('����� ����� �� ����������.');

end;

{������ ����� � ��������� ������������(������) � ������������� �� ������(��������).}
procedure relationPerents(userFIO : string);
var pol_people : String;
    flag, flag2 : Boolean;
    id_people, id_people2, id_mother, id_father : Integer;
begin
  flag := true;
  temp:=head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      id_people := temp^.People.ID;
    end;
  end;
  flag2 := true;
  flag := true;
  temp:=head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID <> id_people) and (temp^.People.FIO = userFIO) then
    begin
      flag := false;
      if (temp^.People.Pol = '�������') then
      begin
        id_father := temp^.People.ID;
        pol_people := temp^.People.Pol;
      end;
      if (temp^.People.Pol = '�������') then
      begin
        id_mother := temp^.People.ID;
        pol_people := temp^.People.Pol;
      end;
      if (temp^.People.Pol <> '�������') and (temp^.People.Pol <> '�������') then
      begin
        ShowMessage('� ���������� ������������ �� ������ ����������� ���. ����� ������� ����������.');
        flag2 := false;
      end;
    end;
  end;
  if flag2 then
  begin
    if flag then
      ShowMessage('��������� ������������ �� ������ � �������� ������������ - ��� ���� � ��� �� �������. ����� ������� ����������.')
    else
    begin
      flag := true;
      if (temp^.People.ID_Mother = curr_id) or (temp^.People.ID_Father = curr_id) or (temp^.People.ID_HusbandWife = curr_id) then
        flag := false;
      id_people2 := temp^.People.ID;
      temp:=head;
      while (flag) and (temp^.next <> nil) do
      begin
        temp:=temp^.next;
        if (temp^.People.ID = curr_id) and (((temp^.People.ID_Mother = id_people2) or (temp^.People.ID_Father = id_people2) or (temp^.People.ID_HusbandWife = id_people2))) then
          flag := false;
      end;
      if flag then
      begin
        flag := true;
        temp := head;
        while (flag) and (temp^.next <> nil) do
        begin
          temp := temp^.next;
          if ((temp^.People.ID_Mother = curr_id) and (temp^.People.ID_Father = id_people2)) or ((temp^.People.ID_Mother = id_people2) and (temp^.People.ID_Father = curr_id)) then
            flag := false;
        end;
        if flag then
        begin
          flag := true;
          temp:=head;
          while (flag) and (temp^.next <> nil) do
          begin
            temp:=temp^.next;
            if (temp^.People.ID = id_people) and (pol_people = '�������') and (temp^.People.ID_Mother = 0) then
            begin
              flag := false;
              temp^.People.ID_Mother := id_mother;
            end;
            if (temp^.People.ID = id_people) and (pol_people = '�������') and (temp^.People.ID_Father = 0) then
            begin
              flag := false;
              temp^.People.ID_Father := id_father;
            end;
          end;
          if (flag) then
            ShowMessage('� ��������� ������������ ��� ���������� �����. ��� ���������� ������� ������� �.');
        end
        else
          ShowMessage('���������� ������� ����� �����, �� ������� ����, ��� ��������� ��� ������������ ����� ������ ������. ��� ���������� ������� ������� �����-�� �����.');
      end
      else
        ShowMessage('� ���� ������������� ��� ���������� ����� ����� �����. ��� ���������� ������� ������� �.');
    end;
  end;
end;

{������ ����� � ��������� ������������(��������) � ������������� �� ������(������).}
procedure relationChildren(userFIO : string);
var pol_people : String;
    flag : Boolean;
    id_people, id_people2 : Integer;
begin
  flag := true;
  temp:=head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      id_people := temp^.People.ID;
      pol_people := temp^.People.Pol;
    end;
  end;
  if (temp^.People.FIO <> userFIO) then
  begin
    if ((pol_people <> '�������') and (pol_people = '�������')) or ((pol_people = '�������') and (pol_people <> '�������')) then
    begin
      flag := true;
      temp := head;
      while (flag) and (temp^.next <> nil) do
      begin
        temp := temp^.next;
        if (temp^.People.FIO = userFIO) then
        begin
          id_people2 := temp^.People.ID;
          if (temp^.People.ID_Mother = curr_id) or (temp^.People.ID_Father = curr_id) or (temp^.People.ID_HusbandWife = curr_id) then
            flag := false;
        end;
      end;
      temp := head;
      while (flag) and (temp^.next <> nil) do
      begin
        temp:=temp^.next;
        if (temp^.People.ID = curr_id) and (((temp^.People.ID_Mother = id_people2) or (temp^.People.ID_Father = id_people2) or (temp^.People.ID_HusbandWife = id_people2))) then
          flag := false;
      end;
      if flag then
      begin
        flag := true;
        temp := head;
        while (flag) and (temp^.next <> nil) do
        begin
          temp := temp^.next;
          if ((temp^.People.ID_Mother = curr_id) and (temp^.People.ID_Father = id_people2)) or ((temp^.People.ID_Mother = id_people2) and (temp^.People.ID_Father = curr_id)) then
            flag := false;
        end;
        if flag then
        begin
          flag := true;
          temp := head;
          while (flag) and (temp^.next <> nil) do
          begin
            temp := temp^.next;
            if (temp^.People.FIO = userFIO) and (pol_people = '�������') and (temp^.People.ID_Mother = 0) then
            begin
              flag := false;
              temp^.People.ID_Mother := id_people;
            end;
            if (temp^.People.FIO = userFIO) and (pol_people = '�������') and (temp^.People.ID_Father = 0) then
            begin
              flag := false;
              temp^.People.ID_Father := id_people;
            end;
          end;
        end
        else
          ShowMessage('���������� ������� ����� �����, �� ������� ����, ��� ��������� ��� ������������ ����� ������ ������. ��� ���������� ������� ������� �����-�� �����.');
      end
      else
        ShowMessage('� ���� ������������� ��� ���������� ����� ����� �����. ��� ���������� ������� ������� �.');

      if flag then
          ShowMessage('� ������������ �� ������ ��� ���������� �����. ��� ���������� ������� ������� �.');
    end
    else
      ShowMessage('� ��������� ������������ ����������� ���. ����� ������� ����������.');
  end
  else
    ShowMessage('��������� ������������ �� ������ � �������� ������������ - ��� ���� � ��� �� �������. ����� ������� ����������.');
end;

{������ ����� ���� � ����.}
procedure relationHusbandWife(userFIO : string);
var pol_people : String;
    flag : Boolean;
    id_people1, id_people2, id_people3 : Integer;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      id_people1 := temp^.People.ID;
      pol_people := temp^.People.Pol;
    end;
  end;
  if temp^.People.FIO = userFIO then
    ShowMessage('��������� ������������ �� ������ � �������� ������������ - ��� ���� � ��� �� �������. ����� ������� ����������.')
  else
  begin
    if ((pol_people <> '�������') and (pol_people = '�������')) or ((pol_people = '�������') and (pol_people <> '�������')) then
    begin
      if (temp^.People.ID_HusbandWife = 0) then
      begin
        flag := true;
        temp := head;
        while (flag) and (temp^.next <> nil) do
        begin
          temp := temp^.next;
          if (temp^.People.FIO = userFIO) then
          begin
            id_people3 := temp^.People.ID;
            if (temp^.People.ID_Mother = curr_id) or (temp^.People.ID_Father = curr_id) or (temp^.People.ID_HusbandWife = curr_id) then
              flag := false;
          end;
        end;
        if ((pol_people <> '�������') and (pol_people = '�������')) or ((pol_people = '�������') and (pol_people <> '�������')) then
        begin
          temp := head;
          while (flag) and (temp^.next <> nil) do
          begin
            temp:=temp^.next;
            if (temp^.People.ID = curr_id) and (((temp^.People.ID_Mother = id_people3) or (temp^.People.ID_Father = id_people3) or (temp^.People.ID_HusbandWife = id_people3))) then
              flag := false;
          end;
          if flag then
          begin
            flag := true;
            temp := head;
            while (flag) and (temp^.next <> nil) do
            begin
              temp := temp^.next;
              if (temp^.People.ID <> id_people1) and (temp^.People.FIO = userFIO) then
              begin
                if (temp^.People.ID_HusbandWife = 0) then
                begin
                  if (pol_people <> temp^.People.Pol) then
                  begin
                    flag := false;
                    temp^.People.ID_HusbandWife := id_people1;
                    id_people2 := temp^.People.ID;
                  end
                  else
                    ShowMessage('���������� ������� ����� ����� �� ������� ����������� ����.');
                end
                else
                  ShowMessage('� ������������ �� ������ ��� ���������� �����. ��� ���������� ������� ������� �.')
              end;
            end;
          end
          else
            ShowMessage('� ���� ������������� ��� ���������� ����� ����� �����. ��� ���������� ������� ������� �.');
          if not flag then
          begin
            flag := true;
            temp := head;
            while (flag) and (temp^.next <> nil) do
            begin
              temp := temp^.next;
              if (temp^.People.ID = id_people1) then
              begin
                flag := false;
                temp^.People.ID_HusbandWife := id_people2;
              end;
            end;
          end;
        end
        else
          ShowMessage('� ���������� ������������ �� ������ ����������� ���. ����� ������� ����������.');
      end
      else
          ShowMessage('� ��������� ������������ ��� ���������� �����. ��� ���������� ������� ������� �.');
    end
    else
      ShowMessage('� ��������� ������������ ����������� ���. ����� ������� ����������.');
  end;
end;

{������� ������ ������������.}
procedure DeleteProfile;
var flag : Boolean;
    temp1 : ListPeople;
    id_people : Integer;
begin
  temp := head;
  flag := true;
  while (flag) and (temp^.next <> nil) do
  begin
    temp1 := temp^.next;
    if (temp1^.People.ID = curr_id) then
    begin
      id_people := temp1^.People.ID;
      temp^.next := temp1^.next;
      Dispose(temp1);
      flag := false;
    end
    else
      temp := temp^.next;
  end;

  temp := head;
  while (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID_Mother = id_people) then
      temp^.People.ID_Mother := 0;
    if (temp^.People.ID_Father = id_people) then
      temp^.People.ID_Father := 0;
    if (temp^.People.ID_HusbandWife = id_people) then
      temp^.People.ID_HusbandWife := 0;
  end;
end;

{������� ���� ������ �������������.}
procedure TForm1.Output;
begin
  AllUsersListBox.Clear;
  temp := head;
  while (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    AllUsersListBox.Items.Add(temp^.People.FIO);
  end;
end;

{������� ���� �� �������� �������������.}
procedure TForm1.ClearListBox;
begin
  ParentsListBox.Clear;
  ChildrenListBox.Clear;
  BrotherSisterListBox.Clear;
  GrandParentsListBox.Clear;
  GrandChildrenListBox.Clear;
  HusbandWifeListBox.Clear;
end;

{������� ��������� ��������� ������������.}
procedure TForm1.OutputPerents;
var flag : Boolean;
    father, mother : Integer;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID = curr_ID) then
    begin
      flag := false;
      with temp^.People do
      begin
        mother := ID_Mother;
        father := ID_Father;
      end;
    end;
  end;
  temp := head;
  while (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID = mother) or (temp^.People.ID = father) then
      with temp^.People do
        ParentsListBox.Items.Add(FIO);
  end;
end;

{������� ����� ��������� ������������.}
procedure TForm1.OutputChildren;
var flag : Boolean;
    people : Integer;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      with temp^.People do
        people := temp^.People.ID;
    end;
  end;
  temp := head;
  while (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID_Mother = people) or (temp^.People.ID_Father = people) then
      with temp^.People do
        ChildrenListBox.Items.Add(FIO);
  end;
end;

{������� �������/����� ��������� ������������.}
procedure TForm1.OutputBrotherSister;
var flag : Boolean;
    father, mother : Integer;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      mother := temp^.People.ID_Mother;
      father := temp^.People.ID_Father;
    end;
  end;
  temp := head;
  while (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID <> curr_id) and (((temp^.People.ID_Mother = mother) and (temp^.People.ID_Mother <> 0)) or ((temp^.People.ID_Father = father) and (temp^.People.ID_Father <> 0))) then
      with temp^.People do
        BrotherSisterListBox.Items.Add(FIO);
  end;
end;

{������� �������/������� ��������� ������������.}
procedure TForm1.OutputGrandPerents;
var flag : Boolean;
    father, mother, grandmother, grandfather : Integer;
    temp0 : ListPeople;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      mother := temp^.People.ID_Mother;
      father := temp^.People.ID_Father;
    end;
  end;
  temp := head;
  while (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID <> curr_id) and ((temp^.People.ID = mother) or (temp^.People.ID = father)) then
    begin
      grandmother := temp^.People.ID_Mother;
      grandfather := temp^.People.ID_Father;
      temp0 := head;
      while (temp0^.next <> nil) do
      begin
        temp0 := temp0^.next;
        if (temp0^.People.ID = grandmother)  or (temp0^.People.ID = grandfather) then
            with temp0^.People do
              GrandParentsListBox.Items.Add(FIO);
      end;
    end;
  end;
end;

{������� ������ ��������� ������������.}
procedure TForm1.OutputGrandChildren;
var flag : Boolean;
    people1, people2, grandchildren : Integer;
    temp0 : ListPeople;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      with temp^.People do
        people1 := temp^.People.ID;
    end;
  end;
  temp := head;
  while (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID_Mother = people1) or (temp^.People.ID_Father = people1) then
    begin
      people2 := temp^.People.ID;
      temp0 := head;
      while (temp0^.next <> nil) do
      begin
        temp0 := temp0^.next;
        if (temp0^.People.ID_Mother = people2) or (temp0^.People.ID_Father = people2) then
          with temp0^.People do
            GrandChildrenListBox.Items.Add(FIO);
      end;
    end;
  end;
end;

{������� ����/���� ��������� ������������.}
procedure TForm1.OutputHusbandWife;
var flag : Boolean;
    people : Integer;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID = curr_id) then
    begin
      flag := false;
      with temp^.People do
        people := temp^.People.ID;
    end;
  end;
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp := temp^.next;
    if (temp^.People.ID_HusbandWife = people) then
    begin
      flag := false;
      with temp^.People do
        HusbandWifeListBox.Items.Add(temp^.People.FIO);
    end;
  end;
end;

{���� ������� ������������ �� ID.}
procedure SearchID;
var flag : Boolean;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.ID = curr_id) then
      flag := false;
  end;
end;

{���� ������� ������������ �� ���.}
procedure SearchFIO(userFIO: string);
var flag : Boolean;
begin
  flag := true;
  temp := head;
  while (flag) and (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.FIO = userFIO) then
      flag := false;
  end;
end;

{������ ������ ������������ � ��������� ��� ��� ��������������.}
procedure TForm1.AddButtonClick(Sender: TObject);
begin
  temp := head;
  while (temp^.next <> nil) do
    temp:=temp^.next;
  New(temp^.next);
  temp:=temp^.next;
  temp^.next:=nil;
  inc(max_id);
  with temp^.People do
  begin
    curr_id := max_id;
    ID := curr_id;
    FIO := '����� ������������ ' + intToStr(curr_id);
    DateBith := '';
    Pol := '';
    ID_Mother := 0;
    ID_Father := 0;
    ID_HusbandWife := 0;
  end;
  EditUpdate;
  FioEdit.Text := temp^.People.FIO;
  DateEdit.Text := '';
  SexMaleRadioButton.Checked := false;
  SexFemaleRadioButton.Checked := false;
  ClearListBox;
  Output;
end;

{�������������� ������ �������������� ������������.}
procedure TForm1.actSaveExecute(Sender: TObject);
var i : Integer;
    flag : Boolean;
    Pol_people : String;
begin
  flag := true;
  temp := head;
  i := 0;
  while (temp^.next <> nil) do
  begin
    temp:=temp^.next;
    if (temp^.People.FIO = fioedit.Text) and (temp^.People.ID <> curr_id) then
    begin
      inc(i);
      if (temp^.People.DateBith = dateedit.Text) and ((temp^.People.Pol = '�������') or (temp^.People.Pol = '�������')) then
        flag := false;
    end;
  end;
  if flag then
  begin
    if (i=1) then
    begin
      fioedit.Text := fioedit.Text + ' ' + IntTostr(curr_id);
      ShowMessage('������������ � ����� ��� ��� ����������. ������� ������������ ���������� � ���������� ���(��� + ����� ������������)');
    end;
    flag := true;
    temp := head;
    while (temp^.next <> nil) do
    begin
      temp:=temp^.next;
      if (temp^.People.ID_Mother = curr_id) or  (temp^.People.ID_Father = curr_id) or (temp^.People.ID_HusbandWife = curr_id) then
        flag := false;
    end;
    SearchID;
    with temp^.People do
    begin
      FIO := fioedit.Text;
      DateBith := dateedit.Text;
      if(SexMaleRadioButton.Checked) then
        Pol_people := '�������'
      else
        Pol_people := '�������';
      if (Pol_people <> Pol) and (not flag) then
        ShowMessage('�� �� ������ ������� ���, �� ������� ����, ��� � ������������ ���� ����������� �����. ��� ������� ����� ������� ��.')
      else
        Pol := Pol_people;
    end;
    Output;
  end
  else
    ShowMessage('������������ �� �������, �.�. ����������� ������������ � ����� ��� ��� ����������.');
end;

{�������� �� ���������� ������ "���������".}
procedure TForm1.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled :=
    (FIOEdit.Text <> '') and
    (DateEdit.Text <> '') and
    (SexFemaleRadioButton.Checked or SexMaleRadioButton.Checked);
end;

{�������� �� ���������� ������ "������� �� �������".}
procedure TForm1.actGoToProfileUpdate(Sender: TObject);
var
 index : integer;
begin
  index := alluserslistbox.ItemIndex;
  actGoToProfile.Enabled := index >= 0;
end;

{��������� ������� ��� ��������� � ��������������.}
procedure TForm1.actGoToProfileExecute(Sender: TObject);
var
 index : integer;
 userFIO : string;
begin
  index := AllUsersListBox.ItemIndex;
  userFIO := AllUsersListBox.Items[index];
  SearchFIO(userFIO);
  with temp^.People do
  begin
    curr_id := ID;
    FioEdit.Text := FIO;
    DateEdit.Text := DateBith;
    SexMaleRadioButton.Checked := false;
    SexFemaleRadioButton.Checked := false;
    if (Pol = '�������') then
      SexMaleRadioButton.Checked := true;
    if (Pol = '�������') then
      SexFemaleRadioButton.Checked := true;
    ClearListBox;
    OutPutPerents;
    OutputChildren;
    OutputBrotherSister;
    OutputGrandPerents;
    OutputGrandChildren;
    OutputHusbandWife;
    EditUpdate;
  end;
end;

{�������� �� ���������� ����� ��������������.}
procedure TForm1.EditUpdate;
begin
  FIOEdit.Enabled := curr_id > 0;
  DateEdit.Enabled := curr_id > 0;
  SexMaleRadioButton.Enabled := curr_id > 0;
  SexFemaleRadioButton.Enabled := curr_id > 0;
end;

{������� ������������ �� ������.}
procedure TForm1.actDeleteExecute(Sender: TObject);{������� }
var
 index : integer;
 userFIO : string;
begin
  ClearListBox;
  FioEdit.Text := '';
  DateEdit.Text := '';
  SexMaleRadioButton.Checked := false;
  SexFemaleRadioButton.Checked := false;

  index := AllUsersListBox.ItemIndex;
  userFIO := AllUsersListBox.Items[index];
  SearchFIO(userFIO);
  with temp^.People do
    curr_id := ID;
  DeleteProfile;
  output;

  curr_id := 0;
  EditUpdate;
end;

{�������� �� ���������� ������ "������� �������".}
procedure TForm1.actDeleteUpdate(Sender: TObject);
var index : integer;
begin
  index := alluserslistbox.ItemIndex;
  actDelete.Enabled := index >= 0;
end;

{����������� ����.}
procedure TForm1.SaveMenuItemClick(Sender: TObject);
var
  saveDialog : TSaveDialog;
begin
  saveDialog := TSaveDialog.Create(self);{�������� ���� ����������.}
  saveDialog.InitialDir := GetCurrentDir + '\data';{�������� ����� data ��� ��������.}
  saveDialog.Filter := '����� �����|*.tree';{��� ����� - ����� ����� � ����������� .tree}
  saveDialog.DefaultExt := 'tree';{���������� ����� �� ��������� tree}
  saveDialog.FilterIndex := 1;{���-�� ������ 1}
  if saveDialog.Execute then
  begin
    AssignFile(F1, saveDialog.Files[0]);
    rewrite(F1);
    temp := head;
    while (temp^.next <> nil) do
    begin
      temp := temp^.next;
      write(F1,temp^.People);
    end;
    closeFile(F1);
    ShowMessage('���� ������� ��������.');
  end;
  saveDialog.Free;
end;

{��������� ������������ ����.}
procedure TForm1.OpenMenuItemClick(Sender: TObject);
var
  openDialog : topendialog;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := GetCurrentDir + '\data';
  openDialog.Filter := '����� �����|*.tree';
  openDialog.DefaultExt := 'tree';
  openDialog.FilterIndex := 1;
  if openDialog.Execute then
  begin
    deletespisok;
    flag0 := true;
    max_id := 0;
    curr_id := 0;
    AssignFile(F1, openDialog.Files[0]);
    {$I-}
    Reset(F1);
    {$I+}
    if IOResult <> 0 then
    begin
      Rewrite(F1);
    end;
    New(head);
    head^.Next := nil;
    temp := head;
    while not EOF (F1) do
    begin
      New(temp^.Next);
      temp:=temp^.Next;
      temp^.Next:=nil;
      read(F1, temp^.People);
      if (temp^.People.ID > max_id) then
        max_id := temp^.People.ID;
    end;
    closeFile(F1);

    EditUpdate;
    ClearListBox;
    FioEdit.Text := '';
    DateEdit.Text := '';
    SexMaleRadioButton.Checked := false;
    SexFemaleRadioButton.Checked := false;

    OutPut;
    AddButton.Enabled := true;
  end;
  openDialog.Free;
end;

{������ ����� ������.}
procedure TForm1.NewMenuItemClick(Sender: TObject);
begin
  deletespisok;
  flag0 := true;
  max_id := 0;
  curr_id := 0;
  New(head);
  head^.Next := nil;

  AllUsersListBox.Clear;
  ClearListBox;
  FioEdit.Text := '';
  DateEdit.Text := '';
  SexMaleRadioButton.Checked := false;
  SexFemaleRadioButton.Checked := false;

  AddButton.Enabled := true;
  ShowMessage('������ �������� ����� �������.');
end;


{�������� ����������.}
procedure TForm1.FormCreate(Sender: TObject);
begin
  flag0 := false;
  curr_id := 0;
  AddButton.Enabled := false;
  EditUpdate;
end;

{�������� ����������.}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  msg: String;
begin
  if flag0 then
  begin
    msg := '��������� ����?';
    if MessageDlg(msg, mtConfirmation, [mbNo, mbYes], 0) = mrYes then
      SaveMenuItemClick(Sender);
  end;
  deletespisok;
end;

{������������� ����������� ����� ����� �������� ������������� � ������������� ��������� � ������.}
procedure TForm1.actRalationExecute(Sender: TObject);
var index : Integer;
    userFIO : String;
begin
  index := AllUsersListBox.ItemIndex;
  userFIO := AllUsersListBox.Items[index];

  index:= RelationTypeComboBox.ItemIndex;
  if  (RelationTypeComboBox.Items[index] = '��������') then
    relationPerents(userFIO);
  if  (RelationTypeComboBox.Items[index] = '������') then
    relationChildren(userFIO);
  if  (RelationTypeComboBox.Items[index] = '���/����') then
    relationHusbandWife(userFIO);

  ClearListBox;
  OutPutPerents;
  OutputChildren;
  OutputBrotherSister;
  OutputGrandPerents;
  OutputGrandChildren;
  OutputHusbandWife;

end;

{�������� �� ���������� ������ "������� ����������� �����".}
procedure TForm1.actRalationUpdate(Sender: TObject);
  var index1, index2 : integer;
    userFIO : String;
begin
  index1 := alluserslistbox.ItemIndex;
  index2:= RelationTypeComboBox.ItemIndex;
  actRalation.Enabled := (index1 >= 0) and (index2 >= 0) and (curr_id > 0);
end;

{������� ����������� ����� ����� �������� ������������� � ������������� ��������� � ������.}
procedure TForm1.actDeleteRalationExecute(Sender: TObject);
var index : Integer;
    userFIO : String;
begin
  index := AllUsersListBox.ItemIndex;
  userFIO := AllUsersListBox.Items[index];
  relationDelete(userFIO);
  ClearListBox;
  OutPutPerents;
  OutputChildren;
  OutputBrotherSister;
  OutputGrandPerents;
  OutputGrandChildren;
  OutputHusbandWife;
end;

{�������� �� ���������� ������ "������� ����������� �����".}
procedure TForm1.actDeleteRalationUpdate(Sender: TObject);
var index : integer;
    userFIO : String;
begin
  index := alluserslistbox.ItemIndex;
  actDeleteRalation.Enabled := (index >= 0) and (curr_id > 0);
end;



end.
