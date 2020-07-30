update ims_acct set closing_statusid = 3 , surrender_date = '2020-06-08'  , statusid = 7
where acctnum in
('1002010377','1002011862','1002013546','1002014031','1002014049','1002014957','1002017133',
'1002013348','1002013660','1002013900','1002013918','1002013942','1002013959','1002014213','1002014528',
'1002014544','1002014569','1002014650','1002014668','1002014767','1002014783','1002014890','1002014908',
'1002015079','1002015103','1002015152','1002015350','1002015624','1002015665','1002015913','1002017554','1002017950','1002019584');

update ims_plan set payment_status = 100, statusid = 3, closing_statusid = 3 , surrender_date = '2020-06-08' where planid in (select planid
from view_cont where acctnum in ('1002010377','1002011862','1002013546','1002014031','1002014049','1002014957','1002017133',
'1002013348','1002013660','1002013900','1002013918','1002013942','1002013959','1002014213','1002014528',
'1002014544','1002014569','1002014650','1002014668','1002014767','1002014783','1002014890','1002014908',
'1002015079','1002015103','1002015152','1002015350','1002015624','1002015665','1002015913','1002017554','1002017950','1002019584'));

update ims_subacct set statusid = 3  where  acctid in (select acctid from ims_acct where acctnum in
('1002010377','1002011862','1002013546','1002014031','1002014049','1002014957','1002017133',
'1002013348','1002013660','1002013900','1002013918','1002013942','1002013959','1002014213','1002014528',
'1002014544','1002014569','1002014650','1002014668','1002014767','1002014783','1002014890','1002014908',
'1002015079','1002015103','1002015152','1002015350','1002015624','1002015665','1002015913','1002017554','1002017950','1002019584'));

update trd_contract set inactive_since = '2020-06-22' where code in 
(select contractnum from view_cont where acctnum in
('1002010377','1002011862','1002013546','1002014031','1002014049','1002014957','1002017133',
'1002013348','1002013660','1002013900','1002013918','1002013942','1002013959','1002014213','1002014528',
'1002014544','1002014569','1002014650','1002014668','1002014767','1002014783','1002014890','1002014908',
'1002015079','1002015103','1002015152','1002015350','1002015624','1002015665','1002015913','1002017554','1002017950','1002019584'));

-- -- select * from trd_contract_position where contractid in (select contractid from trd_contract 
-- where code in (select contractnum from view_cont where acctnum in ('1002010377','1002011862','1002013546','1002014031','1002014049','1002014957','1002017133',
-- '1002013348','1002013660','1002013900','1002013918','1002013942','1002013959','1002014213','1002014528',
-- '1002014544','1002014569','1002014650','1002014668','1002014767','1002014783','1002014890','1002014908',
-- '1002015079','1002015103','1002015152','1002015350','1002015624','1002015665','1002015913','1002017554','1002017950','1002019584'))) and units != 0.0;
--  positionid | contractid | fundid | modelid |    units     | currency |  unit_price   |    date
-- ------------+------------+--------+---------+--------------+----------+---------------+------------
--   122382052 |       5901 |   9296 |         | 0.0000001021 | USD      | 10.3025000000 | 2020-06-22
--   122382053 |       5901 |   9300 |         | 0.0000001235 | USD      | 10.3863000000 | 2020-06-22
--   122397193 |       5995 |   9296 |         | 0.0000004098 | USD      | 10.3025000000 | 2020-06-22
--   122500257 |       6417 |   9296 |         | 0.0000000748 | USD      | 10.3025000000 | 2020-06-22
--   122410125 |       6040 |   9296 |         | 0.0000002838 | USD      | 10.3025000000 | 2020-06-22
--   122410124 |       6040 |   9300 |         | 0.0000001301 | USD      | 10.3863000000 | 2020-06-22
--   122439847 |       6113 |   9296 |         | 0.0000000182 | USD      | 10.3025000000 | 2020-06-22
--   122391851 |       5959 |   9296 |         | 0.0000003976 | USD      | 10.3025000000 | 2020-06-22
--   122391585 |       5944 |   9296 |         | 0.0000002307 | USD      | 10.3025000000 | 2020-06-22
--   122483829 |       6286 |   9296 |         | 0.0000001124 | USD      | 10.3025000000 | 2020-06-22
--   122391202 |       5934 |   9296 |         | 0.0000003142 | USD      | 10.3025000000 | 2020-06-22
--   122420373 |       6075 |   9296 |         | 0.0000002176 | USD      | 10.3025000000 | 2020-06-22
--   122333770 |       5664 |   9300 |         | 0.0000000155 | USD      | 10.3863000000 | 2020-06-22
--   122391847 |       5958 |   9296 |         | 0.0000000612 | USD      | 10.3025000000 | 2020-06-22
--   122478760 |       6257 |   9296 |         | 0.0000003376 | USD      | 10.3025000000 | 2020-06-22
--   122391863 |       5961 |   9296 |         | 0.0000002815 | USD      | 10.3025000000 | 2020-06-22
--   122339910 |       5690 |   9300 |         | 0.0000002653 | USD      | 10.3863000000 | 2020-06-22
--   122370819 |       5820 |   9296 |         | 0.0000002553 | USD      | 10.3025000000 | 2020-06-22

insert into trd_contract_position_history
select nextval('seq_trd_contract_position_history'), contractid, fundid, modelid, units, currency, unit_price, '2020-06-22', '2020-06-23 3:00'
  from trd_contract_position where contractid in (select contractid from trd_contract where code in (select contractnum from view_cont where acctnum in ('1002010377','1002011862','1002013546','1002014031','1002014049','1002014957','1002017133',
'1002013348','1002013660','1002013900','1002013918','1002013942','1002013959','1002014213','1002014528',
'1002014544','1002014569','1002014650','1002014668','1002014767','1002014783','1002014890','1002014908',
'1002015079','1002015103','1002015152','1002015350','1002015624','1002015665','1002015913','1002017554','1002017950','1002019584'))) and units != 0.0;

update trd_contract_position set units = 0.0 
where contractid in (select contractid from trd_contract where code in (select contractnum from view_cont where acctnum in ('1002010377','1002011862','1002013546','1002014
031','1002014049','1002014957','1002017133',
'1002013348','1002013660','1002013900','1002013918','1002013942','1002013959','1002014213','1002014528',
'1002014544','1002014569','1002014650','1002014668','1002014767','1002014783','1002014890','1002014908',
'1002015079','1002015103','1002015152','1002015350','1002015624','1002015665','1002015913','1002017554','1002017950','1002019584'))) and units != 0.0;

