# Security Rules

- Never hardcode secrets, API keys, tokens, or passwords
- Use environment variables for all sensitive configuration
- Validate and sanitize all user input
- Use parameterized queries for database operations
- Escape output to prevent XSS
- Set appropriate CORS headers
- Use HTTPS for all external API calls
- Never log sensitive data (passwords, tokens, PII)
