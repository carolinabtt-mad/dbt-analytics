with wallet_trans as (
select *, 
case when action_kind ='spend' and name='chat-message' and created_at>='2023-01-18'::date
	then row_number() over(partition by user_id, action_kind, name, extract(year from created_at) order by created_at asc) end as message_number,
case when action_kind ='purchase' then min(created_at) over (partition by user_id, action_kind ) end as first_purchase_date,
case when action_kind ='purchase' then row_number() over (partition by user_id, action_kind order by created_at ) end as purchase_number,
case when action_kind ='photos' then row_number() over (partition by user_id, action_kind order by created_at ) end as photounlock_number
from qkkie.wallet_transactions
)
select * from wallet_trans limit 100