package com.ccjt.ejy.web.vo;

/**
 * 受让方
 */
public class SRF {
    private String  id;
    private String UnitOrgNum;
    private String DanWeiName;
    private String DanWeiGuid;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUnitOrgNum() {
        return UnitOrgNum;
    }

    public void setUnitOrgNum(String unitOrgNum) {
        UnitOrgNum = unitOrgNum;
    }

    public String getDanWeiName() {
        return DanWeiName;
    }

    public void setDanWeiName(String danWeiName) {
        DanWeiName = danWeiName;
    }

    public String getDanWeiGuid() {
        return DanWeiGuid;
    }

    public void setDanWeiGuid(String danWeiGuid) {
        DanWeiGuid = danWeiGuid;
    }
}
