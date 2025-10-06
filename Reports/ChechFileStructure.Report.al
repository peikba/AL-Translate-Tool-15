report 78600 "BAC Check File Structure"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Check File Structure';


    requestpage
    {
        AboutTitle = 'Check the structure of an xliff file';
        AboutText = 'Check the structure of an xliff file';
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ImportFormat; ImportFormat)
                    {
                        Caption = 'Import Format';
                        ToolTip = 'Specifies the import format.';
                        ApplicationArea = All;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    var
        inStr: InStream;
        tempFileName: Text;
        DianlogTitleLbl: Label 'Check File Structure';
        TestFileTxt: Text;
        XmlDoc: XmlDocument;
        xPathLblStart: Label '<trans-unit';
        xPathLblEnd: Label '</trans-unit';
        xTargetLbl: Label '<target';
        xSourceLbl: Label '<source';
        xXliffLbl: Label '<xliff';
        xXliffFound: Boolean;
        xFileLbl: Label '<file';
        xFileFound: Boolean;
        xGroupLbl: Label '<group';
        xGroupFound: Boolean;
        xBodyLbl: Label '<body';
        xBodyFound: Boolean;
        xSourceCodeMissingLbl: Label 'The source tag is missing the trans-unit Line %1\\%2', Comment = '%1 = Line No, %2=trans-unit';
        xSourceCodeDoubleLbl: Label 'The source tag is double the trans-unit Line %1\\%2', Comment = '%1 = Line No, %2=trans-unit';
        xTargetCodeMissingLbl: Label 'The target tag is missing the trans-unit Line %1\\%2', Comment = '%1 = Line No, %2=trans-unit';
        xTargetCodeDoubleLbl: Label 'The target tag is double the trans-unit Line %1\\%2', Comment = '%1 = Line No, %2=trans-unit';
        xTargetCodeInSourceLbl: Label 'The target tag should not be present in trans-unit Line %1\\%2', Comment = '%1 = Line No, %2=trans-unit';
        xCheckXliffFileLbl: Label 'The file does not contain the %1 tag', Comment = '%1=tag name';
        xDocumentOkLbl: label 'Document is Ok';
        LfChar: Char;
        ShowText: Text;
        InsertLineTxt: Label '%1%2', Comment = '1%= Text %3=Crlf';
        ElementStart: Boolean;
        ElementEnd: Boolean;
        LineCounter: Integer;
        ErrorLineCounter: Integer;

    begin
        LfChar := 13;
        UploadIntoStream(DianlogTitleLbl, '', '*.xliff|*.xlf|All files (*.*)|*.*', tempFileName, inStr);
        if inStr.EOS then
            exit;
        XmlDocument.ReadFrom(InStr, XmlDoc);
        while inStr.Position <= inStr.Length do begin
            inStr.ReadText(TestFileTxt);
            LineCounter += 1;
            //Check XML Structure
            if TestFileTxt.Contains(xXliffLbl) then
                xXliffFound := true;
            if TestFileTxt.Contains(xFileLbl) then
                xFileFound := true;
            if TestFileTxt.Contains(xGroupLbl) then
                xGroupFound := true;
            if TestFileTxt.Contains(xBodyLbl) then
                xBodyFound := true;
            case true of
                StrPos(TestFileTxt, xPathLblEnd) > 0:
                    begin
                        ElementEnd := true;
                        ElementStart := false;
                    end;
                StrPos(TestFileTxt, xPathLblStart) > 0:
                    begin
                        ErrorLineCounter := LineCounter;
                        ElementStart := true;
                        ElementEnd := false;
                    end;
            end;
            if ElementStart then begin
                ShowText += StrSubstNo(InsertLineTxt, TestFileTxt, LfChar);
            end;
            if ElementEnd then begin
                ShowText += StrSubstNo(InsertLineTxt, TestFileTxt, LfChar);
                if not ShowText.Contains(xSourceLbl) then
                    Error(xSourceCodeMissingLbl, ErrorLineCounter, ShowText);
                if TestDouble(ShowText, xSourceLbl) then
                    Error(xSourceCodeDoubleLbl, ErrorLineCounter, ShowText);
                if ImportFormat = ImportFormat::Source then begin
                    if ShowText.Contains(xTargetLbl) then
                        Error(xTargetCodeInSourceLbl, ErrorLineCounter, ShowText)
                end else begin
                    if not ShowText.Contains(xTargetLbl) then
                        Error(xTargetCodeMissingLbl, ErrorLineCounter, ShowText);
                    if TestDouble(ShowText, xTargetLbl) then
                        Error(xTargetCodeDoubleLbl, ErrorLineCounter, ShowText);
                end;
                Clear(ShowText);
                ElementEnd := false;
            end;
        end;
        if not xXliffFound then
            Error(xCheckXliffFileLbl, xXliffLbl);
        if not xFileFound then
            Error(xCheckXliffFileLbl, xFileLbl);
        if not xGroupFound then
            Error(xCheckXliffFileLbl, xGroupLbl);
        if not xBodyFound then
            Error(xCheckXliffFileLbl, xBodyLbl);

        Message(xDocumentOkLbl);
    end;

    var
        ImportFormat: Option Source,Target;

    local procedure TestDouble(inText: Text; TestText: Text): Boolean
    begin
        if StrPos(inText, TestText) > 0 then
            inText := CopyStr(inText, StrPos(inText, TestText) + StrLen(TestText) + 1);
        exit(StrPos(inText, TestText) > 0);
    end;
}