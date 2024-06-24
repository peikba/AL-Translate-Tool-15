#pragma implicitwith disable
page 78611 "BAC Languages"
{
    Caption = 'Languages (Translate Module)';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Language;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Windows Language ID"; Rec."Windows Language ID")
                {
                    ApplicationArea = All;
                }
                field("Windows Language Name"; Rec."Windows Language Name")
                {
                    ApplicationArea = All;
                }
                field("BAC ISO code"; Rec."BAC ISO code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
#pragma implicitwith restore
