package com.song.archives.dao;

import java.math.BigInteger;

/**
 * Created by souyouyou on 2018/2/15.
 */

public class UserRole {
    private BigInteger userId;
    private BigInteger roleId;
    private String roleName;
    private BigInteger marker;

    public UserRole(){

    }

    public UserRole(BigInteger userId, BigInteger roleId, String roleName, BigInteger marker) {
        this.userId = userId;
        this.roleId = roleId;
        this.roleName = roleName;
        this.marker = marker;
    }

    public BigInteger getUserId() {
        return userId;
    }

    public void setUserId(BigInteger userId) {
        this.userId = userId;
    }

    public BigInteger getRoleId() {
        return roleId;
    }

    public void setRoleId(BigInteger roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public BigInteger getMarker() {
        return marker;
    }

    public void setMarker(BigInteger marker) {
        this.marker = marker;
    }
}
