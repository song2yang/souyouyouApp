package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "menu_type", schema = "", catalog = "")
public class MenuTypeEntity implements Serializable{
    private long id;
    private String typeName;
    private String typeDesc;
    private Integer parentTypeid;
    private Integer type;
    private Date createTime = new Date();

    @Basic
    @Column(name = "type")
    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "type_name")
    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    @Basic
    @Column(name = "type_desc")
    public String getTypeDesc() {
        return typeDesc;
    }

    public void setTypeDesc(String typeDesc) {
        this.typeDesc = typeDesc;
    }

    @Basic
    @Column(name = "parent_typeid")
    public Integer getParentTypeid() {
        return parentTypeid;
    }

    public void setParentTypeid(Integer parentTypeid) {
        this.parentTypeid = parentTypeid;
    }

    @Basic
    @Column(name = "create_time")
    @Temporal(TemporalType.TIMESTAMP)
    public Date getCreateTime() {
        return this.createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }


    @Override
    public String toString() {
        return "案例菜单【" +
                "菜单名称:'" + typeName + '\'' +
                ", 菜单描述:'" + typeDesc + '\'' +
                ", 上级菜单:" + parentTypeid +
                '】';
    }
}
