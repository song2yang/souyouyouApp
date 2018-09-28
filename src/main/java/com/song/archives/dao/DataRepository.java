package com.song.archives.dao;

import com.song.archives.model.ZiliaoInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


/**
 * Created by souyouyou on 2018/2/28.
 */
public interface DataRepository extends CrudRepository<ZiliaoInfoEntity,Long> {


    Page<ZiliaoInfoEntity> findAll(Specification<ZiliaoInfoEntity> specification, Pageable pageable);

    List<ZiliaoInfoEntity> findAll(Specification<ZiliaoInfoEntity> specification);

    long count();

}
