import logging.config
import logging.handlers
import json
import os

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")


def setup_logging() -> None:
    os.makedirs("./logs", exist_ok=True)
    class JSONFormatter(logging.Formatter):
        def format(self, record):
            log_record = {
                "time": self.formatTime(record, self.datefmt),
                "level": record.levelname,
                "name": record.name,
                "message": record.getMessage(),
            }
            return json.dumps(log_record)

    logging_config = {
        "version": 1,
        "formatters": {
            "default": {"format": "%(levelname)s:%(name)s:%(message)s"},
            "json": {"()": JSONFormatter},
        },
        "handlers": {
            "stdout": {
                "class": "logging.StreamHandler",
                "formatter": "default",
            },
            "file": {
                "class": "logging.handlers.TimedRotatingFileHandler",
                "formatter": "json",
                "filename": "./logs/app.log",
                "when": "D",
                "interval": 1,
                "backupCount": 7,
            },
        },
        "root": {"handlers": ["stdout", "file"], "level": LOG_LEVEL},
    }
    logging.config.dictConfig(logging_config)
