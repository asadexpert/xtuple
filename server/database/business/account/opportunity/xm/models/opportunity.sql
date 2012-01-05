﻿select private.create_model(

-- Model name, schema, table

'opportunity', 'public', 'ophead',

-- Columns

E'{
  "ophead.ophead_id as guid",
  "ophead.ophead_crmacct_id as account",
  "ophead.ophead_amount as amount",
  "ophead.ophead_cntct_id as contact",
  "ophead.ophead_curr_id as currency",
  "ophead.ophead_probability_prcnt as probability",
  "ophead.ophead_opsource_id as source",
  "ophead.ophead_opstage_id as stage",
  "ophead.ophead_optype_id as \\"type\\"",
  "ophead.ophead_assigned_date as assign_date",
  "ophead.ophead_username as assign_to",
  "ophead.ophead_actual_date as complete_date",
  "ophead.ophead_target_date as due_date",
  "ophead.ophead_active as is_active",
  "ophead.ophead_name as \\"name\\"",
  "ophead.ophead_notes as notes",
  "ophead.ophead_owner_username as \\"owner\\"",
  "ophead.ophead_priority_id as priority",
  "ophead.ophead_start_date as start_date",
  "ophead.ophead_number as \\"number\\"",
  "btrim(array(
    select charass_id 
    from charass
    where charass_target_id = ophead.ophead_id
      and charass_target_type = \'OPP\')::text,\'{}\') as characteristics",  
  "btrim(array(
    select comment_id
    from \\"comment\\"
    where comment_source_id = ophead.ophead_id
      and comment_source = \'OPP\')::text,\'{}\') as \\"comments\\"",  
  "btrim(array(
    select docass_id 
    from docass
    where docass_target_id = ophead.ophead_id 
      and docass_target_type = \'OPP\'
    union all
    select docass_id 
    from docass
    where docass_source_id = ophead.ophead_id 
      and docass_source_type = \'OPP\'
    union all
    select imageass_id 
    from imageass
    where imageass_source_id = ophead.ophead_id 
      and imageass_source = \'OPP\')::text,\'{}\') as documents"}',

E'{"
-- insert rule

create or replace rule \\"_CREATE\\" as on insert to xm.opportunity
  do instead

insert into ophead (
  ophead_id,
  ophead_crmacct_id,
  ophead_amount,
  ophead_cntct_id,
  ophead_curr_id,
  ophead_probability_prcnt,
  ophead_opsource_id,
  ophead_opstage_id,
  ophead_optype_id,
  ophead_assigned_date,
  ophead_username,
  ophead_actual_date,
  ophead_target_date,
  ophead_active,
  ophead_name,
  ophead_notes,
  ophead_owner_username,
  ophead_priority_id,
  ophead_start_date,
  ophead_number )
values (
  new.guid,
  new.account,
  new.amount,
  new.contact,
  new.currency,
  new.probability,
  new.source,
  new.stage,
  new.type,
  new.assign_date,
  new.assign_to,
  new.complete_date,
  new.due_date,
  new.is_active,
  new.name,
  new.notes,
  new.owner,
  new.priority,
  new.start_date,
  new.number)

","

-- update rule
create or replace rule \\"_UPDATE\\" as on update to xm.opportunity
  do instead

update ophead set
  ophead_crmacct_id = new.account,
  ophead_amount = new.amount,
  ophead_cntct_id = new.contact,
  ophead_curr_id = new.currency,
  ophead_probability_prcnt = new.probability,
  ophead_opsource_id = new.source,
  ophead_opstage_id = new.stage,
  ophead_optype_id = new.type,
  ophead_assigned_date = new.assign_date,
  ophead_username = new.assign_to,
  ophead_actual_date = new.complete_date,
  ophead_target_date = new.due_date,
  ophead_active = new.is_active,
  ophead_name = new.name,
  ophead_notes = new.notes,
  ophead_owner_username = new.owner,
  ophead_priority_id = new.priority,
  ophead_start_date = new.start_date
 where ( ophead_id = old.guid )

","

-- delete rule
create or replace rule \\"_DELETE\\" as on delete to xm.opportunity
  do instead (

delete from \\"comment\\"
where ( comment_source_id = old.guid 
 and comment_source = \'OPP\' );

delete from charass
where ( charass_target_id = old.guid ) 
  and ( charass_target_type = \'OPP\' );

delete from docass
where ( docass_target_id = old.guid ) 
  and ( docass_target_type = \'OPP\' );

delete from docass
where ( docass_source_id = old.guid ) 
  and ( docass_source_type = \'OPP\' );

delete from imageass
where ( imageass_source_id = old.guid ) 
  and ( imageass_source = \'OPP\' );

delete from ophead
where ( ophead_id = old.guid );

)"}',

-- Conditions, Comment, System

'{}', 'Opportunity Model', true);
