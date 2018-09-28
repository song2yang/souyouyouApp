package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "notify", schema = "", catalog = "")
public class NotifyEntity implements Serializable {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String operateTime;
    @Lob
    private String content;
    private String approver;
    private String personal;
    private Integer fileClassify;
    private Long fileId;

    public Long getFileId() {
        return fileId;
    }

    public void setFileId(Long fileId) {
        this.fileId = fileId;
    }

    public Integer getFileClassify() {
        return fileClassify;
    }

    public void setFileClassify(Integer fileClassify) {
        this.fileClassify = fileClassify;
    }

    public String getPersonal() {
        return personal;
    }

    public void setPersonal(String personal) {
        this.personal = personal;
    }

    public String getApprover() {
        return approver;
    }

    public void setApprover(String approver) {
        this.approver = approver;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getOperateTime() {
        return operateTime;
    }

    public void setOperateTime(String operateTime) {
        this.operateTime = operateTime;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
