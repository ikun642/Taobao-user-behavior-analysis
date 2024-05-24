-- 各品类热度
# 创建表格储存各品类热度
CREATE TABLE category_popularity
(
category_id	INT,
pv	 		INT
);

# 插入数据
INSERT INTO category_popularity
SELECT
		category_id,
        COUNT(IF(behavior_type = 'pv',behavior_type,NULL)) AS category_pv
FROM user_behavior
GROUP BY category_id
ORDER BY category_pv DESC;


-- 各商品热度
# 创建表格储存各商品热度
CREATE TABLE item_popularity
(
item_id		INT,
pv			INT
);


# 插入数据
INSERT INTO item_popularity
SELECT 
		item_id,
        COUNT(IF(behavior_type = 'pv',behavior_type,NULL)) AS item_pv
FROM user_behavior
GROUP BY item_id
ORDER BY item_pv DESC;