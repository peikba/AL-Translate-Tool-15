#pragma implicitwith disable
page 78608 "BAC Gen. Translation Terms"
{
    Caption = 'General Translation Terms';
    PageType = List;
    SourceTable = "BAC Gen. Translation Term";
    AutoSplitKey = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Language)
            {
                field(LanguageFilter; LanguageFilter)
                {
                    Caption = 'Language Filter';
                    TableRelation = Language where ("BAC ISO code" = filter ('<>'''''));
                    ApplicationArea=All;
                    trigger OnValidate()
                    begin
                        if LanguageFilter <> '' then
                            Rec.SetFilter("Target Language", LanguageFilter)
                        else
                            Rec.SetRange("Target Language");
                        CurrPage.Update(false);
                    end;
                }
            }
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

    var
        LanguageFilter: Code[10];

}
#pragma implicitwith restore
