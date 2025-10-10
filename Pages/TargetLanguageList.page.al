#pragma implicitwith disable
#pragma warning disable AW0006
page 78602 "BAC Target Language List"
{
    PageType = List;
    SourceTable = "BAC Target Language";
    Caption = 'Target Language List';
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                    QuickEntry = false;

                }
                field("Source Language"; Rec."Source Language")
                {
                    ApplicationArea = All;
                    QuickEntry = false;

                }
                field("Source Language ISO code"; Rec."Source Language ISO code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }

                field("Target Language"; Rec."Target Language")
                {
                    ApplicationArea = All;
                }
                field("Target Language ISO code"; Rec."Target Language ISO code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(FactBox; "BAC Trans Source Factbox")
            {
                SubPageLink = "Project Code" = field("Project Code");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Translation Target")
            {
                Caption = 'Translation Target';
                ApplicationArea = All;
                Image = Translate;
                RunObject = page "BAC Translation Target List";
                RunPageLink = "Project Code" = field("Project Code"),
                            "Target Language" = field("Target Language"),
                            "Target Language ISO code" = field("Target Language ISO code");
            }
            action("Translation Terms")
            {
                Caption = 'Translation Terms';
                ApplicationArea = All;
                Image = BeginningText;
                RunObject = page "BAC Translation terms";
                RunPageLink = "Project Code" = field("Project Code"),
                            "Target Language" = field("Target Language");
            }
            action("Export Translation File")
            {
                ApplicationArea = All;
                Caption = 'Export Translation File';
                Image = ExportFile;
                trigger OnAction()
                var
                    TransProject: Record "BAC Translation Project";
                    ExportTranslation: XmlPort "BAC Export Translation Target";
                    ExportTranslationBC: XmlPort "BAC Export Trans Target BC";
                    ExportTranslation2018: XmlPort "BAC Export Trans Target 2018";
                    WarningTxt: Label 'Export the Translation file?';
                begin
                    if Confirm(WarningTxt) then begin
                        TransProject.get(Rec."Project Code");
                        case TransProject."NAV Version" of
                            TransProject."NAV Version"::"Business Central ->BC15":
                                begin
                                    ExportTranslation.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                    ExportTranslation.Run();
                                end;
                            TransProject."NAV Version"::"Business Central Cloud":
                                begin
                                    ExportTranslationBC.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                    ExportTranslationBC.Run();
                                end;
                            TransProject."NAV Version"::"Dynamics NAV (BC11)":
                                begin
                                    ExportTranslation2018.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                    ExportTranslation2018.Run();
                                end;
                        end;
                    end;
                end;

            }
            action("Import Target")
            {
                ApplicationArea = All;
                Caption = 'Import Target';
                Image = ImportLog;
                ToolTip = 'If you already have a full or partial translation file, then it is possible to import the file directly into the Target Language';

                trigger OnAction()
                var
                    TransTarget: Record "BAC Translation Target";
                    TransProject: Record "BAC Translation Project";
                    ImportTarget: XmlPort "BAC Import Translation Target";
                    ImportTargetBC: XmlPort "BAC Import Trans Target BC";
                    ImportTarget2018: XmlPort "BAC Import Trans Target 2018";
                    FileName: Text;
                    DeleteWarningTxt: Label 'This will overwrite existing Translation Target entries for %1 in %2 format', Comment = '%1 = Language Code, %2 = Format';
                    ImportedTxt: Label 'The file %1 has been imported into project %2', comment = '%1 = File Name, %2 = Project Code';
                begin
                    TransProject.get(Rec."Project Code");
                    TransTarget.SetRange("Project Code", Rec."Project Code");
                    if not TransTarget.IsEmpty then
                        if not Confirm(DeleteWarningTxt, false, Rec."Project Code", TransProject."NAV Version") then
                            exit;
                    case TransProject."NAV Version" of
                        TransProject."NAV Version"::"Business Central ->BC15":
                            begin
                                ImportTarget.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                ImportTarget.Run();
                                Success := ImportTarget.FileImported()
                            end;
                        TransProject."NAV Version"::"Business Central Cloud":
                            begin
                                ImportTargetBC.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                ImportTargetBC.Run();
                                Success := ImportTargetBC.FileImported()
                            end;
                        TransProject."NAV Version"::"Dynamics NAV (BC11)":
                            begin
                                ImportTarget2018.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                ImportTarget2018.Run();
                                Success := ImportTarget2018.FileImported()
                            end;
                    end;
                    FileName := ImportTarget.GetFileName();
                    while (strpos(FileName, '\') > 0) do
                        FileName := copystr(FileName, strpos(FileName, '\') + 1);
                    if Success then
                        message(ImportedTxt, FileName, Rec."Project Code");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Export Translation File_Promoted"; "Export Translation File")
                {
                }
                actionref("Import Target_Promoted"; "Import Target")
                {
                }
                actionref("Translation Target_Promoted"; "Translation Target")
                {
                }
                actionref("Translation Terms_Promoted"; "Translation Terms")
                {
                }
#if BASE
                actionref("Import Base Target_Promoted"; "Import Base Target")
                {
                }
#endif
            }
        }
    }
    var
        Success: Boolean;

}
#pragma implicitwith restore
