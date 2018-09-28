package com.song.archives.dao;

import com.song.archives.model.HuoJiangEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface HuoJiangRepository extends CrudRepository<HuoJiangEntity,Long> {

    List<HuoJiangEntity> findAll(Specification specification, Pageable pageable);

}
