package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
public class Permission implements Serializable{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String identification; // 权限字符串,menu例子：role:*，button例子：role:create,role:update,role:delete,role:view
    private Boolean available = Boolean.FALSE;
    private String description;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIdentification() {
        return identification;
    }

    public void setIdentification(String identification) {
        this.identification = identification;
    }

    public Boolean getAvailable() {
        return available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    @Override
    public String toString() {
        return "【" +
                "权限名称:'" + name + '\'' +
                ", 权限标识:'" + identification + '\'' +
                ", 权限描述:'" + description + '\'' +
                '】';
    }
}