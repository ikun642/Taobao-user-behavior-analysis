-- 检查字段名
DESC user_behavior;
SELECT * 
FROM user_behavior 
LIMIT 5;

# 发现timestamp与数据类型重名,改为timestamps
ALTER TABLE user_behavior CHANGE timestamp timestamps INT(14);


-- 检查空值
SELECT * FROM user_behavior WHERE user_id IS NULL;
SELECT * FROM user_behavior WHERE item_id IS NULL;
SELECT * FROM user_behavior WHERE category_id IS NULL;
SELECT * FROM user_behavior WHERE behavior_type IS NULL;
SELECT * FROM user_behavior WHERE timestamps IS NULL;


-- 检查重复值即user_id,item_id,timestamps不能同时相同
SELECT user_id,item_id,timestamps FROM user_behavior
GROUP BY user_id,item_id,timestamps
HAVING COUNT(*) > 1;

# 进行去重:建立一个自增的字段id辅助去重
ALTER TABLE user_behavior ADD id BIGINT(50)  PRIMARY KEY AUTO_INCREMENT FIRST;

# 进行去重:对重复记录,取出最小的id对应的记录,将其他记录删除
SET SQL_SAFE_UPDATES = 0;
DELETE user_behavior FROM user_behavior,
(SELECT user_id, item_id, timestamps,MIN(id) AS id FROM user_behavior
GROUP BY user_id,item_id,timestamps
HAVING COUNT(*) > 1) T
WHERE user_behavior.user_id = T.user_id
AND user_behavior.item_id = T.item_id
AND user_behavior.timestamps = T.timestamps
AND user_behavior.id > T.id;


-- 新增日期列:datetimes dates times hours
# 提高缓冲值buffer
SHOW VARIABLES LIKE '%_buffer%';
SET GLOBAL innodb_buffer_pool_size = 10737418240;

# 新增时间列datetimes
ALTER TABLE user_behavior ADD datetimes TIMESTAMP(0); 
# datetimes由timestamps的值转换而来
UPDATE user_behavior SET datetimes = FROM_UNIXTIME(timestamps);

# 新增dates、times、hours
ALTER TABLE user_behavior 
	ADD dates CHAR(10),
	ADD times CHAR(8),
	ADD hours CHAR(2);
    
# dates、times、hours从datetimes中提取而来
UPDATE user_behavior 
SET dates = SUBSTRING(datetimes,1,10),
	times = SUBSTRING(datetimes,12,8),
    hours = SUBSTRING(datetimes,12,2);

-- 去除异常值
# 先查找最大和最小日期,确定是否有异常值
SELECT MAX(datetimes),MIN(datetimes) FROM user_behavior;
# 对异常数据,即datimes在2017-11-25至2017-12-03以外的数据进行去除
DELETE FROM user_behavior
WHERE datetimes < '2017-11-25 00:00:00'
	OR datetimes > '2017-12-03 23:59:59';


-- 数据概览
DESC user_behavior;
SELECT * FROM user_behavior LIMIT 5;
SELECT COUNT(1) FROM user_behavior;
