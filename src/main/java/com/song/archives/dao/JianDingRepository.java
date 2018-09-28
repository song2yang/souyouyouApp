package com.song.archives.dao;

import com.song.archives.model.JianDingEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface JianDingRepository extends CrudRepository<JianDingEntity,Long> {

    List<JianDingEntity> findAll(Specification specification, Pageable pageable);
}
