-- Function Words in Philippine Languages
-- Triggers
use Function_Words;
delimiter //
create trigger populate_lang_disps_bi before insert on Language_Node
for each row begin
	declare prev_name varchar(255);
	declare prev_json json;
	declare prev_slug varchar(50);

	if new.NodeType = 1 then -- Dialect. Should always have parentnode!
		select Name, Slug into prev_name, prev_slug from Language_Node where id = new.ParentNode;
		set new.DisplayName = concat(prev_name, ', ', new.Name),
			new.Slug = concat(prev_slug, '-', lower(replace(new.Name, ' ', '-')));
	else
		set new.DisplayName = new.Name,
			new.Slug = lower(replace(new.Name, ' ', '-'));
	end if;

	if new.ParentNode is null then
		set new.DisplayLinks = '[]';
	else
		select Name, DisplayLinks, Slug into prev_name, prev_json, prev_slug from Language_Node where id = new.ParentNode;
		set new.DisplayLinks = json_array_append(prev_json, '$', json_array(prev_slug, prev_name));
	end if;
end//

create trigger populate_lang_disps_bu before update on Language_Node
for each row begin
	declare prev_name varchar(255);
	declare prev_json json;
	declare prev_slug varchar(50);

	if not (new.name <=> old.name) then
		if new.NodeType = 1 then -- Dialect. Should always have parentnode!
			select Name, Slug into prev_name, prev_slug from Language_Node where id = new.ParentNode;
			set new.DisplayName = concat(prev_name, ', ', new.Name),
				new.Slug = concat(prev_slug, '-', lower(replace(new.Name, ' ', '-')));
		else
			set new.DisplayName = new.Name,
				new.Slug = lower(replace(new.Name, ' ', '-'));
		end if;
	end if;

	if not (new.ParentNode <=> old.ParentNode) then
		if new.ParentNode is null then
			set new.DisplayLinks = '[]';
		else
			select Name, DisplayLinks, Slug into prev_name, prev_json, prev_slug from Language_Node where id = new.ParentNode;
			set new.DisplayLinks = json_array_append(prev_json, '$', json_array(prev_slug, prev_name));
		end if;
	end if;
end//

create trigger populate_prop_disps_bi before insert on Property_Node
for each row begin
	declare prev_name varchar(255);
	declare prev_dispname varchar(255);
	declare prev_json json;
	declare prev_slug varchar(50);

	set new.Slug = lower(replace(new.Name, ' ', '-'));

	if new.ParentNode is null then
		set new.DisplayName = new.Name,
		new.DisplayLinks = '[]';
	else
		select DisplayName, Name, DisplayLinks, Slug into prev_dispname, prev_name, prev_json, prev_slug from Property_Node where id = new.ParentNode;
		set new.DisplayName = concat(new.Name, ' ', prev_dispname),
			new.DisplayLinks = json_array_append(prev_json, '$', json_array(prev_slug, prev_name));
	end if;
end//

create trigger populate_prop_disps_bu before update on Property_Node
for each row begin
	declare prev_name varchar(255);
	declare prev_dispname varchar(255);
	declare prev_json json;
	declare prev_slug varchar(50);

	if not (new.name <=> old.name) then
		set new.Slug = lower(replace(new.Name, ' ', '-'));
	end if;

	if not (new.ParentNode <=> old.ParentNode) then
		if new.ParentNode is null then
			set new.DisplayName = new.Name,
			new.DisplayLinks = '[]';
		else
			select DisplayName, Name, DisplayLinks, Slug into prev_dispname, prev_name, prev_json, prev_slug from Property_Node where id = new.ParentNode;
			set new.DisplayName = concat(new.Name, ' ', prev_dispname),
				new.DisplayLinks = json_array_append(prev_json, '$', json_array(prev_slug, prev_name));
		end if;
	end if;
end//

create trigger populate_term_slug before insert on Term
for each row begin
	set new.Slug = lower(replace(new.Name, ' ', '-'));
end//
delimiter ;