# Security Rules

- Never commit secrets, API keys, or credentials
- All user input must be validated with zod schemas
- Use parameterized queries (Prisma handles this)
- JWT tokens expire after 24 hours
- CORS restricted to known origins in production
- Rate limiting on all public API endpoints
