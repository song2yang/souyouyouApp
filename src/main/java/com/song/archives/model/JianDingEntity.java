package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "jianding", schema = "", catalog = "")
public class JianDingEntity implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private Date jianDingTime;
    private String  zhuchiBumen;
    private Long jdproid;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Date getJianDingTime() {
        return jianDingTime;
    }

    public void setJianDingTime(Date jianDingTime) {
        this.jianDingTime = jianDingTime;
    }

    public String getZhuchiBumen() {
        return zhuchiBumen;
    }

    public void setZhuchiBumen(String zhuchiBumen) {
        this.zhuchiBumen = zhuchiBumen;
    }

    public Long getJdproid() {
        return jdproid;
    }

    public void setJdproid(Long jdproid) {
        this.jdproid = jdproid;
    }
}
