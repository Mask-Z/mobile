select 
(select RowGuid from CQJY_BaoMing where ZhuanTingGuid=CQJY_JingJiaZhuanTing.ZhuanTingGuid And DanWeiGuid='@DanWeiGuid') BaoMingGuid,
case CQJY_JingJiaZhuanTing.SystemType
when 'NMG' then 
  case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ZhuanTingGuid=CQJY_JingJiaZhuanTing.ZhuanTingGuid))
  when '1' then '1'
  else '0'
  end
else '1'
end as IsOpen
,* from CQJY_JingJiaZhuanTing where 
AuditStatus='3'
--and Exists(Select 1 From CQJY_GongChengInfo Where ZhuanTingGuid=CQJY_JingJiaZhuanTing.ZhuanTingGuid And ISNULL(IsLiuBiao,'')<>'1' And isnull(ProjectControlType,'') <>'2')
--and BaoMingStartDate > getdate()    --未开始
and BaoMingStartDate <=getdate() and BaoMingEndDate > Getdate()    --正在报名
--and BaoMingEndDate <getdate()    --已结束
--and exists(select 1 from CQJY_BaoMing where ZhuanTingGuid=CQJY_JingJiaZhuanTing.ZhuanTingGuid And DanWeiGuid='@DanWeiGuid')    --我的报名项目
order by Row_ID desc  --非我的报名的排序
--order by (case when BaoMingEndDate>=getdate() then 0 else 1 end),Row_ID desc  --我的报名时的排序