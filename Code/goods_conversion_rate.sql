-- 品类转化率
# 创建表格存储数据
CREATE TABLE category_conversion
(
category_id INT,
conversion_rate FLOAT
);

# 插入数据
INSERT INTO category_conversion
SELECT 
		category_id,
        # 购买用户数/总用户数=转化率
        COUNT(DISTINCT IF(behavior_type='buy',user_id,NULL))/(trip.all_cnt) AS category_conversion_rate
FROM user_behavior,trip
# 按品类分组
GROUP BY category_id
ORDER BY category_conversion_rate DESC;


-- 商品转化率
# 创建表格存储数据
CREATE TABLE item_conversion
(
item_id INT,
conversion_rate FLOAT
);

# 插入数据
INSERT INTO item_conversion
SELECT 
		item_id,
        # 购买用户数/总用户数=转化率
		COUNT(DISTINCT IF(behavior_type='buy',user_id,NULL))/(trip.all_cnt) AS item_conversion_rate
FROM user_behavior,trip
# 按商品分组
GROUP BY item_id
ORDER BY item_conversion_rate DESC;