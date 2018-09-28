package com.song.archives.dao;

import com.song.archives.model.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Created by souyouyou on 2018/2/8.
 */
public interface UserDao extends CrudRepository<User,Long>{
    /**通过username查找用户信息;*/
    User findByUsername(String username);

    /**查询全部用户*/
    List<User> findAll(Pageable pageable);
}
