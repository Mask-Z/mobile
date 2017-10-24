package com.ccjt.ejy.web.quartz.job;

import com.alibaba.fastjson.JSON;
import com.ccjt.ejy.web.commons.cache.DBCacheManage;
import com.ccjt.ejy.web.commons.cache.RedisKeys;
import com.ccjt.ejy.web.commons.db.connection.ConnectionFactory;
import com.ccjt.ejy.web.services.SQL;
import com.ccjt.ejy.web.vo.GongGao;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import static com.ccjt.ejy.web.commons.JDBC.jdbc;

public class IndexInfoJob extends QuartzJobBean {

    private static Logger log = LogManager.getLogger(IndexInfoJob.class);

    @Override
    protected void executeInternal(JobExecutionContext arg0)
            throws JobExecutionException {

        update_jygg();

    }

    /**
     * 交易公告处理
     */
    public void update_jygg() {
        Date now = new Date();
        try {
            log.info("update jygg cache....");
            List<GongGao> list = jdbc.beanList(SQL.index_jygg_info_sql, GongGao.class);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            for (GongGao gg : list) {

//				String new_end_date = jdbc.getString("select top 1 planendtime from jqxt_projectinfo where OrgBiaoDiGuid=? order by row_id desc",gg.getProjectguid());
//				if(StringUtils.isNotBlank(new_end_date)){
//					gg.setJingjia_end(sdf.parse(new_end_date));
//				}

                if ("1".equals(gg.getAllowMoreJqxt())) {

                    String erci_sql = " select top 1 JingJiaFangShi JingJiaFangShi_1,cast(PlanEndTime as datetime) jingjia_end ,cast(begindate as datetime) jingjia_start  from JQXT_ProjectInfo where OrgBiaoDiGuid=? order by Row_ID desc ";
                    GongGao g = jdbc.bean(erci_sql, GongGao.class, gg.getProjectguid());
                    if (g != null) {
                        gg.setJingjia_start(g.getJingjia_start());
                        gg.setJingjia_end(g.getJingjia_end());
                        gg.setJingjiafangshi_1(g.getJingjiafangshi());
                    }


                }

                //判断是否密封式报价
                if ("3".equals(gg.getJingjiafangshi())) {
                    if (!"1".equals(gg.getIsfrompricexs())) {
                        gg.setGuapaiprice("****");
                    }
                }

                if ("1".equals(gg.getIspllr())) {
                    gg.setCount(jdbc.getInteger("select count(1) from CQJY_GongChengInfo where ProjectRegGuid=?", gg.getInfoid()));
                }

                //				1终结  2中止  3重新挂牌  null 正常项目
                Integer controlType = gg.getControltype();
                if (gg.getGonggaofromdate() == null) {
                    gg.setStatus(-1);
                } else if (now.before(gg.getGonggaofromdate())) {//报名未开始

                    gg.setStatus(0);

                } else if (StringUtils.isNotBlank(gg.getCjgg_guid())) {//已成交

                    gg.setStatus(6);

                }        /**
                 * 如果中止终结状态不为空,就在列表页显示中止终结的状态
                 */
                else if (null != controlType && controlType != 0 && controlType != 3) {
                    if (controlType == 1) {
                        gg.setStatus(7);
                    } else if (controlType == 2) {
                        gg.setStatus(8);
                    }
                } else if (now.after(gg.getGonggaofromdate()) && now.before(gg.getGonggaotodate())) {//报名中

                    gg.setStatus(1);

                } else if (gg.getJingjia_end() != null) {//有竞价数据

                    if (now.after(gg.getJingjia_start()) && now.before(gg.getJingjia_end())) {//竞价中

                        gg.setStatus(4);

                    } else if (now.before(gg.getJingjia_start())) {//竞价未开始

                        gg.setStatus(3);

                    } else if (now.after(gg.getJingjia_end())) {//竞价已截止

                        gg.setStatus(5);

                    }

                } else if (now.after(gg.getGonggaotodate())) {//报名已截止

                    gg.setStatus(2);

                }
                /**
                 * 非专厅.批量挂牌项目
                 */
                if (StringUtils.isBlank(gg.getZt()) && !gg.getProjectnum().startsWith("CQJY")) {
                    gg.setSbm("1");
                    String guid = jdbc.getString("select ProjectGuid from CQJY_GongChengInfo where ProjectNo=? ", gg.getProjectnum());
                    if (StringUtils.isNotBlank(guid)) {
                        // 报名人数
                        Integer bmrs = jdbc.getInteger("select count(1) from CQJY_BaoMingNMG where BiaoDiGuid=?", guid);
                        if (bmrs == null || bmrs == 0) {
                            bmrs = jdbc.getInteger("select count(1) from CQJY_BaoMing where BiaoDiGuid=?", guid);
                        }
                        gg.setBmrs(bmrs);
                    }
                }


            }

            String cache = JSON.toJSONString(list);
            DBCacheManage.set(RedisKeys.KEY_DB_CACHE_INDEX_JYGG, cache);
        } catch (Exception e) {
            log.error("更新首页_交易公告cache出错:", e);
        } finally {
            ConnectionFactory.close();
        }
    }


}
