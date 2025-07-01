# John Galt Panel

Administrative panel for a hookah bar built with **Next.js** and **FastAPI**.

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

## Scripts
- `panel.sh` – interactive DevOps panel
- `deploy-full.sh` – build and deploy frontend
- `rollback.sh` – restore from backup

## Useful Pages
- API docs: `http://localhost:8000/docs`
- Sign In: `/signin`
- Profile: `/profile`

Environment variables are documented in `.env.example`.
