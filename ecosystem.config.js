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
    }
  ]
};
