package com.slabbedcomics.inventory.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.slabbedcomics.inventory.model.Comic;

@Repository
public interface ComicRepository extends JpaRepository<Comic, Long> {
}
