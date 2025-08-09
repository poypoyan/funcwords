-- Insert all Tagalog personal pronouns for sample data.

insert into Language_Node (Name, NodeType)
values ('Austronesian', 2);

insert into Language_Node (Name, NodeType, ParentNode)
select 'Malayo-Polynesian', 2, Id from Language_Node where Name = 'Austronesian';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Philippine', 2, Id from Language_Node where Name = 'Malayo-Polynesian';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Greater Central Philippine', 2, Id from Language_Node where Name = 'Philippine';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Central Philippine', 2, Id from Language_Node where Name = 'Greater Central Philippine';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Tagalic', 2, Id from Language_Node where Name = 'Central Philippine';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Tagalog', 0, Id from Language_Node where Name = 'Tagalic';

-- Sample Reference
insert into Reference (Name, Info)
values ('blust-gcp', 'Blust, R. (1991). The Greater Central Philippines Hypothesis. <i>Oceanic Linguistics</i>, 30(2), 73–129. https://doi.org/10.2307/3623084.');

insert into Language_Node_Refs (LanguageNode_Id, Reference_Id)
select Language_Node.Id, Reference.Id from Language_Node
inner join Reference on Language_Node.Name = 'Greater Central Philippine' and Reference.Name = 'blust-gcp';

-- Personal Pronoun properties
insert into Property_Node (Name)
values ('Pronoun'), ('Singular'), ('Dual'), ('Plural'), ('Case'), ('Archaic');

insert into Property_Node (Name, ParentNode)
select 'Nominative', Id from Property_Node where Name = 'Case';

insert into Property_Node (Name, ParentNode)
select 'Genitive', Id from Property_Node where Name = 'Case';

insert into Property_Node (Name, ParentNode)
select 'Oblique', Id from Property_Node where Name = 'Case';

insert into Property_Node (Name, ParentNode)
select 'Personal', Id from Property_Node where Name = 'Pronoun';

insert into Property_Node (Name, ParentNode)
select '1st Person', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select '2nd Person', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select '3rd Person', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select '2nd Person Singular by 1st Person Singular', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select 'Inclusive', Id from Property_Node where Name = 'Plural';

insert into Property_Node (Name, ParentNode)
select 'Exclusive', Id from Property_Node where Name = 'Plural';

do $$
declare
    term_id Term.Id%type;
begin

-- Nominative series ("ang" form)
-- Tagalog 'Ako'
insert into Term (Name, Language)
select 'Akó', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Ikaw'
insert into Term (Name, Language)
select 'Ikáw', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Ka'
insert into Term (Name, Language)
select 'Ka', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Siya'
insert into Term (Name, Language)
select 'Siyá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '3rd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Kita' ("I to you"). Nominative only
insert into Term (Name, Language)
select 'Kitá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person Singular by 1st Person Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Kita' (Dual)
insert into Term (Name, Language)
select 'Kitá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Dual';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Archaic';

-- Tagalog 'Kata'
insert into Term (Name, Language)
select 'Katá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Dual';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Archaic';

-- Tagalog 'Tayo'
insert into Term (Name, Language)
select 'Táyo', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Inclusive';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Kami'
insert into Term (Name, Language)
select 'Kamí', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Exclusive';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Kayo'
insert into Term (Name, Language)
select 'Kayó', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Plural';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Tagalog 'Sila'
insert into Term (Name, Language)
select 'Silá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '3rd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Plural';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Nominative';

-- Genitive series ("ng" form)
-- Tagalog 'Ko'
insert into Term (Name, Language)
select 'Ko', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Tagalog 'Mo'
insert into Term (Name, Language)
select 'Mo', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Tagalog 'Niya'
insert into Term (Name, Language)
select 'Niyá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '3rd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Tagalog 'Nita'
insert into Term (Name, Language)
select 'Nitá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Dual';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Archaic';

-- Tagalog 'Natin'
insert into Term (Name, Language)
select 'Nátin', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Inclusive';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Tagalog 'Namin'
insert into Term (Name, Language)
select 'Námin', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Exclusive';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Tagalog 'Ninyo'
insert into Term (Name, Language)
select 'Ninyó', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Plural';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Tagalog 'Niyo'
insert into Term (Name, Language)
select 'Niyó', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Plural';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Tagalog 'Nila'
insert into Term (Name, Language)
select 'Nilá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '3rd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Plural';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Genitive';

-- Oblique series ("sa" form)
-- Tagalog 'Sa akin'
insert into Term (Name, Language)
select 'Sa ákin', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

-- Tagalog 'Sa iyo'
insert into Term (Name, Language)
select 'Sa iyó', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

-- Tagalog 'Sa kaniya'
insert into Term (Name, Language)
select 'Sa kaniyá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '3rd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Singular';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

-- Tagalog 'Sa kanita'
insert into Term (Name, Language)
select 'Sa kanitá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Dual';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Archaic';

-- Tagalog 'Sa atin'
insert into Term (Name, Language)
select 'Sa átin', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Inclusive';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

-- Tagalog 'Sa amin'
insert into Term (Name, Language)
select 'Sa ámin', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '1st Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Exclusive';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

-- Tagalog 'Sa inyo'
insert into Term (Name, Language)
select 'Sa inyó', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '2nd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Plural';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

-- Tagalog 'Sa kanila'
insert into Term (Name, Language)
select 'Sa kanilá', Id from Language_Node where Name = 'Tagalog'
returning Id into term_id;

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = '3rd Person';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Plural';

insert into Term_Property (Term, Prop)
select term_id, Id from Property_Node where Name = 'Oblique';

end $$
