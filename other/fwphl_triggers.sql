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

    if new.Info is null then
        new.Info = '';
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
begin
    new.Slug = lower(replace(new.Name, ' ', '-'));

    if new.ParentNode is null then
        new.DisplayName = new.Name;
        new.DisplayLinks = '[]';
    else
        select DisplayName, Name, DisplayLinks, Slug into prev_dispname, prev_name, prev_json, prev_slug from Property_Node where id = new.ParentNode;
        new.DisplayName = concat(new.Name, ' ', prev_dispname);
        new.DisplayLinks = jsonb_insert(prev_json, '{-1}', jsonb_build_array(prev_slug, prev_name), true);
    end if;

    if new.Info is null then
        new.Info = '';
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
begin
    if new.name is distinct from old.name then
        new.Slug = lower(replace(new.Name, ' ', '-'));
    end if;

    if new.ParentNode is distinct from old.ParentNode then
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
begin
    new.Slug = lower(replace(translate(new.Name, '()', ''), ' ', '-'));

    if new.Info is null then
        new.Info = '';
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_term_slug_bu() returns trigger as $$
begin
    if new.Name is distinct from old.Name then
        new.Slug = lower(replace(translate(new.Name, '()', ''), ' ', '-'));
    end if;
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

create or replace function populate_lr_disp_index() returns trigger as $$
declare
    count int;
begin
    if new.DispIndex is null then
        select count(Id) into count from Language_Reference where Lang = new.Lang;
        new.DispIndex = count;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_pr_disp_index() returns trigger as $$
declare
    count int;
begin
    if new.DispIndex is null then
        select count(Id) into count from Property_Reference where Prop = new.Prop;
        new.DispIndex = count;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace function populate_tr_disp_index() returns trigger as $$
declare
    count int;
begin
    if new.DispIndex is null then
        select count(Id) into count from Term_Reference where Term = new.Term;
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

create or replace trigger lr_disp_index before insert on Language_Reference
for each row execute function populate_lr_disp_index();

create or replace trigger pr_disp_index before insert on Property_Reference
for each row execute function populate_pr_disp_index();

create or replace trigger tr_disp_index before insert on Term_Reference
for each row execute function populate_tr_disp_index();