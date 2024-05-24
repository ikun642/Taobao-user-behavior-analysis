-- 计算每日的留存率和流失率
-- 先对数据进行去重,然后使用窗口函数获得下一次的活跃日期next_dates,最后进行筛选计数
# 创建表格储存次日留存率
CREATE TABLE retention_churn
(
 dates 		  	 CHAR(10),
 retention_rate  FLOAT,
 churn_rate		 FLOAT
);

# 插入数据
INSERT INTO retention_churn
SELECT
		dates,
        # 如果下一次活跃日期与上一次活跃日期相差1,则表示留存,从而计算留存率
		COUNT(IF(DATEDIFF(next_dates,dates)=1,user_id,NULL))/COUNT(user_id) AS retention_rate,
        # 计算流失率
        1-(COUNT(IF(DATEDIFF(next_dates,dates)=1,user_id,NULL))/COUNT(user_id)) AS churn_rate
FROM 
	(
    SELECT	
		user_id,
        dates,
         # 取出用户的下一次活跃日期
        LEAD(dates,1,NULL) OVER(PARTITION BY user_id ORDER BY dates ASC) AS next_dates
	FROM 
		( # 进行去重
         SELECT DISTINCT
				user_id,
				dates
		 FROM user_behavior
		) T1
	)T2
GROUP BY dates;