package com.song.archives.dao;

import com.song.archives.model.Message;
import org.springframework.data.repository.CrudRepository;

/**
 * Created by souyouyou on 2018/3/19.
 */
public interface MessageRepository extends CrudRepository<Message,Long> {
}
