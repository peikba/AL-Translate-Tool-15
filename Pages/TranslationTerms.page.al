#pragma implicitwith disable
page 78606 "BAC Translation Terms"
{
    Caption = 'Translation Terms';
    PageType = List;
    SourceTable = "BAC Translation Term";
    AutoSplitKey = true;
    ShowFilter = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Term; Rec.Term)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the term to hardcode for translation. E.g. ''Journal'' must be translated to ''Worksheet''. Every instance of the term will be replaced with the translation.';
                }
                field(Translation; Rec.Translation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the translation to be inserted for the term. E.g. ''Journal'' must be translated to ''Worksheet''. Every instance of the term will be replaced with the translation.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Copy From General Terms")
            {
                ApplicationArea = All;
                Caption = 'Copy From General Terms';
                Image = ReminderTerms;

                trigger OnAction();
                var
                    GenTransTerm: Record "BAC Gen. Translation Term";
                    TransTerm: Record "BAC Translation Term";
                begin
                    GenTransTerm.SetFilter("Target Language", Rec."Target Language");
                    if GenTransTerm.FindSet() then
                        repeat
                            TransTerm.TransferFields(GenTransTerm);
                            TransTerm."Project Code" := Rec.GetFilter("Project Code");
                            if TransTerm.Insert() then;
                        until GenTransTerm.Next() = 0;
                end;
            }
            action("Add to General Terms")
            {
                ApplicationArea = All;
                Caption = 'Add to General Terms';
                Image = AddToHome;

                trigger OnAction();
                var
                    GenTransTerm: Record "BAC Gen. Translation Term";
                begin
                    GenTransTerm.TransferFields(Rec);
                    if not GenTransTerm.Insert() then
                        GenTransTerm.Modify();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref("Copy From General Terms_Promoted"; "Copy From General Terms")
                {
                }
                actionref("Add to General Terms_Promoted"; "Add to General Terms")
                {
                }
            }
        }
    }
}
#pragma implicitwith restore
