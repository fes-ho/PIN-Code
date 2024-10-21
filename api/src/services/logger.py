import logging
from logging.handlers import MemoryHandler

format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

file_handler = logging.FileHandler("apiErrors.log")
file_handler.setFormatter(logging.Formatter(format))
file_handler.setLevel(logging.DEBUG)

# This is needed in order to only log into the file when an error occurs
memory_handler = MemoryHandler(capacity=10000000, target=file_handler, flushLevel=logging.ERROR)
memory_handler.setLevel(logging.DEBUG)

# Configure the logger
logging.basicConfig(
    level=logging.DEBUG,
    format=format,
    handlers=[
        memory_handler,
        logging.StreamHandler()
    ]
)

# Create a logger instance
logger = logging.getLogger('apiLogger')