pageextension 78600 "BAC User Card" extends Users
{
    actions
    {
        addfirst(processing)
        {
            action("BAC User Access")
            {
                Caption = 'User Access';
                ApplicationArea = All;
                Image = ServiceAccessories;
                RunObject = page "BAC User Access";
                RunPageLink = "User Id" = field("User Name");
            }
        }
        addlast(Category_Process)
        {
            actionref("BAC User Access_Promoted"; "BAC User Access")
            {
            }
        }
    }
}