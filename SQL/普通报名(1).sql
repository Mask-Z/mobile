--普通报名列表
select 
(select RowGuid from CQJY_BaoMing where ProjectGuid=View_CQJY_JiaoYiGongGaoAndInfoNew.ProjectGuid And DanWeiGuid='@DanWeiGuid') BaoMingGuid,
(select SystemType from CQJY_GongChengInfo where CQJY_GongChengInfo.RowGuid=View_CQJY_JiaoYiGongGaoAndInfoNew.ProjectGuid) SystemType,
case (select SystemType from CQJY_GongChengInfo where CQJY_GongChengInfo.RowGuid=View_CQJY_JiaoYiGongGaoAndInfoNew.ProjectGuid)
when 'NMG' then 
  case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ProjectGuid=View_CQJY_JiaoYiGongGaoAndInfoNew.ProjectGuid))
  when '1' then '1'
  else '0'
  end
when 'GQ' then 
  case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ProjectGuid=View_CQJY_JiaoYiGongGaoAndInfoNew.ProjectGuid))
  when '1' then '1'
  else '0'
  end
when 'ZZKG' then
  case (select IsJmrProviseEnable from JGSetMessage where JGCode in(select XiaQuCode from CQJY_GongChengInfo where CQJY_GongChengInfo.ProjectGuid=View_CQJY_JiaoYiGongGaoAndInfoNew.ProjectGuid))
  when '1' then '1'
  else '0'
  end
else '1'
end as IsOpen
,* from View_CQJY_JiaoYiGongGaoAndInfoNew where
GongGaoStatusCode='9' and AuditStatus='3'
and isnull(IsSetJJZT,'') !='1' 
and isnull(ProjectControlType,'') !='2'
and isnull(IsLiuBiao,'')!='1'
--and GongGaoFromDate > getdate() --未开始
and GongGaoFromDate <=getdate() and GongGaoToDate > Getdate() --报名中
--and GongGaoToDate <getdate() --报名结束
--and exists(select 1 from CQJY_BaoMing where ProjectGuid=View_CQJY_JiaoYiGongGaoAndInfoNew.ProjectGuid And DanWeiGuid='@DanWeiGuid')  --我的报名
order by Row_ID desc  --非我的报名的排序
--order by (case when GongGaoToDate>=getdate() then 0 else 1 end),Row_ID desc   --我的报名时的排序
