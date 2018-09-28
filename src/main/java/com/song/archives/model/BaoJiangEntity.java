package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "baojiang", schema = "", catalog = "")
public class BaoJiangEntity implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String jiangLiType;
    private String shenbaoDengji;
    private Date    baojiangDate;
    private Long proId;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getBaojiangDate() {
        return baojiangDate;
    }

    public void setBaojiangDate(Date baojiangDate) {
        this.baojiangDate = baojiangDate;
    }

    public String getJiangLiType() {
        return jiangLiType;
    }

    public void setJiangLiType(String jiangLiType) {
        this.jiangLiType = jiangLiType;
    }

    public String getShenbaoDengji() {
        return shenbaoDengji;
    }

    public void setShenbaoDengji(String shenbaoDengji) {
        this.shenbaoDengji = shenbaoDengji;
    }

    public Long getProId() {
        return proId;
    }

    public void setProId(Long proId) {
        this.proId = proId;
    }
}
