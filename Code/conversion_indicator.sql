# 创建表格存储数据
CREATE TABLE date_hour_behavior
(
dates	CHAR(10),
hours	CHAR(2),
pv		INT,
cart	INT,
fav		INT,
buy		INT
);

# 按日期-小时来统计各种行为数据
INSERT INTO date_hour_behavior
SELECT 
		dates,
        hours,
		COUNT(IF(behavior_type = 'pv',behavior_type,NULL)) AS pv,
        COUNT(IF(behavior_type = 'cart',behavior_type,NULL)) AS cart,
        COUNT(IF(behavior_type = 'fav',behavior_type,NULL)) AS fav,
        COUNT(IF(behavior_type = 'buy',behavior_type,NULL)) AS buy
FROM user_behavior
GROUP BY dates,hours
ORDER BY dates,hours;