
package com.slabbedcomics.inventory.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

/**
 * Comic entity representing a comic book in inventory.
 */
@Entity
public class Comic {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    private String author;
    private String publisher;
    private int year;
    private int issueNumber;
    private String condition;
    private double purchasePrice;
    private double estimatedValue;
    private int quantity;
    private double salePrice;
    private String status;
    private String notes;

    public Comic() {}


}