import logging.config
import os

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")


def setup_logging() -> None:
    logging_config = {
        "version": 1,
        "formatters": {
            "default": {"format": "%(levelname)s:%(name)s:%(message)s"}
        },
        "handlers": {
            "stdout": {
                "class": "logging.StreamHandler",
                "formatter": "default",
            }
        },
        "root": {"handlers": ["stdout"], "level": LOG_LEVEL},
    }
    logging.config.dictConfig(logging_config)
