codeunit 50007 "ABC Upload to Cloud Connector"
{
    [EventSubscriber(ObjectType::Table, Database::"ABC My Archive", 'OnAfterInsertEvent', '', false, false)]
    local procedure MyArchiveOnAfterInsertEvent(RunTrigger: Boolean; var Rec: Record "ABC My Archive")
    begin
        if Rec.IsTemporary() then
            exit;
        UploadToCloud(Rec);
    end;

    local procedure UploadToCloud(var Rec: Record "ABC My Archive")
    var
        CloudApplication: Record "BYD Cloud Application";
        CloudFile: Record "BYD Cloud File";
        CloudStorage: Record "BYD Cloud Storage";
        CloudApplicationMgt: Codeunit "BYD Cloud Application Mgt.";
        CloudstorageMgt: Codeunit "BYD Cloud Storage Mgt.";
        FileMgt: Codeunit "File Management";
        InStr: InStream;
    begin
        CloudStorage.Get(CloudStorage.Type::Dropzone, Database::"ABC My Archive");
        Rec."File Content".CreateInStream(InStr, TextEncoding::Windows);
        CloudApplication.Get('ARCHIVE');
        CloudApplicationMgt.CheckToken(CloudApplication);
        if CloudApplication."Application Type" = CloudApplication."Application Type"::Sharepoint then
            CloudstorageMgt.InitCloudFile(CloudStorage, CloudFile, Rec.RecordId(), InStr.Length(), 'MySharepointArchive\HowTo\Files', Rec."File Name", FileMgt.GetExtension(Rec."File Name"))
        else
            CloudstorageMgt.InitCloudFile(CloudStorage, CloudFile, Rec.RecordId(), InStr.Length(), 'MySharepointArchive', Rec."File Name", '');
        CloudstorageMgt.UploadCloudFileChunk(CloudApplication, CloudFile, InStr.Length(), 0, InStr);
        CloudstorageMgt.CloseCloudFile(CloudFile);
        Clear(Rec."File Content");
        Rec.Modify(true);
    end;
}