table 50002 "ABC My Archive"
{
    DataClassification = CustomerContent;
    Caption = 'My Archive';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(20; "File Content"; Blob)
        {
            Caption = 'File Content';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        MyArchive: Record "ABC My Archive";
        EntryNo: Integer;
    begin
        EntryNo := 1;
        MyArchive.SetLoadFields("Entry No.");
        If MyArchive.FindLast() then
            EntryNo := MyArchive."Entry No." + 1;
        Rec."Entry No." := EntryNo;
    end;
}