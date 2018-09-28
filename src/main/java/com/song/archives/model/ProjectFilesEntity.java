package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "project__files", schema = "", catalog = "")
public class ProjectFilesEntity implements Serializable{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private long projectId;
    private long phaseId;
    private long fileTypeId;
    private long fileId;

    @Basic
    @Column(name = "projectid")
    public long getProjectId() {
        return projectId;
    }

    public void setProjectId(long projectId) {
        this.projectId = projectId;
    }
    @Basic
    @Column(name = "phaseid")
    public long getPhaseId() {
        return phaseId;
    }

    public void setPhaseId(long phaseId) {
        this.phaseId = phaseId;
    }
    @Basic
    @Column(name = "filetypeid")
    public long getFileTypeId() {
        return fileTypeId;
    }

    public void setFileTypeId(long fileTypeId) {
        this.fileTypeId = fileTypeId;
    }

    @Basic
    @Column(name = "fileid")
    public long getFileId() {
        return fileId;
    }

    public void setFileId(long fileId) {
        this.fileId = fileId;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }
}
