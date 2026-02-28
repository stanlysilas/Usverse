# Usverse — Development Source of Truth

This document defines the product vision, engineering rules, architecture decisions, and collaboration expectations for the Usverse codebase.

This file acts as the **single operational reference** for:
- developers
- AI agents (Codex / ChatGPT)
- future contributors

If implementation decisions conflict with this file, **this file wins**.

---

# 1. Product Overview

## One-line Purpose
Usverse is a shared digital space for couples to capture, experience, and grow their relationship over time.

Usverse is NOT:
- social media
- messaging app
- public sharing platform

Usverse IS:
- a private relationship operating system.

---

## Target Users
Primary:
- couples in relationships
- long-distance partners
- married/engaged users

User traits:
- emotionally intentional
- privacy focused
- low tolerance for complexity

---

## Core Problems Solved
- Memories scattered across apps
- No shared relationship context
- Communication lacks intentionality
- Milestones not visualized
- No shared long-term digital space

---

# 2. Product Philosophy

Usverse follows three emotional layers:

Memory      → permanent archive  
DailyMessage → intentional daily connection  
Feed        → casual ephemeral sharing

These systems MUST remain separate concepts.

Do not merge features unless explicitly approved.

---

# 3. Current Development Stage

Status: Early Production Prototype

Built:
- Firebase Auth (Google)
- Relationship linking
- Sidebar navigation system
- Custom UI design system
- Daily Messages (text)
- Memory timeline foundation
- Environment separation (dev/prod)
- CI/CD deployment

In Progress:
- Relationship dashboard
- Navigation unification
- Profile abstraction
- JourneyMap widget
- SharedGoals widget

---

# 4. Technical Architecture

## Core Principles
- Minimalism
- Performance-first
- Platform independence
- Reusable UI
- Predictable rebuild scope

Avoid complexity unless necessary.

---

## Flutter Architecture

Pattern used:

Service → Stream → Model → Widget

UI must NOT directly access Firestore.

Widgets consume streams from services.

---

### State Management
Current:
Local widget state + Streams

Avoid:
- Bloc
- Redux
- heavy global providers

Preferred:
Reactive services.

---

### Dependency Injection
Manual lightweight DI via services.

No DI frameworks.

---

### Routing
Navigator currently.
Future migration to go_router allowed.

---

# 5. Firebase Architecture

## Services Used
- Firebase Auth
- Firestore
- Hosting

Planned:
- Storage
- Cloud Functions
- FCM
- Crashlytics
- Remote Config

---

## Environments

dev → firebase_options_dev.dart  
prod → firebase_options_prod.dart

GitHub Actions selects environment automatically.

---

# 6. Firestore Data Model

## Collections

users/{uid}
photoUrl - String
displayName - String
relationshipId - String
createdAt - Timestamp


relationships/{id}
partnerA - String
partnerB - String
relationshipName - String
anniversaryDate - Timestamp


memories/{id}
relationshipId - String
mediaUrl - String
caption - String
createdBy - String
memoryDate - Timestamp
sortDate - Timestamp


daily_messages/{id}
relationshipId - String
message - String
createdAt - Timestamp
expiresAt - Timestamp
startAt - Timestamp


relationship_feed/{id} (planned)
type - String
content - String
mediaUrl - String
createdAt - Timestamp
expiresAt - Timestamp


---

# 7. Security Rules Philosophy

Access rule:

User may access data ONLY if:
request.auth.uid belongs to relationship.

No public reads.

Security is relationship-scoped.

---

# 8. Cloud Functions Responsibilities (Future)

- expire feed items
- cleanup media
- notifications
- derived timeline updates

Scheduled jobs allowed for:
- daily cleanup
- reminder triggers

---

# 9. UI Architecture Rules

## Design Language
- calm
- minimal
- emotionally neutral
- non-social-media aesthetic

Navigation:
Desktop → Sidebar
Mobile → Bottom Navigation

Interaction parity required.

---

## Widget Structure

Do NOT build large screens directly.

Compose:

FeatureScreen
 → Layout
 → Cards
 → Small widgets

Each widget must have clear responsibility.

---

# 10. Folder Structure

lib/

core/  
low-level utilities, environment configs, theme, crypto

features/  
feature-scoped UI + logic

shared/  
design system widgets

services/  
Firebase + external integrations

models/  
pure data models

---

# 11. Naming Conventions

Widgets:
UsverseXxx

Services:
XxxService

Models:
XxxModel

Streams:
watchXxx()

Single fetch:
getXxx()

---

# 12. Coding Standards

All generated code must follow:

- no comments inside code
- clear structure instead of explanation comments
- platform independence
- avoid unnecessary rebuilds
- prefer composition over inheritance
- animations must not cause layout overflow

---

# 13. Performance Rules

Avoid:
- nested StreamBuilders
- rebuilding large trees
- layout changes during animations
- heavy synchronous work in build()

Prefer:
- small rebuild scopes
- Animated* widgets
- streams mapped to minimal data

---

# 14. Packages

Preferred:
- flutter_svg
- cached_network_image
- hugeicons

Avoid:
- UI frameworks
- heavy state libraries

---

# 15. Definition of Done

A feature is complete only when:

- responsive layouts
- no overflow warnings
- smooth animations
- reusable widgets extracted
- Firestore rules respected
- works on web and mobile

---

# 16. CI/CD

GitHub Actions:

dev branch → dev Firebase project  
main branch → production Firebase project

Flutter web build required for deploy.

---

# 17. Testing Strategy

Current: manual testing

Planned:
- unit tests for services
- widget tests for shared UI
- integration tests for auth flows

---

# 18. Collaboration Rules (AI Agents)

AI assistants SHOULD:
- propose architectural improvements
- prevent tech debt early
- favor long-term scalability

AI assistants MUST ASK before:
- changing data models
- altering navigation paradigms
- merging product concepts

Strict review mode is default.

---

# 19. Communication Style

Responses should be:
- detailed for architecture
- precise for code
- minimal but clear
- explanation outside code only

---

# 20. Immediate Priorities

1. Complete Us dashboard architecture
2. Centralize user profile stream
3. Define relationship feed model

---

# 21. Long-Term Vision

Usverse evolves into:

A private shared life platform.

Not engagement-driven.
Not algorithmic.
Relationship-first software.

Every feature must reinforce intentional connection.

---

# 22. Building and deploying steps

1. git add .
2. git commit -m "message"
3. git push origin dev/main

Merging with the other branch

4. git checkout dev/main
5. git merge dev/main
6. git push origin dev/main

---

END OF DOCUMENT