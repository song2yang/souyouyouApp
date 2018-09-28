package com.song.archives.model;

import javax.persistence.*;

@Entity
@Table(name = "chengyandanwei", schema = "", catalog = "")
public class ChengYanDanWeiEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    private String danweiName;
    private String contractName;
    private String mobile;
    private Integer type;
    private long proid;
    private float fee;
    private String contractTime;
    private String yanshouTime;
    private String content;

    @Basic
    @Column(name = "danweiname")
    public String getDanweiName() {
        return danweiName;
    }

    public void setDanweiName(String danweiName) {
        this.danweiName = danweiName;
    }

    @Basic
    @Column(name = "contractname")
    public String getContractName() {
        return contractName;
    }

    public void setContractName(String contractName) {
        this.contractName = contractName;
    }

    @Basic
    @Column(name = "mobile")
    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    @Basic
    @Column(name = "type")
    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    @Basic
    @Column(name = "proid")
    public long getProid() {
        return proid;
    }

    public void setProid(long proid) {
        this.proid = proid;
    }

    @Basic
    @Column(name = "fee")
    public float getFee() {
        return fee;
    }

    public void setFee(float fee) {
        this.fee = fee;
    }

    @Basic
    @Column(name = "contractTime")
    public String getContractTime() {
        return contractTime;
    }

    public void setContractTime(String contractTime) {
        this.contractTime = contractTime;
    }

    @Basic
    @Column(name = "yanshouTime")
    public String getYanshouTime() {
        return yanshouTime;
    }

    public void setYanshouTime(String yanshouTime) {
        this.yanshouTime = yanshouTime;
    }

    @Basic
    @Column(name = "content")
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
