package com.song.archives.dao;

import com.song.archives.model.ProjectPhaseEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ProjectPhaseRepository extends CrudRepository<ProjectPhaseEntity, Long> {

     List<ProjectPhaseEntity> findAll();

}
