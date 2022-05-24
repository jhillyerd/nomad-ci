job "ci-dispatch" {
  datacenters = ["skynet"]
  type = "batch"

  parameterized {
    meta_required = ["repository_url"]
    payload = "required"
  }

  meta {
    repository_url = "unspecified"
    repo_name = "repo-root"
  }

  group "ci-test" {
    count = 1

    task "ci-test" {
      driver = "docker"

      config {
        image = "golang:1.18"

        command = "/bin/bash"
        args = ["${NOMAD_TASK_DIR}/control-script.bash"]
      }

      dispatch_payload {
        file = "ci-script.bash"
      }

      resources {
        cpu = 4000 # MHz
        memory = 1024 # MB
      }

      template {
        destination = "local/control-script.bash"
        data = <<EOH
          repo="$NOMAD_META_repo_name"

          echo "## Checking out $NOMAD_META_repository_url"
          echo
          git clone "$NOMAD_META_repository_url" "$repo"
          if [ ! -d "$repo" ]; then
            echo "## Failed to checkout repo"
            exit 128
          fi

          echo
          echo "## Invoking CI script"
          echo
          cd "$repo"
          /bin/bash "$NOMAD_TASK_DIR/ci-script.bash"

          status=$?
          echo
          echo "## Job complete, status $status"
        EOH
      }
    }

    restart {
      attempts = 0
      mode = "fail"
    }
  }
}
