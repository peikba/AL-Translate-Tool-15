xmlport 78606 "BAC Import Base Trans. Target"
{
    Caption = 'Import Base Translation Target';
    DefaultNamespace = 'urn:oasis:names:tc:xliff:document:1.2';
    Direction = Import;
    Encoding = UTF16;
    XmlVersionNo = V10;
    Format = Xml;
    PreserveWhiteSpace = true;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    UseLax = true;

    schema
    {
        textelement(xliff)
        {
            textattribute(version)
            {
                trigger OnAfterAssignVariable()
                begin
                    TransProject."Xliff Version" := version;
                end;
            }
            textelement(infile)
            {
                XmlName = 'file';
                textattribute(datatype)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        TransProject."File Datatype" := datatype;
                    end;

                }
                textattribute("source-language")
                {
                    trigger OnAfterAssignVariable()
                    var
                        WrongSourceLangTxt: Label '%1 must be %2 in file - The file %1 is %3';
                    begin
                        if TransProject."Source Language ISO code" <> "source-language" then
                            error(WrongSourceLangTxt, TransProject.FieldCaption("Source Language"), TransProject."Source Language ISO code", "source-language");
                    end;
                }
                textattribute("target-language")
                {
                }
                textattribute(original)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        TransProject.OrginalAttr := original;
                    end;
                }
                textelement(body)
                {
                    textelement(group)
                    {

                        textattribute(id1)
                        {
                            XmlName = 'id';
                        }
                        tableelement(Target; "BAC Base Translation Target")
                        {
                            UseTemporary = true;
                            AutoSave = true;
                            XmlName = 'trans-unit';
                            AutoReplace = true;

                            fieldattribute(id; Target."Trans-Unit Id")
                            {
                            }
                            textattribute("size-unit")
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    Target."size-unit" := "size-unit";
                                end;
                            }
                            textattribute(translate)
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    Target.TranslateAttr := translate;
                                end;
                            }
                            textattribute("al-object-target")
                            {
                                Occurrence = Optional;
                                trigger OnAfterAssignVariable()
                                begin
                                    target."al-object-target" := "al-object-target";
                                end;
                            }

                            fieldelement(source; Target.Source)
                            {
                            }

                            textelement(note)
                            {
                                XmlName = 'note';
                                textattribute(from)
                                {
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.From := from;
                                    end;
                                }
                                textattribute(annotates)
                                {
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.Annotates := annotates;
                                    end;
                                }
                                textattribute(priority)
                                {
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.Priority := priority;
                                    end;
                                }
                                textattribute(note2)
                                {
                                    XmlName = 'note';
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.Note := note2;
                                        CreateTranNote();
                                    end;
                                }
                            }
                            fieldelement(target; Target.Target)
                            {
                            }

                            trigger OnBeforeInsertRecord()
                            begin
                                if ProjectCode = '' then
                                    error(MissingProjNameTxt);
                                Target."Project Code" := ProjectCode;
                                Target."Target Language ISO code" := TargetLangISOCode;
                                Target."Target Language" := TargetLangCode;
                            end;

                            trigger OnAfterInsertRecord()
                            var
                                Target2: Record "BAC Base Translation Target";
                            begin
                                Target2 := Target;
                                if not Target2.Insert() then
                                    Target2.Modify();

                                if not XMLImported then
                                    XMLImported := true;
                            end;
                        }
                    }
                }
            }
        }
    }

    var
        ProjectCode: Code[10];
        TargetLangCode: Code[10];
        TargetLangISOCode: Text[10];
        SourceLangISOCode: Text[10];
        MissingProjNameTxt: Label 'Project Name is Missing';
        TransNotes: Record "BAC Base Translation Notes";
        TargetLanguage: Record "BAC Target Language";
        TransTarget: Record "BAC Base Translation Target";
        TransProject: Record "BAC Translation Project";
        XMLImported: Boolean;

    procedure SetProjectCode(inProjectCode: Code[10]; inSourceLangISOCode: text[10]; inTargetLangISOCode: Text[10])
    begin
        ProjectCode := inProjectCode;
        TransProject.Get(ProjectCode);
        TargetLangISOCode := inTargetLangISOCode;
        SourceLangISOCode := inSourceLangISOCode;
        TargetLanguage.Setrange("Project Code", ProjectCode);
        TargetLanguage.Setrange("Target Language ISO code", TargetLangISOCode);
        TargetLanguage.findfirst;
        TargetLangCode := TargetLanguage."Target Language";
    end;

    local procedure CreateTranNote()
    var
        TransNotes2: Record "BAC Base Translation Notes";
    begin
        if (TransNotes.From <> '') and
           (TransNotes.Annotates <> '') and
           (TransNotes.Priority <> '') then begin
            TransNotes."Project Code" := ProjectCode;
            TransNotes."Trans-Unit Id" := Target."Trans-Unit Id";
            TransNotes2 := TransNotes;
            if not TransNotes.Insert() then
                TransNotes2.Modify();
            clear(TransNotes);
        end;
    end;

    procedure GetFileName(): Text;
    begin
        exit(currXMLport.Filename);
    end;

    procedure FileImported(): Boolean
    begin
        exit(XMLImported);
    end;
}

