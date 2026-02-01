---
name: tdd-workflow
description: Implements using TDD (Test-Driven Development). Development proceeds according to the Red-Green-Refactor cycle.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write, TodoWrite
---

# TDD Workflow

## Overview

Following the principles of Test-Driven Development (TDD), development proceeds through the following cycle:

1. **Red Phase**: Write a failing test.
2. **Run Tests**: Confirm the test fails.
3. **Green Phase**: Implement the minimum code required to make the test pass.
4. **Confirm Test Success**: Confirm the test passes.
5. **Refactor**: Organize and improve the code.

## Key Principles

### 1. Planning Confirmation with Todo

- Always create a task plan using the TodoWrite tool before implementation.
- Start implementation only after receiving user confirmation.
- Update the Todo status for each phase.

### 2. Test Creation Rules

- Write tests that confirm small behaviors first.
- Test data should be written within the test function (do not use fixtures).
- Fixtures are only allowed for data unrelated to assertions.

### 3. Mock Usage Restrictions

- Avoid using mocks as much as possible.
- Mocks are only allowed when there are external dependencies such as API calls or DB calls.

### 4. Comment Rules

- Write WHY (why this implementation).
- WHAT only when it affects code readability, such as spanning multiple lines.
- Avoid unnecessary comments.

## Test Execution Commands

Use the appropriate test command depending on the project type:

### Go

```bash
go test ./... -v
```

### Node.js

```bash
npm test
```

## TDD Cycle Implementation Steps

### Red Phase (Write a Test)

1. Identify a small behavior of the feature to be implemented.
2. Write a test that validates that behavior.
3. Run the test and confirm it fails.
4. Confirm the failure reason is as expected.

### Green Phase (Implement)

1. Implement the minimum code required to make the test pass.
2. Avoid over-design or over-abstraction.
3. Run the test and confirm it passes.

### Refactoring Phase

1. Start with all tests passing.
2. Remove code duplication.
3. Improve readability.
4. Run tests after each change to confirm functionality.
5. Do not consider excessive abstraction or future extensibility.

## Slash Commands

If you want to execute each phase individually, use the following commands:

- `/tdd:red` - Red Phase: Write a failing test.
- `/tdd:green` - Green Phase: Implement to make the test pass.
- `/tdd:refactor` - Refactoring: Organize the code.

## Implementation Notes

- Pay attention to security vulnerabilities (XSS, SQL injection, etc.).
- Do not hardcode passwords or API keys.
- Do not delete data without user confirmation.
- Avoid excessive error handling or validation (only at system boundaries).
- Completely delete unused code (no backward compatibility hacks needed).
