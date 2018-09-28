package com.song.archives.model;

import jxl.write.DateTime;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "yantao_log", schema = "", catalog = "")
public class YantaoLogEntity implements Serializable{
    private long yid;
    private String yantaoTime;
    private String joinerIds;
    private String yantaoContent;
    private String expertComments;
    private String yantaoFid;
    private Timestamp createTime;
    private Long proId;

    @Id
    @Column(name = "yid")
    public long getYid() {
        return yid;
    }

    public void setYid(long id) {
        this.yid = id;
    }

    @Basic
    @Column(name = "yantao_time")
    public String getYantaoTime() {
        return yantaoTime;
    }

    public void setYantaoTime(String yantaoTime) {
        this.yantaoTime = yantaoTime;
    }

    @Basic
    @Column(name = "joiner_ids")
    public String getJoinerIds() {
        return joinerIds;
    }

    public void setJoinerIds(String joinerIds) {
        this.joinerIds = joinerIds;
    }

    @Basic
    @Column(name = "yantao_content")
    public String getYantaoContent() {
        return yantaoContent;
    }

    public void setYantaoContent(String yantaoContent) {
        this.yantaoContent = yantaoContent;
    }

    @Basic
    @Column(name = "expert_comments")
    public String getExpertComments() {
        return expertComments;
    }

    public void setExpertComments(String expertComments) {
        this.expertComments = expertComments;
    }

    @Basic
    @Column(name = "yantao_fid")
    public String getYantaoFid() {
        return yantaoFid;
    }

    public void setYantaoFid(String yantaoFid) {
        this.yantaoFid = yantaoFid;
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
    @Column(name = "proId")
    public Long getProId() {
        return proId;
    }

    public void setProId(Long proId) {
        this.proId = proId;
    }
}
