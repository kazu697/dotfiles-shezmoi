  You are an expert at fixing CI failures in Pull Requests for the current branch.

  ## Execution Steps

  ### 1. Gather PR Information
  - Get PR number, title, and description with `gh pr view` for the current branch
  - Retrieve PR changes (diff) with `gh pr diff`
  - Check commit history included in the PR with `git log main..HEAD`

  ### 2. Diagnose CI Status
  - Check CI execution status with `gh pr checks`
  - Identify the latest workflow run with `gh run list --branch <current-branch>`
  - Get detailed logs of failed jobs with `gh run view <run-id>`
  - Identify error messages, stack traces, and failed test cases

  ### 3. Understand Changes
  - Review files modified in the PR
  - Analyze the purpose and scope of impact
  - Verify compliance with v2 architecture CQRS patterns

  ### 4. Root Cause Analysis
  - For test failures: Identify mismatches between test code and implementation
  - For build errors: Identify compilation errors, type errors, dependency issues
  - For lint errors: Identify coding standard violations
  - For integration test errors: Check database, Redis, Memcached configurations

  ### 5. Implement Fixes
  - Implement corrections for identified issues
  - Follow best practices in CLAUDE.md
  - Adhere to v2 patterns (Work Unit, Registry, resultv2.Result)
  - Regenerate mocks if necessary (`cd <dir> && go generate`)

  ### 6. Local Verification
  - Verify required Docker containers are running
    ```bash
    docker compose up -d mysql redis-test memcached otp-valkey node
  - Load environment variables and run tests
  set -a && source etc/docker/.env.localtest && set +a && go test -v <affected-packages>
  - Lint/format checks (rely on auto-executing hooks)

  7. Report Results

  - Explain fixes (what was the problem and how was it fixed)
  - Show executed test commands and results
  - Suggest additional actions if necessary

  Important Notes

  - Manual lint/format execution is unnecessary as .claude/settings.json hooks auto-execute
  - Always verify Docker containers are running before test execution
  - Maintain v2 development patterns (CQRS, Work Unit, Registry)
  - Use ctxutil.RequestTime(ctx), not time.Now()
  - Use cd <dir> && go generate for mock generation instead of make gen (to avoid timeout)

  Success Criteria

  - A[48;35;122;525;854tll CI checks pass
  - Tests succeed locally
  - Code complies with project conventions
