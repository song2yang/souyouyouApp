package com.song.archives.dao;

import com.song.archives.model.CuishouLogEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


/**
 * Created by ghl on 2018/3/13.
 */
public interface CuishouLogRepository extends CrudRepository<CuishouLogEntity,Long> {

    List<CuishouLogEntity> findAll(Pageable pageable);

    List<CuishouLogEntity> findAll(Specification specification, Pageable pageable);

    List<CuishouLogEntity> findAllByJingbanrenIdEquals(String userid);

    @Transactional
    void deleteByProidEquals(Long proid);
}