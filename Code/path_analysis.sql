-- 创建视图,统计各类行为的用户数
CREATE VIEW user_behavior_view AS
SELECT 
		user_id,
		item_id,
        COUNT(IF(behavior_type = 'pv',behavior_type,NULL)) AS pv,
		COUNT(IF(behavior_type = 'fav',behavior_type,NULL)) AS fav,
        COUNT(IF(behavior_type = 'cart',behavior_type,NULL)) AS cart,
		COUNT(IF(behavior_type = 'buy',behavior_type,NULL)) AS buy
FROM user_behavior
GROUP BY user_id,item_id;


-- 创建视图,标准化用户行为
CREATE VIEW user_behavior_standard AS
SELECT 
		user_id,
        item_id,
        (CASE WHEN pv>0 THEN 1 ELSE 0 END) AS viewed,
        (CASE WHEN fav>0 THEN 1 ELSE 0 END) AS collected,
        (CASE WHEN cart>0 THEN 1 ELSE 0 END) AS added,
        (CASE WHEN buy>0 THEN 1 ELSE 0 END) AS purchased
FROM user_behavior_view;


-- 创建视图,构造路径类型
CREATE VIEW user_behavior_path AS
SELECT 
		*,
        CONCAT(viewed,collected,added,purchased) AS purchase_path_type
FROM user_behavior_standard AS u
WHERE u.purchased>0;

-- 创建视图,统计各类购买行为的数量
CREATE VIEW path_count AS
SELECT 
		purchase_path_type,
        COUNT(*) AS amount
FROM user_behavior_path
GROUP BY purchase_path_type
ORDER BY amount DESC;

-- 创建路径说明表
CREATE TABLE interpret
(
path_type CHAR(4),
descriptions VARCHAR(40)
);

# 插入数据
INSERT INTO interpret
VALUES('0001','直接购买'),
	  ('1001','浏览后购买'),
	  ('0101','收藏后购买'),
	  ('0011','加购后购买'),
	  ('1011','浏览加购后购买'),
	  ('1101','浏览收藏后购买'),
	  ('0111','收藏加购后购买'),
	  ('1111','浏览收藏加购后购买');


-- 创建表格,储存路径类型、解释、数量
CREATE TABLE path_result
(
path_type    CHAR(4),
descriptions VARCHAR(40),
num 		 INT
);

# 插入数据
INSERT INTO path_result
SELECT
		path_type,
        descriptions,
        amount
FROM path_count AS P
JOIN interpret AS I
	ON P.purchase_path_type = I.path_type
ORDER BY amount DESC;