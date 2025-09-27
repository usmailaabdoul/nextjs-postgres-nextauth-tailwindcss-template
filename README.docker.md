# Docker Setup for Next.js Admin Dashboard

This guide will help you run the Next.js Admin Dashboard using Docker containers with PostgreSQL.

## Prerequisites

- Docker and Docker Compose installed on your system
- Git (to clone the repository)

## Quick Start

1. **Clone the repository** (if not already done):
   ```bash
   git clone <your-repository-url>
   cd nextjs-postgres-nextauth-tailwindcss-template
   ```

2. **Start the application**:
   ```bash
   docker-compose up --build
   ```

   This command will:
   - Build the Next.js application Docker image
   - Start a PostgreSQL database container
   - Create the database schema (status enum and products table)
   - Start the Next.js application container
   - Automatically seed the database with sample products via API call
   - Set up all necessary environment variables

3. **Access the application**:
   - Application: http://localhost:3000
   - Database: localhost:5433 (if you need direct access)

   The database will be automatically seeded with sample products during startup.

## What's Included

### Services
- **PostgreSQL Database**: 
  - Database: `nextauth-template`
  - User: `postgres`
  - Password: `postgres`
  - Port: `5433` (mapped to avoid conflicts with local PostgreSQL)

- **Next.js Application**:
  - Port: `3000`
  - Connected to PostgreSQL container

- **Database Seeder**:
  - Automatically runs after app startup
  - Calls `/api/seed` endpoint to populate database
  - Uses the Next.js API for data insertion

### Database Schema
The PostgreSQL container automatically creates:
- `status` enum type with values: `active`, `inactive`, `archived`
- `products` table with columns:
  - `id` (SERIAL PRIMARY KEY)
  - `image_url` (TEXT)
  - `name` (TEXT)
  - `status` (status enum)
  - `price` (NUMERIC)
  - `stock` (INTEGER)
  - `available_at` (TIMESTAMP)

### Environment Variables
Pre-configured environment variables:
- `POSTGRES_URL`: Connection string to PostgreSQL container
- `NEXTAUTH_URL`: Set to http://localhost:3000
- `AUTH_SECRET`: Pre-configured secret (change for production)
- `AUTH_TRUST_HOST`: Set to true for Docker environment

## Commands

### Start containers (detached mode)
```bash
docker-compose up -d
```

### Stop containers
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f app
docker-compose logs -f postgres
```

### Rebuild and restart
```bash
docker-compose down
docker-compose up --build
```

### Reset database (remove all data)
```bash
docker-compose down -v
docker-compose up --build
```

## Development

### Making Code Changes
1. Make your changes to the source code
2. Rebuild the container:
   ```bash
   docker-compose up --build app
   ```

### Database Access
To connect to the PostgreSQL database directly:
```bash
docker-compose exec postgres psql -U postgres -d nextauth-template
```

Or from your host machine:
```bash
psql -h localhost -p 5433 -U postgres -d nextauth-template
```

### Troubleshooting

#### Container Issues
- Check container status: `docker-compose ps`
- View logs: `docker-compose logs [service-name]`
- Restart specific service: `docker-compose restart [service-name]`

#### Database Connection Issues
- Ensure PostgreSQL container is healthy: `docker-compose ps postgres`
- Check database logs: `docker-compose logs postgres`
- Verify connection string in app logs: `docker-compose logs app`

#### Port Conflicts
If ports 3000 or 5433 are already in use:
1. Stop conflicting services
2. Or modify ports in `docker-compose.yml`:
   ```yaml
   # For the app
   ports:
     - "3001:3000"  # Change host port to 3001
   
   # For PostgreSQL  
   ports:
     - "5434:5432"  # Change host port to 5434
   ```

Note: PostgreSQL is mapped to port 5433 by default to avoid conflicts with local PostgreSQL installations running on 5432.

## Production Notes

For production deployment:
1. Change the `AUTH_SECRET` to a secure random string
2. Use environment-specific configurations
3. Consider using Docker secrets for sensitive data
4. Set up proper volume backups for PostgreSQL data
5. Configure proper networking and security groups

## File Structure

```
├── Dockerfile                 # Next.js app container
├── docker-compose.yml         # Multi-container setup
├── docker/
│   └── init-db.sql           # Database initialization
├── .env.docker               # Environment variables template
└── README.docker.md          # This documentation
```