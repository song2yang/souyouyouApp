package com.song.archives.model;

import javax.persistence.*;

@Entity
@Table(name = "phasefile_type", schema = "", catalog = "")
public class PhaseFileTypeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private long phaseId;

    private String fileTypeName;

    @Basic
    @Column(name = "phaseid")
    public long getPhaseId() {
        return phaseId;
    }

    public void setPhaseId(long phaseId) {
        this.phaseId = phaseId;
    }

    @Basic
    @Column(name = "filetypename")
    public String getFileTypeName() {
        return fileTypeName;
    }

    public void setFileTypeName(String fileTypeName) {
        this.fileTypeName = fileTypeName;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }
}
