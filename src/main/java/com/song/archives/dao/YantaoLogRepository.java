package com.song.archives.dao;

import com.song.archives.model.YantaoLogEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by ghl on 2018/3/21.
 */
public interface YantaoLogRepository extends CrudRepository<YantaoLogEntity,Long> {

    List<YantaoLogEntity> findAll(Pageable pageable);

    List<YantaoLogEntity> findAll(Specification specification,Pageable pageable);

    @Transactional
    void deleteByProIdEquals(Long proid);
}

