#pragma implicitwith disable
page 78601 "BAC Translation Source List"
{
    PageType = List;
    SourceTable = "BAC Translation Source";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;

                }
                field("Trans-Unit Id"; Rec."Trans-Unit Id")
                {
                    ApplicationArea = All;
                    Visible=false;

                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {
            part(TransNotes; "BAC Translation Notes")
            {
                SubPageLink = "Project Code" = field("Project Code"),
                            "Trans-Unit Id" = field("Trans-Unit Id");
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action("Show Empty Captions")
            {
                Caption = 'Show Empty Captions';
                ApplicationArea = All;
                Image = ShowSelected;
                trigger OnAction()
                begin
                    Rec.SetRange(Source, '');
                end;
            }
            action("Show All Captions")
            {
                Caption = 'Show All Captions';
                ApplicationArea = All;
                Image = ShowList;
                trigger OnAction()
                begin
                    Rec.SetRange(Source);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Show Empty Captions_Promoted"; "Show Empty Captions")
                {
                }
                actionref("Show All Captions_Promoted"; "Show All Captions")
                {
                }
            }
        }
    }
}
#pragma implicitwith restore
