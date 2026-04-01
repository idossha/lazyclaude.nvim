# Testing Conventions

- Unit tests go next to the source file: `foo.ts` -> `foo.test.ts`
- Integration tests in `tests/integration/`
- E2E tests in `tests/e2e/` using Playwright
- Mock external APIs with msw (Mock Service Worker)
- Never mock the database — use a test database with Prisma migrations
- Minimum 80% coverage for new code
