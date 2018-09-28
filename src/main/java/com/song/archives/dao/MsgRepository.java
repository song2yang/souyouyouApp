package com.song.archives.dao;

import com.song.archives.model.MsgInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


/**
 * Created by souyouyou on 2018/3/12.
 */
public interface MsgRepository extends CrudRepository<MsgInfoEntity,Long>{

    Page<MsgInfoEntity> findAll(Pageable pageable);


    List<MsgInfoEntity> findByGroupId(Long groupId);

}
