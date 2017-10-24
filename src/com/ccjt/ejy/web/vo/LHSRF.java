package com.ccjt.ejy.web.vo;

/**
 * 联合受让方
 */
public class LHSRF {
    private String id;
    private String RowGuid;
    private String ShouRangName;
    private String ShouRangPercent;
    private String ShouRangGufen;
    private String ShouRangRenType;//1.按比例转让  2.按股份转让

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRowGuid() {
        return RowGuid;
    }

    public void setRowGuid(String rowGuid) {
        RowGuid = rowGuid;
    }

    public String getShouRangName() {
        return ShouRangName;
    }

    public void setShouRangName(String shouRangName) {
        ShouRangName = shouRangName;
    }

    public String getShouRangPercent() {
        return ShouRangPercent;
    }

    public void setShouRangPercent(String shouRangPercent) {
        ShouRangPercent = shouRangPercent;
    }

    public String getShouRangGufen() {
        return ShouRangGufen;
    }

    public void setShouRangGufen(String shouRangGufen) {
        ShouRangGufen = shouRangGufen;
    }

    public String getShouRangRenType() {
        return ShouRangRenType;
    }

    public void setShouRangRenType(String shouRangRenType) {
        ShouRangRenType = shouRangRenType;
    }
}
