job "ci-test-batch" {
  datacenters = ["skynet"]
  type = "batch"

  group "ci-test" {
    count = 1

    task "ci-test" {
      driver = "docker"

      config {
        image = "golang:1.18"
        command = "/bin/echo"
        args = ["hello", "world"]
      }

      resources {
        cpu = 4000 # MHz
        memory = 1024 # MB
      }
    }

    restart {
      attempts = 0
      mode = "fail"
    }
  }
}
