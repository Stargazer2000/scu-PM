# 开发文档
## 系统结构
系统由**服务器**和**前端**两大部分构成，其中前端又可分为两种，分别是**校区管理员**以及**小组管理员**。所有的前端均与数据库直连，通过数据库的权限管理实现分级管理的效果。
## 关系数据表格式
### 物品数据表
所有字段请与[需求表](Requirement.md)中的信息按序比对。(第一项是唯一ID，未来可以对应二维码)
```sql
CREATE TABLE propertys(
    uuid char(12),
    eq_name int,
    eq_type char(20),
    brand char(20),
    wbdw char(40),
    start_time char(128),
    time_limit int,
    sfjz int,
    is_available int,
    local_place char(12),
    manager char(12) 
    signal char(1)
)
```
最后一项是“当前地点”。
(注意这里面没有地点相关的信息和故障信息，分别存放在地点表和故障表)
`uuid`唯一id，
`eq_name`设备名称，
`eq_type`规格型号，
`brand`品牌，
`wbdw`维保单位，
`qysj`启用时间，
`time_limit`质保期限，以年为单位，
`sfjz`是否建账，是或否。
`is_available`是否可备用，默认为不可备用，可以选择可备用。
`local_place`当前地点，对应的是地点表中的`UUID`。
`manager`小组管理者，uuid
`signal`为状态，代表当前物品的状态情况，包含`1 待审核`，`2 正常使用`，`3 故障待维修`，`4 正在变动地点`，`9 报废`
### 地点表
用于生成每一个地点的位置和唯一的id用于字段间引用
```sql
CREATE TABLE places(
    UUID char(12),
    dd_first char(10),
    dd_second char(10),
    dd_third int,
    dd_fourth char(10)
)
```
+ first为校区
+ second为教学楼
+ third为层数
+ fourth为门牌号
地点表根据录入信息分配uuid，如果表中有相同的，则不录入新的id，如果没有相同地点，则直接添加一条该地点的信息即可。
### 变动地点表
```sql
CREATE TABLE move_places(
    item_id char(12),
    from_place char(12),
    to_place char(12),
    requester char(12),
    commiter char(12),
    req_time char(128),
    com_time char(128)
)
```
保存了每一次移动的物品id，初始地点，去向，以及请求时间，受理时间。
### 故障信息表
```sql
CREATE TABLE broken(
    id
    item_id char(12),
    broke_time varchar(255),
    reason varchar(255),
    repair_time varchar(255),
    repair_method varchar(255),
)
```
保存了故障信息，
### 申请信息表
```sql
CREATE TABLE request_tb(
    id char(12),
    item_id char(12),
    requester char(12),
    commiter char(12),
    signal int
    
)
```
+ ID是信息的唯一ID，递增
+ send_who是发送的人的账户
+ to_who是需要处理该信息的人的账户
+ type_of_msg是记录该消息需要查找的表的内容。
+ status_now记录了这个消息是否结束
+ msg_ID记录的是在对应表中，需要查找的信息的ID。
+ 申请是否结束。
### 用户表
xxxxx

## 前端实现
### 登录界面
+ 无论哪个前端，均需要一个登录界面与数据库沟通，获取访问权限。
仅仅实现输入用户名并保存即可，用于与数据库沟通确认身份使用。
+ 需要实现密码模糊化。
+ 登录完成后的界面提供“提醒消息”，即所有的需要该成员进行操作的事件。
  + 消息从“申请信息表”中读取。
  + 小组间变动，从A转入B时，需要在B处留下消息直到B处理完成交接后消失。
  + 故障提醒，当故障出现时，对对应的管理员发送消息。直到故障排除之后（填写完故障排除方式）才会取消消息。
+ 该界面可以提供进入其他界面的“按钮”，权限不符合的，对应功能按钮**变灰**。
### 已有设备管理界面
+ 根据筛选条件，布置sql语句，按顺序呈现设备信息，默认按教室号排序。
+ 设备信息可以修改，查询，并将查询的设备信息以excel方式导出。
+ 需要审查权限，小组管理员智能查看，操作“自身范围”的设备信息，但不能删除。而校区管理员拥有所有权限。
### 校区管理员操作界面
#### 需要实现的功能
+ 增删查改物品信息（在前文管理界面已经实现）
+ 对于小组管理员提交的新设备进行审批，包括：
  + 通过
  + 驳回+驳回信息
  + 批量操作和逐条操作并存
+ 人员表管理（即数据库账户管理）,确认每个小组管理员的管辖范围。

### 小组管理员操作界面
#### 需要实现的功能
+ 查改物品信息，要求只能查看自己管辖范围内的物品（在前文管理界面已经实现）
+ 提交设备录入申请
  + 要求可以单条系统内录入
  + 也可从excel按格式组织好后，直接导入管理系统(导入数据可的申请信息表中）。
+ 小组间转移物资，需要提交申请信息到申请信息表中。
