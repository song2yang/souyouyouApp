package com.song.archives.dao;

import com.song.archives.model.ExpertInfoEntity;
import com.song.archives.model.MsgGroupEntity;
import com.song.archives.model.MsgInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;


/**
 * Created by souyouyou on 2018/3/12.
 */
public interface MsgGroupRepository extends CrudRepository<MsgGroupEntity,Long>{

    Page<MsgGroupEntity> findAll(Specification<MsgGroupEntity> specification, Pageable pageable);

}
