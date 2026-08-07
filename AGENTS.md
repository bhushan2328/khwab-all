# Khwab Development Instructions

## General Rules

1. Before modifying code, inspect the existing implementation and understand how the relevant code currently works.
2. Never invent class names, functions, constructors, packages, APIs, or file paths when an existing implementation should be inspected first.
3. Preserve existing architecture unless the task explicitly requires an architectural change.
4. Prefer the smallest safe change that solves the requested problem.
5. Do not remove working functionality just to simplify an implementation.
6. When a change affects multiple files, inspect all relevant files before editing.
7. After making changes, verify the affected code and run the appropriate build/test checks.
8. Never claim a task is complete without verifying the result when verification is possible.

## Repository Architecture

Khwab consists of separate architectural responsibilities:

- `app` — Android application layer.
- `khwab-core` — platform-independent intelligence/core.
- `khwab-integration` — communication boundary between the Android app and Khwab Core.

### Architecture Boundary

The Android application must communicate with Khwab Core through `khwab-integration`.

The Android app must not directly depend on internal Khwab Core implementation details.

`khwab-core` must remain platform-independent and must not depend on Android APIs.

Do not bypass the integration layer merely to make an implementation easier.

## Khwab Core

Treat Khwab Core as the platform-independent intelligence layer.

Do not introduce Android-specific classes, imports, Context, Activity, Service, Compose, or other Android framework dependencies into Khwab Core.

Before changing Core behavior, inspect the existing pipeline and related classes to understand the current flow.

## Integration Layer

`khwab-integration` is the communication layer between the Android application and Khwab Core.

Keep this layer focused on communication, translation, and boundary responsibilities.

Do not move Core intelligence into the integration layer.

Do not make the Android app aware of internal Core implementation details.

## Android App

The Android app owns Android-specific responsibilities such as:

- Android lifecycle
- UI
- Services
- Accessibility
- Overlay/window functionality
- Audio and speech integration
- Android permissions
- Android execution of actions
- Android