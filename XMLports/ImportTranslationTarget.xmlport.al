xmlport 78602 "BAC Import Translation Target"
{
    Caption = 'Import Translation Target';
    DefaultNamespace = 'urn:oasis:names:tc:xliff:document:1.2';
    Direction = Import;
    Encoding = UTF16;
    XmlVersionNo = V10;
    Format = Xml;
    PreserveWhiteSpace = true;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    UseLax = false;

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
                    XmlName = 'datatype';
                    trigger OnAfterAssignVariable()
                    begin
                        TransProject."File Datatype" := datatype;
                    end;

                }
                textattribute("source-language")
                {
                    XmlName = 'source-language';
                }
                textattribute("target-language")
                {
                    XmlName = 'target-language';
                }
                textattribute(original)
                {
                    XmlName = 'original';
                    trigger OnAfterAssignVariable()
                    begin
                        TransProject.OrginalAttr := original;
                    end;
                }
                textelement(body)
                {
                    XmlName = 'body';
                    textelement(group)
                    {

                        textattribute(id1)
                        {
                            XmlName = 'id';
                        }
                        tableelement(Target; "BAC Translation Target")
                        {
                            UseTemporary = true;
                            AutoSave = true;
                            XmlName = 'trans-unit';
                            AutoReplace = true;

                            fieldattribute(id; Target."Trans-Unit Id")
                            {
                                XmlName = 'id';
                            }
                            textattribute("size-unit")
                            {
                                XmlName = 'size-unit';
                                trigger OnAfterAssignVariable()
                                begin
                                    Target."size-unit" := "size-unit";
                                end;
                            }
                            textattribute(translate)
                            {
                                XmlName = 'translate';
                                trigger OnAfterAssignVariable()
                                begin
                                    Target.TranslateAttr := translate;
                                end;
                            }
                            textattribute("al-object-target")
                            {
                                XmlName = 'al-object-target';
                                Occurrence = Optional;
                                trigger OnAfterAssignVariable()
                                begin
                                    target."al-object-target" := "al-object-target";
                                end;
                            }

                            fieldelement(source; Target.Source)
                            {
                                XmlName = 'source';
                            }

                            tableelement(TransNotes; "BAC Translation Notes")
                            {
                                XmlName = 'note';
                                UseTemporary = true;
                                AutoSave = true;
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
                                    end;
                                }
                                trigger OnBeforeInsertRecord()
                                begin
                                    TransNotes."Project Code" := ProjectCode;
                                    TransNotes."Trans-Unit Id" := Target."Trans-Unit Id";
                                end;
                            }
                            fieldelement(target; Target.Target)
                            {
                                XmlName = 'target';
                                textattribute(state)
                                {
                                    XmlName = 'state';
                                    Occurrence = Optional;
                                    trigger OnAfterAssignVariable()
                                    begin
                                        Target.State := state;
                                    end;
                                }

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
                                Target2: Record "BAC Translation Target";
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

        TargetLanguage: Record "BAC Target Language";
        TransProject: Record "BAC Translation Project";
        ProjectCode: Code[10];
        TargetLangCode: Code[10];
        TargetLangISOCode: Text[10];
        SourceLangISOCode: Text[10];
        XMLImported: Boolean;
        MissingProjNameTxt: Label 'Project Name is Missing';

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

    procedure GetFileName(): Text;
    begin
        exit(currXMLport.Filename);
    end;

    procedure FileImported(): Boolean
    begin
        exit(XMLImported);
    end;
}

