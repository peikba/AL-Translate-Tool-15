codeunit 78601 "BAC Install Translations"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        UserPersonalization: Record "User Personalization";
        User: Record User;
    begin
        if User.FindSet() then
            repeat
                UserPersonalization.SetRange("User ID", User."User Name");
                if not UserPersonalization.IsEmpty then
                    if UserPersonalization.FindSet() then
                        repeat
                            UserPersonalization.Validate("Profile ID", 'BAC Translation');
                            UserPersonalization.Modify();
                        until UserPersonalization.Next() = 0;
            until user.Next() = 0;

    end;
}