package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "huojiang", schema = "", catalog = "")
public class HuoJiangEntity implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String jiangliType;
    private String huojiangDengji;
    private Date huojiangDate;
    private Long proId;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getHuojiangDate() {
        return huojiangDate;
    }

    public void setHuojiangDate(Date huojiangDate) {
        this.huojiangDate = huojiangDate;
    }

    public String getJiangliType() {
        return jiangliType;
    }

    public void setJiangliType(String jiangliType) {
        this.jiangliType = jiangliType;
    }

    public String getHuojiangDengji() {
        return huojiangDengji;
    }

    public void setHuojiangDengji(String huojiangDengji) {
        this.huojiangDengji = huojiangDengji;
    }

    public Long getProId() {
        return proId;
    }

    public void setProId(Long proId) {
        this.proId = proId;
    }
}
