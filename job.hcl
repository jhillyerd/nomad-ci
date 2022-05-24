job "ci-dispatch" {
  datacenters = ["skynet"]
  type = "batch"

  parameterized {
    payload = "required"
  }

  group "ci-test" {
    count = 1

    task "ci-test" {
      driver = "docker"

      config {
        image = "golang:1.18"
        volumes = [ "local:/job" ]

        command = "/bin/bash"
        args = ["/job/local/ci-script.bash"]
      }

      dispatch_payload {
        file = "local/ci-script.bash"
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
