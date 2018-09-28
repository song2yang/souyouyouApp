package com.song.archives.dao;

import com.song.archives.model.ExpertInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Created by souyouyou on 2018/3/12.
 */
public interface ExpertRepository extends CrudRepository<ExpertInfoEntity,Long> {

    Page<ExpertInfoEntity> findAll(Specification<ExpertInfoEntity> specification, Pageable pageable);

    List<ExpertInfoEntity> findAll(Specification<ExpertInfoEntity> specification);

}
