# nomad-ci

An experiment to see whether it is feasible to build a micro-CI system using
Nomad's parameterized jobs.

## Installation

You'll need docker installed, and a nomad binary (tested w/ v1.1.12) handy.

## Usage

Launch nomad in dev mode, disabling the auto-removal of docker images:

```sh
nomad agent -dev -config=./nomad-agent-docker-config.hcl
```

View the nomad UI at http://localhost:4646/

Register the job definition, then kick off a CI run:

```sh
nomad job run nomad-ci.nomad.hcl

nomad job dispatch \
  -meta repository_url="https://github.com/jhillyerd/enmime.git" \
  -meta repo_name="enmime" \
  -meta docker_image="golang:1.18" \
  nomad-ci ./sample-ci-script.bash
```

To see the output, click on:

1. `Jobs`
2. `nomad-ci`
3. the most recent row in `Job Launches`
4. the newest `Recent Allocations`
5. the `nomad-ci` task
6. the `Logs` tab
