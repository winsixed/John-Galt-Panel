module.exports = {
  apps: [
    {
      name: 'john-galt-frontend',
      cwd: './frontend',
      script: 'npm',
      args: 'start',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/pm2-error.log',
      out_file: './logs/pm2-out.log',
      pid_file: './logs/pm2.pid',
      combine_logs: true,
      log_date_format: 'YYYY-MM-DD HH:mm Z',
      autorestart: true,
      restart_delay: 5000,
      max_restarts: 10
    },
    {
      name: 'john-galt-backend',
      cwd: './backend',
      script: 'uvicorn',
      args: 'fastapi_app.main:app --host 0.0.0.0 --port 8000',
      env: {
        PYTHONUNBUFFERED: '1'
      },
      error_file: './logs/backend-error.log',
      out_file: './logs/backend-out.log',
      pid_file: './logs/backend.pid',
      combine_logs: true,
      log_date_format: 'YYYY-MM-DD HH:mm Z',
      autorestart: true,
      restart_delay: 5000,
      max_restarts: 10,
      healthcheck: {
        url: 'http://localhost:8000/health',
        interval: 30000,
        timeout: 5000
      }
    }
  ]
};
