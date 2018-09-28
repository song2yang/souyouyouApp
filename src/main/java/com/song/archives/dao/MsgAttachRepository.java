package com.song.archives.dao;

import com.song.archives.model.MessageAttach;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Created by souyouyou on 2018/3/19.
 */
public interface MsgAttachRepository extends CrudRepository<MessageAttach,Long> {
    List<MessageAttach> findByMsgId(Long msgId);
}
