page 50001 "ABC My Archive"
{
    ApplicationArea = All;
    Caption = 'My Archive';
    PageType = List;
    SourceTable = "ABC My Archive";
    UsageCategory = History;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                }
                field("File Content"; Rec."File Content".HasValue)
                {
                    Caption = 'Blob Content';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Content field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Promoted = true;
                Image = Import;
                Caption = 'Import';
                trigger OnAction()
                var
                    InStr: InStream;
                    OutStr: OutStream;
                    Filename: Text;
                begin
                    if not UploadIntoStream('Upload File', '', '', Filename, InStr) then
                        exit;
                    Rec.Init();
                    Rec."File Content".CreateOutStream(OutStr, TextEncoding::Windows);
                    Rec."File Name" := Filename;
                    CopyStream(OutStr, InStr);
                    Rec.Insert(true);
                end;
            }
            action(Export)
            {
                ApplicationArea = All;
                Promoted = true;
                Image = Export;
                Caption = 'Export';
                trigger OnAction()
                var
                    InStr: InStream;
                    Filename: Text;
                begin
                    Filename := Rec."File Name";
                    Rec.CalcFields("File Content");
                    if not Rec."File Content".HasValue then
                        exit;
                    Rec."File Content".CreateInStream(InStr, TextEncoding::Windows);
                    DownloadFromStream(InStr, 'Download', '', '', Filename);
                end;
            }
        }
    }
}
