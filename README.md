# John Galt Panel
[![CI](https://github.com/owner/John-Galt-Panel/actions/workflows/main.yml/badge.svg)](https://github.com/owner/John-Galt-Panel/actions/workflows/main.yml)

Administrative panel for a hookah bar built with **FastAPI** and **Next.js**. The project consists of a Python API backend and a TypeScript React frontend packaged as a server‑side rendered (SSR) application.

## Features
- JWT authentication with role based access control
- User management endpoints and admin only operations
- Inventory dashboard and staff views
- Custom rate limiting and exception handling
- Environment variable support via `.env`
- Deployment and rollback scripts
- CI pipeline with cached dependencies and SSH deploy

## Tech Stack
- **Backend:** FastAPI, SQLAlchemy, Alembic, Pydantic
- **Frontend:** Next.js 15, React 19, Tailwind CSS
- **Database:** PostgreSQL (local SQLite for tests)
- **Testing:** Pytest and Jest
- **Deployment:** GitHub Actions, PM2, Nginx

## Role Access Matrix
| Area/Endpoint            | Admin | Staff | Viewer | Inventory Manager |
|--------------------------|:----:|:----:|:----:|:-----------------:|
| `/users/admin-only`      |  ✔   |  ✖   |  ✖   |        ✖         |
| `/users/staff`           |  ✔   |  ✔   |  ✖   |        ✖         |
| `/users/viewer`          |  ✔   |  ✔   |  ✔   |        ✔         |
| `/users/inventory`       |  ✔   |  ✖   |  ✖   |        ✔         |

## Project Structure
```
backend/      FastAPI application and tests
frontend/     Next.js dashboard with TypeScript
nginx/        Example reverse proxy configuration
panel.sh      Interactive DevOps helper script
deploy-full.sh  Build & deploy helper
rollback.sh     Rollback the latest deployment
```
Additional folders like `dumps/` store database backups and `scripts/` contains helper utilities. Environment examples are located in `backend/.env.example` and `frontend/.env.example`.

## Getting Started
### Backend
```bash
cd backend
python -m venv venv && . venv/bin/activate
pip install -r requirements.txt
uvicorn fastapi_app.main:app --reload
```
### Frontend
```bash
cd frontend
npm install
npm run dev
```

## Testing
Run backend tests with **Pytest**:
```bash
cd backend
pytest
```
Run frontend tests with **Jest**:
```bash
cd frontend
npm test
```

## Deployment
1. Ensure `deploy-full.sh` is executable and SSH secrets are configured in GitHub.
2. Pushing to `main` triggers the workflow in `.github/workflows/main.yml` which builds, tests and deploys via SSH.
3. To deploy manually:
```bash
./deploy-full.sh
```

## Rollback
If a deployment fails you can revert to the previous build with:
```bash
./rollback.sh
```
This script resets the frontend to the previous commit, restarts PM2 and reloads Nginx. It also attempts to restore the latest SQL dump found in `dumps/`.

### Database Backup & Restore
Create a compressed PostgreSQL dump:
```bash
pg_dump -U postgres -d your_dbname -F c -f dumps/db_$(date +%F_%H%M%S).dump
```
Restore it later with:
```bash
pg_restore --clean --if-exists -U postgres -d your_dbname dumps/db_YYYY-MM-DD_HHMMSS.dump
```

### Automated Backups
Use the helper script `scripts/db_backup.sh` to create timestamped dumps. Schedule it via cron, for example:
```
0 3 * * * /var/www/John_Galt_Panel/scripts/db_backup.sh >> /var/log/db_backup.log 2>&1
```
Cron templates live in the `cron/` folder.

### PM2 Startup
After deploying run:
```bash
pm2 save
pm2 startup
```
so the frontend process restarts automatically on reboot and after crashes.
