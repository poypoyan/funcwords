-- Insert some Tagalog personal pronouns ("Direct"/"ang" case only) for testing.
use Function_Words;

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
values ('Pronoun'), ('Singular'), ('Plural');

insert into Property_Node (Name, ParentNode)
select 'Personal', Id from Property_Node where Name = 'Pronoun';

insert into Property_Node (Name, ParentNode)
select '1st Person', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select '2nd Person', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select '3rd Person', Id from Property_Node where Name = 'Personal';

insert into Property_Node (Name, ParentNode)
select 'Inclusive', Id from Property_Node where Name = 'Plural';

insert into Property_Node (Name, ParentNode)
select 'Exclusive', Id from Property_Node where Name = 'Plural';

-- Tagalog 'Ako'
insert into Term (Name, Language)
select 'Ako', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ako' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ako' and Property_Node.Name = 'Singular';

-- Tagalog 'Ikaw'
insert into Term (Name, Language)
select 'Ikaw', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ikaw' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Ikaw' and Property_Node.Name = 'Singular';

-- Tagalog 'Siya'
insert into Term (Name, Language)
select 'Siya', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Siya' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Siya' and Property_Node.Name = 'Singular';

-- Tagalog 'Tayo'
insert into Term (Name, Language)
select 'Tayo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Tayo' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Tayo' and Property_Node.Name = 'Inclusive';

-- Tagalog 'Kami'
insert into Term (Name, Language)
select 'Kami', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kami' and Property_Node.Name = '1st Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kami' and Property_Node.Name = 'Exclusive';

-- Tagalog 'Kayo'
insert into Term (Name, Language)
select 'Kayo', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kayo' and Property_Node.Name = '2nd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Kayo' and Property_Node.Name = 'Plural';

-- Tagalog 'Sila'
insert into Term (Name, Language)
select 'Sila', Id from Language_Node where Name = 'Tagalog';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Sila' and Property_Node.Name = '3rd Person';

insert into Term_Property (Term, Prop)
select Term.Id, Property_Node.Id from Term
inner join Property_Node on Term.Name = 'Sila' and Property_Node.Name = 'Plural';
