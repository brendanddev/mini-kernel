package com.slabbedcomics.inventory.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.slabbedcomics.inventory.model.Comic;
import com.slabbedcomics.inventory.repository.ComicRepository;

@RestController
@RequestMapping("/api/comics")
public class ComicController {

    private final ComicRepository comicRepository;

    public ComicController(ComicRepository comicRepository) {
        this.comicRepository = comicRepository;
    }

    @GetMapping
    public List<Comic> getAllComics() {
        return comicRepository.findAll();
    }

    @PostMapping
    public Comic addComic(@RequestBody Comic comic) {
        return comicRepository.save(comic);
    }

    @PutMapping("/{id}")
    public Comic updateComic(@PathVariable Long id, @RequestBody Comic updatedComic) {
        return comicRepository.findById(id)
                .map(comic -> {
                    comic.setStatus(updatedComic.getStatus());
                    comic.setSalePrice(updatedComic.getSalePrice());
                    comic.setQuantity(updatedComic.getQuantity());
                    comic.setNotes(updatedComic.getNotes());
                    return comicRepository.save(comic);
                })
                .orElseThrow(() -> new RuntimeException("Comic not found"));
    }

    @DeleteMapping("/{id}")
    public void deleteComic(@PathVariable Long id) {
        comicRepository.deleteById(id);
    }
    
}
