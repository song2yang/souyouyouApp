package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "alert_center", schema = "", catalog = "")
public class AlertCenterEntity implements Serializable{
    private int id;
    private String alertDesc;
    private Integer projectId;
    private Timestamp deadlineTime;
    private Integer hasOvertime;
    private String targetUserids;

    @Id
    @Column(name = "id")
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Basic
    @Column(name = "alert_desc")
    public String getAlertDesc() {
        return alertDesc;
    }

    public void setAlertDesc(String alertDesc) {
        this.alertDesc = alertDesc;
    }

    @Basic
    @Column(name = "project_id")
    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    @Basic
    @Column(name = "deadline_time")
    public Timestamp getDeadlineTime() {
        return deadlineTime;
    }

    public void setDeadlineTime(Timestamp deadlineTime) {
        this.deadlineTime = deadlineTime;
    }

    @Basic
    @Column(name = "has_overtime")
    public Integer getHasOvertime() {
        return hasOvertime;
    }

    public void setHasOvertime(Integer hasOvertime) {
        this.hasOvertime = hasOvertime;
    }

    @Basic
    @Column(name = "target_userids")
    public String getTargetUserids() {
        return targetUserids;
    }

    public void setTargetUserids(String targetUserids) {
        this.targetUserids = targetUserids;
    }

}
