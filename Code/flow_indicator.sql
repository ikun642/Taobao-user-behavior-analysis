-- 计算每日的页面浏览量pv、独立访客数uv、平均访问深度pv/uv
# 创建表格
CREATE TABLE pv_uv_puv
(
dates	CHAR(10),
pv		INT(9),
uv		INT(9),
puv		DECIMAL(10,1) 
);

# 插入数据
INSERT INTO pv_uv_puv
SELECT 
		dates,
        # 计算页面浏览量pv
        COUNT(*) AS pv,
        # 计算独立访客数uv
        COUNT(DISTINCT user_id) AS uv,
        # 计算访问深度pv/uv
        ROUND(COUNT(*)/COUNT(DISTINCT user_id),1) AS puv
FROM user_behavior
WHERE behavior_type = 'pv'
# 按日期分组
GROUP BY dates;


-- 计算用户的跳失率
# 创建表格
CREATE TABLE trip
(
trip_cnt	INT,
all_cnt		BIGINT,
trip_rate   FLOAT
);


# 插入数据
INSERT INTO trip
SELECT
		# 计算跳失用户数
		COUNT(IF(browsing_days=1,1,NULL)) AS trip_cnt,
        # 计算总用户数
		COUNT(user_id) AS all_cnt,
        # 计算跳失率
        COUNT(IF(browsing_days=1,1,NULL))/COUNT(user_id) AS trip_rate
FROM
(
	SELECT  DISTINCT
			user_id,
			# 计算活跃天数
			COUNT(behavior_type) OVER(PARTITION BY user_id) AS browsing_days
	FROM user_behavior
) AS T;