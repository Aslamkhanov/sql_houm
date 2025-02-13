create table party_guest(
	id serial primary key,
	name varchar(100) not null,
	email varchar(200) unique not null,
	came boolean default false
);

create user manager with password '1234';
grant all privileges on schema public to manager;

create view party_guest_name as (select name from party_guest);

create user guard with password '4321';
grant select on party_guest_name to guard;

set role manager;
insert into party_guest (name, email) values
	('Charles', 'charles_ny@yahoo.com'),
    ('Charles', 'mix_tape_charles@google.com'),
    ('Teona', 'miss_teona_99@yahoo.com');

set role guard;
select name from party_guest_name;
select has_table_privilege('guard', 'party_guest', 'select'); 

set role postgres;

create or replace procedure party_end()
  language plpgsql
  as $$
  	begin
		create table if not exists black_list (
			id serial primary key,
			email varchar(200) unique not null
			);
		insert into black_list (email) select email from party_guest where came = false;
		delete from party_guest;
  end;  
$$;

create or replace function register_to_party(p_name varchar, p_email varchar)
returns boolean 
language plpgsql
as $$
    declare
	  is_blacklisted boolean := false;
      black_list_exists boolean;
    begin
 		select to_regclass('public.black_list') is not null into black_list_exists;
        if black_list_exists then
			select exists (select 1 from black_list where email = p_email)
			into is_blacklisted;
		end if;
        if is_blacklisted then
            return false; 
      	end if;

    insert into party_guest (name, email) values (p_name, p_email);
    return true;
end;  
$$;

select register_to_party('Petr', 'korol_party@yandex.ru');

update party_guest set came = true 
where email in ('mix_tape_charles@google.com', 'miss_teona_99@yahoo.com');

call party_end();

