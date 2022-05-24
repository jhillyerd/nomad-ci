plugin "docker" {
  config {
    gc {
      # Don't delete images.
      image       = false
      image_delay = "3m"
    }
  }
}
