package com.song.archives.service.impl;

import com.song.archives.dao.UserDao;
import com.song.archives.model.User;
import com.song.archives.service.UserService;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by souyouyou on 2018/2/8.
 */
@Service
public class UserServiceImpl implements UserService{
    @Resource
    private UserDao userDao;

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public List<User> findAll(Pageable pageable) {
        return userDao.findAll(pageable);
    }
}
