package com.song.archives.dao;

import com.song.archives.model.Permission;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * Created by souyouyou on 2018/2/9.
 */
public interface PermissionRepository extends CrudRepository<Permission,Long> {
    List<Permission> findAll(Pageable pageable);


    @Query(value = "select up.id permissionId,up.name permissionName,ifnull(ur.id,0) marker,ifnull(ur.id,0) from permission up left join role_permission urp on urp.permission_id = up.id left join (select id from role where id =:roleId) ur on ur.id = urp.role_id group by up.id",nativeQuery = true)
//    @Query(value = "SELECT p.id permissionId, p.name permissionName, ifnull(r.id, 0) marker, ifnull(r.id, 0) roleId FROM permission p LEFT JOIN role_permission rp ON p.id = rp.permission_id LEFT JOIN (SELECT id FROM role WHERE id =:roleId) r ON r.id = rp.role_id\n",nativeQuery = true)
    List<Object> findPermissionByRoleId(@Param(value = "roleId") String roleId);
}
