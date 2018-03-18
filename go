#!/usr/bin/env bash

set -euo pipefail

stack build && ./examples/compile && ./examples/run
