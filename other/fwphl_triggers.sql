-- Function Words in Philippine Languages
-- Triggers

create or replace function populate_lang_disps_bi() returns trigger as $$
declare
        prev_name varchar(255);
        prev_json jsonb;
        prev_slug varchar(50);
begin
    if new.NodeType = 1 then
        select Name, Slug into prev_name, prev_slug from Language_Node where id = new.ParentNode;
        new.DisplayName = concat(prev_name, ', ', new.Name);
        new.Slug = concat(prev_slug, '-', lower(replace(new.Name, ' ', '-')));
    else
        new.DisplayName = new.Name;
        new.Slug = lower(replace(new.Name, ' ', '-'));
    end if;

    if new.ParentNode is null then
        new.DisplayLinks = '[]';
    else
        select Name, DisplayLinks, Slug into prev_name, prev_json, prev_slug from Language_Node where id = new.ParentNode;
        new.DisplayLinks = jsonb_insert(prev_json, '{-1}', jsonb_build_array(prev_slug, prev_name), true);
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_lang_disps_bu() returns trigger as $$
declare
    prev_name varchar(255);
    prev_json jsonb;
    prev_slug varchar(50);
begin
    if (new.name is distinct from old.name) or (new.NodeType is distinct from old.NodeType) then
        if new.NodeType = 1 then
            select Name, Slug into prev_name, prev_slug from Language_Node where id = new.ParentNode;
            new.DisplayName = concat(prev_name, ', ', new.Name);
            new.Slug = concat(prev_slug, '-', lower(replace(new.Name, ' ', '-')));
        else
            new.DisplayName = new.Name;
            new.Slug = lower(replace(new.Name, ' ', '-'));
        end if;
    end if;

    if new.ParentNode is distinct from old.ParentNode then
        if new.ParentNode is null then
            new.DisplayLinks = '[]';
        else
            select Name, DisplayLinks, Slug into prev_name, prev_json, prev_slug from Language_Node where id = new.ParentNode;
            new.DisplayLinks = jsonb_insert(prev_json, '{-1}', jsonb_build_array(prev_slug, prev_name), true);
        end if;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_prop_disps_bi() returns trigger as $$
declare
    prev_name varchar(255);
    prev_dispname varchar(255);
    prev_json jsonb;
    prev_slug varchar(50);
    count int;
begin
    select count(Id) into count from Property_Node where Name = new.Name;
    if count > 0 then
        new.Slug = concat(lower(replace(new.Name, ' ', '-')), '-', count + 1);
    else
        new.Slug = lower(replace(new.Name, ' ', '-'));
    end if;

    if new.ParentNode is null then
        new.DisplayName = new.Name;
        new.DisplayLinks = '[]';
    else
        select DisplayName, Name, DisplayLinks, Slug into prev_dispname, prev_name, prev_json, prev_slug from Property_Node where id = new.ParentNode;
        new.DisplayName = concat(new.Name, ' ', prev_dispname);
        new.DisplayLinks = jsonb_insert(prev_json, '{-1}', jsonb_build_array(prev_slug, prev_name), true);
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_prop_disps_bu() returns trigger as $$
declare
    prev_name varchar(255);
    prev_dispname varchar(255);
    prev_json jsonb;
    prev_slug varchar(50);
    count int;
begin
    if new.name is distinct from old.name then
        select count(Id) into count from Property_Node where Name = new.Name;
        if count > 0 then
            new.Slug = concat(lower(replace(new.Name, ' ', '-')), '-', count + 1);
        else
            new.Slug = lower(replace(new.Name, ' ', '-'));
        end if;
    end if;

    if (new.name is distinct from old.name) or (new.ParentNode is distinct from old.ParentNode) then
        if new.ParentNode is null then
            new.DisplayName = new.Name;
            new.DisplayLinks = '[]';
        else
            select DisplayName, Name, DisplayLinks, Slug into prev_dispname, prev_name, prev_json, prev_slug from Property_Node where id = new.ParentNode;
            new.DisplayName = concat(new.Name, ' ', prev_dispname);
            new.DisplayLinks = jsonb_insert(prev_json, '{-1}', jsonb_build_array(prev_slug, prev_name), true);
        end if;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_term_slug_bi() returns trigger as $$
declare
    unaccented varchar(255);
    count int;
begin
    unaccented = unaccent(new.Name);
    select count(Id) into count from Term where Language = New.Language and unaccent(Name) = unaccented;
    if count > 0 then
        new.Slug = concat(lower(replace(unaccented, ' ', '-')), '-', count + 1);
        new.LinkName = concat(unaccented, ' (', count + 1, ')');
    else
        new.Slug = lower(replace(unaccented, ' ', '-'));
        new.LinkName = unaccented;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_term_slug_bu() returns trigger as $$
declare
    unaccented varchar(255);
    count int;
begin
    if new.Name is distinct from old.Name then
        unaccented = unaccent(new.Name);
        select count(Id) into count from Term where Language = New.Language and unaccent(Name) = unaccented;
        if count > 0 then
            new.Slug = concat(lower(replace(unaccented, ' ', '-')), '-', count + 1);
            new.LinkName = concat(unaccented, ' (', count + 1, ')');
        else
            new.Slug = lower(replace(unaccented, ' ', '-'));
            new.LinkName = unaccented;
        end if;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_tp_disp_index() returns trigger as $$
declare
    count int;
begin
    if new.DispIndex is null then
        select count(Id) into count from Term_Property where Term = new.Term;
        new.DispIndex = count;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace trigger lang_disps_bi before insert on Language_Node
for each row execute function populate_lang_disps_bi();

create or replace trigger lang_disps_bu before update on Language_Node
for each row execute function populate_lang_disps_bu();

create or replace trigger prop_disps_bi before insert on Property_Node
for each row execute function populate_prop_disps_bi();

create or replace trigger prop_disps_bu before update on Property_Node
for each row execute function populate_prop_disps_bu();

create or replace trigger term_slug_bi before insert on Term
for each row execute function populate_term_slug_bi();

create or replace trigger term_slug_bu before update on Term
for each row execute function populate_term_slug_bu();

create or replace trigger tp_disp_index before insert on Term_Property
for each row execute function populate_tp_disp_index();

alter database "Function_Words" set pg_trgm.similarity_threshold = 0.15;