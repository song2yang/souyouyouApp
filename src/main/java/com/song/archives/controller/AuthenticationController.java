package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.PermissionRepository;
import com.song.archives.dao.RoleRepository;
import com.song.archives.dao.UserRepository;
import com.song.archives.model.Permission;
import com.song.archives.model.Role;
import com.song.archives.model.User;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.Lob;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by souyouyou on 2018/2/26.
 */

@Controller
@RequestMapping("/")
public class AuthenticationController {

    Logger logger = Logger.getLogger(AuthenticationController.class);

    public static String SUCCESS = "success";

    private String msg = "failed";

    private String operationLogInfo = "";

    private JSONObject result = new JSONObject();

    @Autowired
    private UserRepository userRepository;


    @Autowired
    private PermissionRepository permissionRepository;

    @Autowired
    private RoleRepository roleRepository;

    /**
     * 新建角色
     *
     * @param role
     * @return
     */
    @ArchivesLog(operationType = "saveRole", operationName = "新建角色")
    @RequestMapping(value = "saveRole")
    @ResponseBody
    String saveRole(Role role) {

        operationLogInfo = "用户【"+getUser().getUsername()+"】新建角色:"+role.toString();

        try {
            roleRepository.save(role);
            msg = SUCCESS;
        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "Exception";
        }

        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        return result.toString();
    }

    /**
     * 删除角色
     *
     * @param rids
     * @return
     */
    @ArchivesLog(operationType = "deleteRoleByIds", operationName = "删除角色")
    @RequestMapping(value = "deleteRoleByIds")
    @ResponseBody
    String deleteRoleByIds(Long[] rids) {

        operationLogInfo = "用户【"+getUser().getUsername()+"】删除角色【";

        try {
            if (rids != null && rids.length > 0) {

                for (Long rid : rids) {
                    Role role = roleRepository.findOne(rid);
                    List<User> users = userRepository.findUsersByRoleId(rid);
                    operationLogInfo += role.getName()+",";
                    for (User user : users) {
                        user.getRoles().remove(role);
                        userRepository.save(user);
                    }
                    roleRepository.delete(rid);
                }
            }

            msg = SUCCESS;
        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "delete role failed";
        }

        operationLogInfo = operationLogInfo.substring(0,operationLogInfo.length()-1)+"】,操作结果【"+msg+"】";
        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        return result.toString();

    }

    /**
     * 新建权限
     *
     * @param permission
     * @return
     */
    @ArchivesLog(operationType = "savePermission", operationName = "新建权限")
    @RequestMapping(value = "savePermission")
    @ResponseBody
    String savePermission(Permission permission) {


        operationLogInfo = "用户【"+getUser().getUsername()+"】新建权限:"+permission.toString();

        try{
            permissionRepository.save(permission);
            msg = SUCCESS;
        }catch (Exception e){
            msg = "Exception";
        }

        operationLogInfo += ",操作结果【"+msg+"】";

        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        return result.toString();
    }


    /**
     * 删除权限
     *
     * @param pids
     * @return
     */
    @ArchivesLog(operationType = "deletePermissionByIds", operationName = "删除权限")
    @RequestMapping(value = "deletePermissionByIds")
    @ResponseBody
    String deletePermissionByIds(Long[] pids) {

        operationLogInfo = "用户【"+getUser().getUsername()+"】删除权限【";

        try {
            if (pids != null && pids.length > 0) {

                for (Long pid : pids) {
                    Permission permission = permissionRepository.findOne(pid);
                    operationLogInfo += permission.getName()+",";

                    List<Role> roles = roleRepository.findRolesByPermissionId(pid);

                    for (Role role : roles) {
                        role.getPermissions().remove(permission);
                        roleRepository.save(role);
                    }
                    permissionRepository.delete(pid);
                }
            }
            msg = SUCCESS;
        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "delete permission failed";
        }

        operationLogInfo = operationLogInfo.substring(0,operationLogInfo.length()-1)+"】,操作结果【"+msg+"】";
        result.put("msg",msg);
        result.put("operationLog",operationLogInfo);
        return result.toString();
    }


    /**
     * 权限列表
     *
     * @return
     */
    @ArchivesLog(operationType = "permissionList", operationName = "权限列表")
    @RequestMapping(value = "/permissionList")
    String permissionList() {
        return "permission/list";
    }

