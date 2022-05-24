job "nomad-ci" {
  datacenters = ["dc1"]
  type = "batch"

  parameterized {
    meta_required = [
      "docker_image",
      "repository_url"
    ]
    meta_optional = ["repo_name"]
    payload = "required"
  }

  meta {
    repo_name = "repo-root"
  }

  group "nomad-ci" {
    count = 1

    task "nomad-ci" {
      driver = "docker"

      config {
        image = "${NOMAD_META_docker_image}"

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
