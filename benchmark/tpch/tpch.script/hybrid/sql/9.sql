SELECT   nation,
         o_year, 
         Sum(amount) AS sum_profit 
FROM     ( 
                SELECT n_name                                                          AS nation,
                       Extract(year FROM o_orderdate)                                  AS o_year,
                       l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity AS amount
                FROM     part, 
                         supplier, 
                         lineitem, 
                         partsupp,
                         orders, 
                         nation 
                WHERE  s_suppkey = l_suppkey 
                AND    ps_suppkey = l_suppkey 
                AND    ps_partkey = l_partkey
                AND    p_partkey = l_partkey
                AND    o_orderkey = l_orderkey 
                AND    s_nationkey = n_nationkey
                AND    p_name LIKE '%aquamarine%' ) AS profit 
GROUP BY nation,
         o_year 
ORDER BY nation,
         o_year DESC 
LIMIT    10;
