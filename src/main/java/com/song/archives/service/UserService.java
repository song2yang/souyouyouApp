package com.song.archives.service;

import com.song.archives.model.User;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface UserService {
    /**通过username查找用户信息;*/
    public User findByUsername(String username);

    public List<User> findAll(Pageable pageable);

}