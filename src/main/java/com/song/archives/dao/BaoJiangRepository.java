package com.song.archives.dao;

import com.song.archives.model.BaoJiangEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface BaoJiangRepository extends CrudRepository<BaoJiangEntity,Long> {

    List<BaoJiangEntity> findAll(Specification specification, Pageable pageable);

}
