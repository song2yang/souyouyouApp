package com.song.archives.dao;

import com.song.archives.model.ProjectInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * Created by ghl on 2018/2/26.
 */
public interface ProjectRepository extends CrudRepository<ProjectInfoEntity, Long> {

    List<ProjectInfoEntity> findById(int id);
    Page<ProjectInfoEntity> findAll(Pageable pageable);
    List<ProjectInfoEntity> findAll(Specification specification);
    Page<ProjectInfoEntity> findAll(Specification specification,Pageable pageable);
    long count();
}
