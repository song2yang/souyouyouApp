package com.song.archives.dao;

import com.song.archives.model.Role;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * Created by souyouyou on 2018/2/9.
 */
public interface RoleRepository extends CrudRepository<Role, Long> {
    List<Role> findAll(Pageable pageable);

    @Query(value = "select * from role where id in (select role_id from role_permission WHERE permission_id =:permissionId)",nativeQuery = true)
    List<Role> findRolesByPermissionId(@Param(value = "permissionId") Long permissionId);

}
