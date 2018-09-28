package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "project_phase", schema = "", catalog = "")
public class ProjectPhaseEntity implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String phaseName;

    @Basic
    @Column(name = "phaseName")
    public String getPhaseName() {
        return phaseName;
    }

    public void setPhaseName(String phaseName) {
        this.phaseName = phaseName;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }
}
