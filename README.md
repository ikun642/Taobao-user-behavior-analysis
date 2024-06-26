# 淘宝用户行为分析

## 声明
* 本项目数据集来自[阿里云天池](https://tianchi.aliyun.com/dataset/649)
* 可视化结果链接[Tableau](https://public.tableau.com/app/profile/.86002602/viz/_17166758240740/sheet0)
* 数据的导入建议使用Kettle,请自行搜索
* 本文档中的结果表格大多仅显示前5行
## 数据预处理
### 步骤
1. 更改字段名
2. 去除空值
3. 新增日期列
4. 去除异常值
### 结果

##### user_behavior(old)

| user_id | item_id | category_id | behavior_type | timestamp  |
|---------|---------|-------------|---------------|------------|
| 1       | 2268318 | 2520377     | pv            | 1511544070 |
| 1       | 2333346 | 2520771     | pv            | 1511561733 |
| 1       | 2576651 | 149192      | pv            | 1511572885 |
| 1       | 3830808 | 4181361     | pv            | 1511593493 |
| 1       | 4365585 | 2520377     | pv            | 1511596146 |

##### user_behavior(new)

| id  | user_id | item_id | category_id | behavior_type | timestamps | datetimes           | dates      | times    | hours |
| --- | ------- | ------- | ----------- | ------------- | ---------- | ------------------- | ---------- | -------- | ----- |
| 1   | 1       | 2268318 | 2520377     | pv            | 1511544070 | 2017/11/25 01:21:10 | 2017/11/25 | 01:21:10 | 01    |
| 2   | 1       | 2333346 | 2520771     | pv            | 1511561733 | 2017/11/25 06:15:33 | 2017/11/25 | 06:15:33 | 06    |
| 3   | 1       | 2576651 | 149192      | pv            | 1511572885 | 2017/11/25 09:21:25 | 2017/11/25 | 09:21:25 | 09    |
| 4   | 1       | 3830808 | 4181361     | pv            | 1511593493 | 2017/11/25 15:04:53 | 2017/11/25 | 15:04:53 | 15    |
| 5   | 1       | 4365585 | 2520377     | pv            | 1511596146 | 2017/11/25 15:49:06 | 2017/11/25 | 15:49:06 | 15    |

## 用户行为习惯分析

### 流量指标
#### 步骤
1. 计算每日的页面浏览量pv
2. 计算每日的独立访客数uv
3. 计算每日平均访问深度puv(pv/uv)
4. 计算用户的跳失率trip_rate

#### 结果
##### pv_uv_puv

| dates      | pv      | uv     | puv   |
|------------|---------|--------|-------|
| 2017/11/25 | 9353416 | 686953 | 13\.6 |
| 2017/11/26 | 9567422 | 695869 | 13\.7 |
| 2017/11/27 | 9041186 | 689260 | 13\.1 |
| 2017/11/28 | 8842932 | 688042 | 12\.9 |
| 2017/11/29 | 9210819 | 697542 | 13\.2 |

##### trip

| trip\_cnt | all\_cnt | trip\_rate   |
|-----------|----------|--------------|
| 88        | 987991   | 0\.000089069 |

### 转换指标
#### 步骤
* 按日期-小时来统计各种行为的数据

| 行为类型 | 说明    |
|------|-------|
| pv   | 浏览商品  |
| buy  | 购买商品  |
| cart | 加入购物车 |
| fav  | 收藏商品  |
#### 结果
##### date_hour_behavior

| dates      | hours | pv     | cart  | fav   | buy  |
|------------|-------|--------|-------|-------|------|
| 2017/11/25 | 00    | 310286 | 17031 | 10751 | 5353 |
| 2017/11/25 | 01    | 142946 | 8458  | 5135  | 2221 |
| 2017/11/25 | 02    | 77045  | 4614  | 2712  | 1264 |
| 2017/11/25 | 03    | 53035  | 3219  | 1593  | 813  |
| 2017/11/25 | 04    | 45876  | 2973  | 1533  | 704  |

### 路径分析

#### 步骤
* 统计各类购买路径的数量num
#### 结果
##### path_result
| path\_type | descriptions | num    |
|------------|--------------|--------|
| 1001       | 浏览后购买        | 949273 |
| 0001       | 直接购买         | 515682 |
| 1011       | 浏览加购后购买      | 255488 |
| 1101       | 浏览收藏后购买      | 88009  |
| 0011       | 加购后购买        | 76330  |
| 0101       | 收藏后购买        | 25884  |
| 1111       | 浏览收藏加购后购买    | 13469  |
| 0111       | 收藏加购后购买      | 1892   |

### 留存情况
#### 步骤
1. 计算每日的用户(次日)留存率retention_rate
2. 计算每日的用户(次日)流失率churn_rate
#### 结果
##### retention_churn

| dates      | retention\_rate | churn\_rate |
| ---------- | --------------- | ----------- |
| 2017/11/25 | 0\.7887         | 0\.2113     |
| 2017/11/26 | 0\.777312       | 0\.222688   |
| 2017/11/27 | 0\.78484        | 0\.21516    |
| 2017/11/28 | 0\.791348       | 0\.208652   |
| 2017/11/29 | 0\.795558       | 0\.204442   |
| 2017/11/30 | 0\.796272       | 0\.203728   |
| 2017/12/01 | 0\.982475       | 0\.0175251  |
| 2017/12/02 | 0\.979785       | 0\.0202153  |
| 2017/12/03 | 0               | 1           |

## 用户消费习惯分析
### 货物热度
#### 步骤
1. 计算各品类热度(浏览量)
2. 计算各商品热度(浏览量)
#### 结果

##### category_popularity

| category_id | pv      |
| ----------- | ------- |
| 4756105     | 4477682 |
| 2355072     | 3151734 |
| 4145813     | 3150716 |
| 3607361     | 2976357 |
| 982926      | 2798730 |

##### item_popularity

| item_id | pv    |
| ------- | ----- |
| 812879  | 30079 |
| 3845720 | 25650 |
| 138964  | 21103 |
| 2331370 | 19482 |
| 2032668 | 19141 |

### 货物转化率
#### 步骤
1. 计算各品类转化率(购买用户数/总用户数)
2. 计算各商品转化率(购买用户数/总用户数)

#### 结果
##### category_conversion

| category_id | conversion_rate |
| ----------- | --------------- |
| 1464116     | 0.030317        |
| 2735466     | 0.029109        |
| 4145813     | 0.027864        |
| 2885642     | 0.027448        |
| 4756105     | 0.024043        |

##### item_conversion

| item_id | conversion_rate |
| ------- | --------------- |
| 3122135 | 0.00141         |
| 3031354 | 0.000887        |
| 3964583 | 0.000661        |
| 2560262 | 0.000642        |
| 1910706 | 0.000554        |

## 用户价值分析
### 步骤（RFM模型）
1. 获取用户最近一次的消费日期(Recency)
2. 获取用户的消费频率(Frequency)
3. 根据Recency和Frequency的百分比排名对用户进行分类
* 分类表

| 分类表                       | Rency\_rank<=0\.5 | Rency\_rank>0\.5 |
| ------------------------- | ----------------- | ---------------- |
| **Frequency\_rank<=0\.5** | 价值用户              | 发展用户             |
| **Frequency\_rank>0\.5**  | 保持用户              | 挽留用户             |

### 结果
##### rfm_model

| user_id | recency    | recency_rank | frequency | frequency_rank           | class |
| ------- | ---------- | ------------ | --------- | ------------------------ | ----- |
| 486458  | 2017-12-03 | 0            | 262       | 0                        | 价值用户  |
| 702034  | 2017-12-03 | 0            | 159       | 0.0000029744067174001307 | 价值用户  |
| 107013  | 2017-12-03 | 0            | 131       | 0.000004461610076100196  | 价值用户  |
| 1014116 | 2017-12-03 | 0            | 118       | 0.000005948813434800261  | 价值用户  |
| 432739  | 2017-12-03 | 0            | 112       | 0.000007436016793500326  | 价值用户  |

## 数据可视化
* 可使用Tableau对上述表格数据进行可视化处理
* 可视化结果链接[Tableau](https://public.tableau.com/app/profile/.86002602/viz/_17166758240740/sheet0)
