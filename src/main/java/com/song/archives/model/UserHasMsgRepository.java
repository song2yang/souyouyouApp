package com.song.archives.model;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


/**
 * Created by souyouyou on 2018/3/19.
 */
public interface UserHasMsgRepository extends CrudRepository<UserHasMsg,Long> {

    Page<UserHasMsg> findAll(Specification<UserHasMsg> specification, Pageable pageable);

    Page<UserHasMsg> findBySenderId(Pageable pageable,Long senderId);

    UserHasMsg findAllByMsgId(Long msgId);






}
