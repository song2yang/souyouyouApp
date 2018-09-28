package com.song.archives.auth;

import com.song.archives.dao.PermissionRepository;
import com.song.archives.dao.UserRepository;
import com.song.archives.model.Permission;
import com.song.archives.model.Role;
import com.song.archives.model.User;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Iterator;


public class AuthRealm extends AuthorizingRealm {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PermissionRepository permissionRepository;

    /**
     * 授权用户权限
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();

        User user  = (User) principals.getPrimaryPrincipal();

        //超级管理员
        if (user.getUsername().equals("superadmin")){
            authorizationInfo.addRole("superadmin");

            Iterable<Permission> permissions = permissionRepository.findAll();
            Iterator<Permission> iterator = permissions.iterator();

            while (iterator.hasNext()){
                authorizationInfo.addStringPermission(iterator.next().getIdentification());
            }

        }
        //安全管理员
        if (user.getUsername().equals("securitor")){
            authorizationInfo.addRole("securitor");
        }
        //系统管理员
        if (user.getUsername().equals("administrator")){
            authorizationInfo.addRole("administrator");
        }
        //安全审计员
        if (user.getUsername().equals("comptroller")){
            authorizationInfo.addRole("comptroller");
        }

        if(user.getRoles() != null){
            for(Role role:user.getRoles()){
                authorizationInfo.addRole(role.getIdentification());
                for(Permission p:role.getPermissions()){
                    authorizationInfo.addStringPermission(p.getIdentification());
                }
            }
        }

        return authorizationInfo;
    }
    /**
     * 验证用户身份
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(
            AuthenticationToken authcToken) throws AuthenticationException {

//        System.out.println("MyShiroRealm.doGetAuthenticationInfo()");
        //获取用户的输入的账号.
        UsernamePasswordToken token = (UsernamePasswordToken) authcToken;
        User user = userRepository.findByUsername(token.getUsername());
        //通过username从数据库中查找 User对象，如果找到，没找到.
        //实际项目中，这里可以根据实际情况做缓存，如果不做，Shiro自己也是有时间间隔机制，2分钟内不会重复执行该方法

        if(user == null){
            throw new UnknownAccountException();
        }

        if(!user.getAvailable()){
            throw new DisabledAccountException();
        }

        ByteSource credentialsSalt = ByteSource.Util.bytes(user.getUsername());


        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(user, user.getPassword(), credentialsSalt,getName());
        return authenticationInfo;
    }

}