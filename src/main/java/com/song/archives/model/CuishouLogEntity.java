package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.sql.Timestamp;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "cuishou_log", schema = "", catalog = "")
public class CuishouLogEntity implements Serializable {
    private long id;
    private Date cuishouTime;
    private Double cuishouAmount;
    private String jingbanrenId;
    private String jingbanrenName;
    private String duijierenName;
    private String dafu;
    private Timestamp createTime;
    private Integer alertDays;

    @Basic
    @Column(name = "creator")
    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    private String creator;

    @Basic
    @Column(name = "proid")
    public Long getProid() {
        return proid;
    }

    public void setProid(Long proid) {
        this.proid = proid;
    }

    private Long proid;

    @Id
    @Column(name = "id")
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "cuishou_time")
    public Date getCuishouTime() {
        return cuishouTime;
    }

    public void setCuishouTime(Date cuishouTime) {
        this.cuishouTime = cuishouTime;
    }

    @Basic
    @Column(name = "cuishou_amount")
    public Double getCuishouAmount() {
        return cuishouAmount;
    }

    public void setCuishouAmount(Double cuishouAmount) {
        this.cuishouAmount = cuishouAmount;
    }

    @Basic
    @Column(name = "jingbanren_id")
    public String getJingbanrenId() {
        return jingbanrenId;
    }

    public void setJingbanrenId(String jingbanrenId) {
        this.jingbanrenId = jingbanrenId;
    }

    @Basic
    @Column(name = "duijieren_name")
    public String getDuijierenName() {
        return duijierenName;
    }

    public void setDuijierenName(String duijierenName) {
        this.duijierenName = duijierenName;
    }

    @Basic
    @Column(name = "dafu")
    public String getDafu() {
        return dafu;
    }

    public void setDafu(String dafu) {
        this.dafu = dafu;
    }

    @Basic
    @Column(name = "create_time")
    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    @Basic
    @Column(name = "alert_days")
    public Integer getAlertDays() {
        return alertDays;
    }

    public void setAlertDays(Integer alertDays) {
        this.alertDays = alertDays;
    }
    @Basic
    @Column(name = "jingbanrenName")
    public String getJingbanrenName() {
        return jingbanrenName;
    }

    public void setJingbanrenName(String jingbanrenName) {
        this.jingbanrenName = jingbanrenName;
    }
}
