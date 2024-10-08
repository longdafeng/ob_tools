select p_brand, p_type, p_size, count(distinct ps_suppkey) as supplier_cnt
from   partsupp,   part
where p_partkey = ps_partkey and p_brand <> 'Brand#23'
    and p_type not like 'PROMO BURNISHED%' and p_size in (1, 13, 10, 28, 21, 35, 31, 11)
    and ps_suppkey not in ( 
    select s_suppkey 
    from   supplier 
    where s_comment like '%Customer%Complaints%' ) 
group by p_brand, p_type, p_size 
order by supplier_cnt,1 desc, p_brand, p_type, p_size limit 10;
