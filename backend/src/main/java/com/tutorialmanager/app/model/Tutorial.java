package com.tutorialmanager.app.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tutorials")
public class Tutorial {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  private long id;

  @Column(name = "title", nullable = false)
  private String title;

  @Column(name = "description", length = 1000)
  private String description;

  @Column(name = "category")
  private String category;

  @Column(name = "author")
  private String author;

  @Column(name = "difficulty_level")
  private String difficultyLevel; // Beginner, Intermediate, Advanced

  @Column(name = "duration_minutes")
  private Integer durationMinutes;

  @Column(name = "published")
  private boolean published;

  @Column(name = "featured")
  private boolean featured;

  @Column(name = "image_url")
  private String imageUrl;

  @Column(name = "video_url")
  private String videoUrl;

  @Column(name = "created_at")
  private LocalDateTime createdAt;

  @Column(name = "updated_at")
  private LocalDateTime updatedAt;

  public Tutorial() {
    this.createdAt = LocalDateTime.now();
    this.updatedAt = LocalDateTime.now();
  }

  public Tutorial(String title, String description, boolean published) {
    this();
    this.title = title;
    this.description = description;
    this.published = published;
  }
  
  public Tutorial(long id, String title, String description, boolean published) {
    this();
    this.id = id;
    this.title = title;
    this.description = description;
    this.published = published;
  }

  @PreUpdate
  public void preUpdate() {
    this.updatedAt = LocalDateTime.now();
  }

  // Getters and Setters
  public long getId() {
    return id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getCategory() {
    return category;
  }

  public void setCategory(String category) {
    this.category = category;
  }

  public String getAuthor() {
    return author;
  }

  public void setAuthor(String author) {
    this.author = author;
  }

  public String getDifficultyLevel() {
    return difficultyLevel;
  }

  public void setDifficultyLevel(String difficultyLevel) {
    this.difficultyLevel = difficultyLevel;
  }

  public Integer getDurationMinutes() {
    return durationMinutes;
  }

  public void setDurationMinutes(Integer durationMinutes) {
    this.durationMinutes = durationMinutes;
  }

  public boolean isPublished() {
    return published;
  }

  public void setPublished(boolean published) {
    this.published = published;
  }

  public boolean isFeatured() {
    return featured;
  }

  public void setFeatured(boolean featured) {
    this.featured = featured;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  public String getVideoUrl() {
    return videoUrl;
  }

  public void setVideoUrl(String videoUrl) {
    this.videoUrl = videoUrl;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  @Override
  public String toString() {
    return "Tutorial [id=" + id + ", title=" + title + ", description=" + description + 
           ", category=" + category + ", author=" + author + ", published=" + published + 
           ", featured=" + featured + "]";
  }
}
