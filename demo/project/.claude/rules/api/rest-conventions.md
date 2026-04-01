# REST API Conventions

- Routes: `GET /api/v1/resources`, `POST /api/v1/resources`, `PATCH /api/v1/resources/:id`
- Use HTTP status codes correctly: 200 OK, 201 Created, 400 Bad Request, 404 Not Found
- Response format: `{ data: ..., meta: { page, totalPages } }`
- Error format: `{ error: { code: "VALIDATION_ERROR", message: "...", details: [...] } }`
- Pagination: `?page=1&limit=20` (default limit 20, max 100)
