package com.song.archives.model;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.*;

@Entity
public class Role implements Serializable{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    @Column(unique = true)
    /*角色标识 程序中判断使用,如"admin"*/
    private String identification;
    /*角色描述,UI界面显示使用*/
    private String description;
    private Boolean available = Boolean.FALSE;

    @ManyToMany(targetEntity = Permission.class, cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    @JoinTable(name = "role_permission", joinColumns = @JoinColumn(name = "role_id", referencedColumnName = "id") , inverseJoinColumns = @JoinColumn(name = "permission_id", referencedColumnName = "id") )
    private Set<Permission> permissions = new HashSet<>();

    public Role(){

    }

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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getAvailable() {
        return available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }

    public Set<Permission> getPermissions() {
        return permissions;
    }

    public void setPermissions(Set<Permission> permissions) {
        this.permissions = permissions;
    }

    @Override
    public String toString() {
        return "【" +
                "角色名称:'" + name + '\'' +
                ", 角色标识:'" + identification + '\'' +
                ", 角色描述:'" + description + '\'' +
                '】';
    }
}