    /**
     * 查询权限信息
     *
     * @param page
     * @param size
     * @return
     */
    @ArchivesLog(operationType = "permissions", operationName = "查询权限信息")
    @RequestMapping(value = "/permissions")
    @ResponseBody
    String permisssions(@RequestParam(value = "pageIndex", defaultValue = "1") Integer page,
                        @RequestParam(value = "pageSize", defaultValue = "10") Integer size) {

        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询权限列表操作";

        page = page - 1;
        Sort sort = new Sort(Sort.Direction.DESC, "id");
        Pageable pageable = new PageRequest(page, size, sort);
        List<Permission> permissions = permissionRepository.findAll(pageable);

        result.put("msg", SUCCESS);
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(permissions).toString());
        return result.toString();
    }


    /**
     * 角色列表
     *
     * @return
     */
    @ArchivesLog(operationType = "roleList", operationName = "角色列表")
    @RequestMapping(value = "/roleList")
    String roleList() {
        return "role/list";
    }

    /**
     * 查询角色信息
     *
     * @param page
     * @param size
     * @return
     */
    @ArchivesLog(operationType = "roles", operationName = "查询角色信息")
    @RequestMapping(value = "/roles")
    @ResponseBody
    String roles(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                 @RequestParam(value = "pageSize", defaultValue = "10") Integer size) {

        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询角色列表操作";

        page = page - 1;
        Sort sort = new Sort(Sort.Direction.DESC, "id");
        Pageable pageable = new PageRequest(page, size, sort);
        List<Role> roles = roleRepository.findAll(pageable);

        result.put("msg", SUCCESS);
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(roles).toString());
        return result.toString();
    }

    /**
     * 查询用户角色
     *
     * @param id
     * @return
     */
    @ArchivesLog(operationType = "findRoleByUserId", operationName = "查询用户角色")
    @RequestMapping(value = "/findRoleByUserId")
    @ResponseBody
    String findRoleByUserId(Long id) {

        User queryUser = userRepository.findOne(id);
        operationLogInfo = "用户【" + getUser().getUsername() + "】查询【" + queryUser.getUsername() + "】拥有角色";

        List<Object> roles = userRepository.findRoleByUserId(id);

        result.put("msg", SUCCESS);
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(roles).toString());
        return result.toString();

    }


    /**
     * 保存用户角色
     *
     * @param userId
     * @param rids
     * @return
     */
    @ArchivesLog(operationType = "saveRoles", operationName = "保存用户角色")
    @RequestMapping(value = "/saveRoles")
    @ResponseBody
    String saveRoles(Long userId, Long[] rids) {

        User queryUser = userRepository.findOne(userId);
        operationLogInfo = "用户【" + getUser().getUsername() + "】为【" + queryUser.getUsername() + "】分配角色 【";

        try {
            User user = userRepository.findOne(userId);

            Set<Role> roles = new HashSet<>();

            for (Long rid : rids) {
                Role role = roleRepository.findOne(rid);
                operationLogInfo += role.getName() + ",";
                roles.add(role);
            }

            user.setRoles(roles);
            userRepository.save(user);
            msg = SUCCESS;
        } catch (Exception e) {
            msg = "exception";
        }

        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果 【" + msg + "】";

        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();

    }


    /**
     * 查询角色权限
     *
     * @param rid
     * @return
     */
    @ArchivesLog(operationType = "findPermissionByRoleId", operationName = "查询角色权限")
    @RequestMapping(value = "/findPermissionByRoleId")
    @ResponseBody
    String findPermissionByRoleId(String rid) {

        List<Object> permissions = permissionRepository.findPermissionByRoleId(rid);

        return JSONArray.fromObject(permissions).toString();

    }


    /**
     * 保存角色权限
     *
     * @param roleId
     * @param pids
     * @return
     */
    @ArchivesLog(operationType = "savePermissions", operationName = "保存角色权限")
    @RequestMapping(value = "/savePermissions")
    @ResponseBody
    String savePermissions(Long roleId, Long[] pids) {


        try {
            Role role = roleRepository.findOne(roleId);

            operationLogInfo = "用户【" + getUser().getUsername() + "】为角色【" + role.getName() + "】分配权限 【";


            Set<Permission> permissions = new HashSet<>();

            for (Long pid : pids) {
                Permission permission = permissionRepository.findOne(pid);
                permissions.add(permission);
                operationLogInfo += permission.getName()+",";
            }

            role.setPermissions(permissions);
            roleRepository.save(role);

            msg = SUCCESS;

        } catch (Exception e) {
            msg = "Exception";
        }

        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果 【" + msg + "】";

        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();

    }


    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }
}
