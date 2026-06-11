# Node Backend Rules

These rules extend the baseline AGENTS.md for backend development using Node.js and TypeScript.

## 1. Type Safety & Validation

- **Input Validation**: Use structured schemas (e.g., Zod, Joi) to validate `req.body`, `req.query`, and `req.params` immediately at the controller boundaries.
- **Explicit Parameter Destructuring**: Always destructure verified parameters before business logic. Do not pass raw `req` objects deep into database or domain layers.
  ```typescript
  // Correct
  const { userId, productId } = req.body;
  await productService.buyProduct(userId, productId);
  ```

## 2. DB & Performance

- **Async APIs**: Never use synchronous blocking operations (e.g., `fs.readFileSync`). Always use the promise-based versions (`fs.promises.readFile`).
- **Query Optimization**: Prevent N+1 query patterns. Prefer bulk queries or joins over individual lookup loops.
- **Resource Management**: Properly release file handles, client connections, and database sockets in `finally` blocks.

## 3. Errors & Logging

- **Global Error Handling**: Ensure all route handlers catch errors and delegate to a centralized error middleware.
- **Do Not Swallow Exceptions**: Always log caught errors using structured logs (e.g., Pino, Winston), including stack traces, before returning a 500 status code.
- **Sensitive Data Filtering**: Ensure passwords, credit cards, and authorization headers are masked in all backend logs.
