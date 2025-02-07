--Таблица "заявка"
create table bid (
	id serial primary key, 
	product_type varchar(50),
	client_name varchar(100),
	is_company boolean,
	amount numeric(12,2)
);
select *
from bid;

insert into bid (product_type, client_name, is_company, amount) values
('credit', 'Petrov Petr Petrovich', false, 1000000),
('credit', 'Coca cola', true, 100000000),
('deposit', 'Soho bank', true, 12000000),
('deposit', 'Kaspi bank', true, 18000000),
('deposit', 'Miksumov Anar Raxogly', false, 500000),
('debit_card', 'Miksumov Anar Raxogly', false, 0),
('credit_card', 'Kipu Masa Masa', false, 5000),
('credit_card', 'Popova Yana Andreevna', false, 25000),
('credit_card', 'Miksumov Anar Raxogly', false, 30000),
('debit_card', 'Saronova Olga Olegovna', false, 0);

do $$
declare
    tablename varchar;
    result_row record;
    command_create_table varchar;
    command_insert_table varchar;
begin
    for result_row in (
        select distinct product_type, is_company 
        from bid
        order by product_type
    ) loop
        if result_row.is_company then
            tablename := concat('company_', result_row.product_type);
        else 
            tablename := concat('person_', result_row.product_type);
        end if;
        command_create_table := concat(
            'create table if not exists ', tablename, ' (
                id serial primary key,
                client_name varchar(100),
                amount numeric(12,2)
            );'
        );
        execute command_create_table;
        command_insert_table := concat(
            'insert into ', tablename, ' (client_name, amount) ',
            'select client_name, amount FROM bid 
             where product_type = \$1 AND is_company = \$2;'
        );    
        execute command_insert_table using result_row.product_type, result_row.is_company;
    end loop;
end $$;

do $$
declare
    base_rate numeric := 0.1; 
begin
   create table if not exists credit_percent ( 
        client_name varchar(100),
        amount numeric(12,2)
    );

    execute 'insert into credit_percent (client_name, amount)
             select client_name, ((amount * \$1) / 365) 
             from company_credit
             union all
             select client_name, ((amount * (\$1 + 0.05)) / 365)
             from person_credit' 
    using base_rate;

    raise notice 'Общая сумма начисленных процентов по всем клиентам = %', 
        (select ROUND(sum(amount), 2) from credit_percent);
end $$;

do $$
	begin
		create or replace view company_bid as (
			select *
			from bid 
			where is_company = true
		);
	end;
$$;
select *
from company_bid

