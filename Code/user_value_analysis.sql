# 创建表格
CREATE TABLE rfm_model
(
 user_id				INT(9),
 recency				CHAR(10),
 recency_rank			DOUBLE,
 frequency				INT,
 frequency_rank			DOUBLE
);

# 添加基础数据
INSERT INTO rfm_model
SELECT 
		user_id,
        # 最近一次消费时间,并进行百分比排名
        MAX(dates) AS last_purchase_recency,
		PERCENT_RANK() OVER(ORDER BY MAX(dates) DESC) AS recency_rank,
        # 消费频率,并进行百分比排名
        COUNT(user_id) AS purchase_frequency,
		PERCENT_RANK() OVER(ORDER BY COUNT(user_id) DESC) AS frequency_rank       
FROM user_behavior
WHERE behavior_type = 'buy'
GROUP BY user_id
ORDER BY last_purchase_recency DESC, purchase_frequency DESC;

# 添加class分类
ALTER TABLE rfm_model ADD COLUMN class VARCHAR(40);
SET SQL_SAFE_UPDATES = 0;
UPDATE rfm_model
SET class = CASE
			WHEN frequency_rank<=0.5 AND recency_rank<=0.5 THEN '价值用户'
			WHEN frequency_rank<=0.5 AND recency_rank>0.5 THEN '保持用户'
			WHEN frequency_rank>0.5 AND recency_rank<=0.5 THEN '发展用户'
			WHEN frequency_rank>0.5 AND recency_rank>0.5 THEN '挽留用户'
			END;
