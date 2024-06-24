#pragma implicitwith disable
page 78604 "BAC Translation Notes"
{
    PageType = Listpart;
    SourceTable = "BAC Translation Notes";
    Caption = 'Translation Notes';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(From; Rec.From)
                {
                    ApplicationArea = All;

                }
                field(Annotates; Rec.Annotates)
                {
                    ApplicationArea = All;

                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}
#pragma implicitwith restore
