-- Insert all Tagalog personal pronouns for sample data.

insert into Language_Node (Name, NodeType)
values ('Greater Central Philippine', 2);

insert into Language_Node (Name, NodeType, ParentNode)
select 'Central Philippine', 2, Id from Language_Node where Name = 'Greater Central Philippine';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Tagalic', 2, Id from Language_Node where Name = 'Central Philippine';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Tagalog', 0, Id from Language_Node where Name = 'Tagalic';

insert into Language_Node (Name, NodeType, ParentNode)
select 'Batangas', 1, Id from Language_Node where Name = 'Tagalog';

-- Sample Reference
insert into Reference (Name, Info)
values ('blust-gcp', 'Blust, R. (1991). The Greater Central Philippines Hypothesis. <i>Oceanic Linguistics</i>, 30(2), 73–129. https://doi.org/10.2307/3623084.');

insert into Language_Reference (Lang, Ref)
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
select '2nd Person with 1st Person', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select 'Inclusive', Id from Property_Node where Name = 'Plural';

insert into Property_Node (Name, ParentNode)
select 'Exclusive', Id from Property_Node where Name = 'Plural';

-- Nominative series ("ang" form)
-- Tagalog 'Ako'
insert into Term (Name, Language)
select 'Ako', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ako' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ako' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ako' and Property_Node.Name = 'Nominative';

-- Tagalog 'Ikaw'
insert into Term (Name, Language)
select 'Ikaw', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ikaw' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ikaw' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ikaw' and Property_Node.Name = 'Nominative';

-- Tagalog 'Ka'
insert into Term (Name, Language)
select 'Ka', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ka' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ka' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ka' and Property_Node.Name = 'Nominative';

-- Tagalog 'Siya'
insert into Term (Name, Language)
select 'Siya', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Siya' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Siya' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Siya' and Property_Node.Name = 'Nominative';

-- Tagalog 'Kita' ("I to you"). Nominative only
insert into Term (Name, Language)
select 'Kita', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kita' and Property_Node.Name = '2nd Person with 1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kita' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kita' and Property_Node.Name = 'Nominative';

-- Tagalog 'Kita' (Dual)
insert into Term (Name, Language)
select 'Kita (2)', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kita (2)' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kita (2)' and Property_Node.Name = 'Dual';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kita (2)' and Property_Node.Name = 'Nominative';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kita (2)' and Property_Node.Name = 'Archaic';

-- Tagalog 'Kata' (Dual).
insert into Term (Name, Language)
select 'Kata', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kata' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kata' and Property_Node.Name = 'Dual';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kata' and Property_Node.Name = 'Nominative';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kata' and Property_Node.Name = 'Archaic';

-- Tagalog 'Tayo'
insert into Term (Name, Language)
select 'Tayo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Tayo' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Tayo' and Property_Node.Name = 'Inclusive';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Tayo' and Property_Node.Name = 'Nominative';

-- Tagalog 'Kami'
insert into Term (Name, Language)
select 'Kami', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kami' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kami' and Property_Node.Name = 'Exclusive';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kami' and Property_Node.Name = 'Nominative';

-- Tagalog 'Kayo'
insert into Term (Name, Language)
select 'Kayo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kayo' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kayo' and Property_Node.Name = 'Plural';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kayo' and Property_Node.Name = 'Nominative';

-- Tagalog 'Sila'
insert into Term (Name, Language)
select 'Sila', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Sila' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Sila' and Property_Node.Name = 'Plural';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Sila' and Property_Node.Name = 'Nominative';

-- Genitive series ("ng" form)
-- Tagalog 'Ko'
insert into Term (Name, Language)
select 'Ko', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ko' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ko' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ko' and Property_Node.Name = 'Genitive';

-- Tagalog 'Mo'
insert into Term (Name, Language)
select 'Mo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Mo' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Mo' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Mo' and Property_Node.Name = 'Genitive';

-- Tagalog 'Niya'
insert into Term (Name, Language)
select 'Niya', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Niya' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Niya' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Niya' and Property_Node.Name = 'Genitive';

-- Tagalog 'Nita'
insert into Term (Name, Language)
select 'Nita', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Nita' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Nita' and Property_Node.Name = 'Dual';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Nita' and Property_Node.Name = 'Genitive';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Nita' and Property_Node.Name = 'Archaic';

-- Tagalog 'Natin'
insert into Term (Name, Language)
select 'Natin', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Natin' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Natin' and Property_Node.Name = 'Inclusive';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Natin' and Property_Node.Name = 'Genitive';

-- Tagalog 'Namin'
insert into Term (Name, Language)
select 'Namin', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Namin' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Namin' and Property_Node.Name = 'Exclusive';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Namin' and Property_Node.Name = 'Genitive';

-- Tagalog 'Ninyo'
insert into Term (Name, Language)
select 'Ninyo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ninyo' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ninyo' and Property_Node.Name = 'Plural';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ninyo' and Property_Node.Name = 'Genitive';

-- Tagalog 'Niyo'
insert into Term (Name, Language)
select 'Niyo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Niyo' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Niyo' and Property_Node.Name = 'Plural';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Niyo' and Property_Node.Name = 'Genitive';

-- Tagalog 'Nila'
insert into Term (Name, Language)
select 'Nila', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Nila' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Nila' and Property_Node.Name = 'Plural';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Nila' and Property_Node.Name = 'Genitive';

-- Oblique series ("sa" form)
-- Tagalog 'Akin'
insert into Term (Name, Language)
select 'Akin', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Akin' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Akin' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Akin' and Property_Node.Name = 'Oblique';

-- Tagalog 'Iyo'
insert into Term (Name, Language)
select 'Iyo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Iyo' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Iyo' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Iyo' and Property_Node.Name = 'Oblique';

-- Tagalog 'Kaniya'
insert into Term (Name, Language)
select 'Kaniya', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kaniya' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kaniya' and Property_Node.Name = 'Singular';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kaniya' and Property_Node.Name = 'Oblique';

-- Tagalog 'Kanita'
insert into Term (Name, Language)
select 'Kanita', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kanita' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kanita' and Property_Node.Name = 'Dual';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kanita' and Property_Node.Name = 'Oblique';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kanita' and Property_Node.Name = 'Archaic';

-- Tagalog 'Atin'
insert into Term (Name, Language)
select 'Atin', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Atin' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Atin' and Property_Node.Name = 'Inclusive';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Atin' and Property_Node.Name = 'Oblique';

-- Tagalog 'Amin'
insert into Term (Name, Language)
select 'Amin', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Amin' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Amin' and Property_Node.Name = 'Exclusive';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Amin' and Property_Node.Name = 'Oblique';

-- Tagalog 'Inyo'
insert into Term (Name, Language)
select 'Inyo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Inyo' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Inyo' and Property_Node.Name = 'Plural';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Inyo' and Property_Node.Name = 'Oblique';

-- Tagalog 'Kanila'
insert into Term (Name, Language)
select 'Kanila', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kanila' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kanila' and Property_Node.Name = 'Plural';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kanila' and Property_Node.Name = 'Oblique';