#!/usr/bin/env python3
"""
Captain's Log
"""
import sys
import os
import stat
import config
from datetime import datetime
from typing import TextIO


# The program's name, used in error messages.
PROGRAM_NAME = "cl"


class formatting:
    """
    A collection of useful text formatting options.
    """
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    DARKCYAN = '\033[36m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'


def is_stdin_pipe() -> bool:
    """
    Returns if stdin is reading from a pipe.
    """
    return stat.S_ISFIFO(os.fstat(sys.stdin.fileno()).st_mode)


def log(file: TextIO, message: str) -> None:
    """
    Log a message to the file.
    """
    file.writelines("({}) {}\n".format(
        datetime.now().replace(microsecond=0).isoformat(),
        message
    ))


def main() -> None:
    # Read in the following order:
    # 1. Command-line arguments.
    # 2. Piped data.
    if len(sys.argv) > 1:
        message = " ".join(sys.argv[1:])
    elif is_stdin_pipe():
        message = "\n".join(sys.stdin.readlines()).strip()
    else:
        print(f"Usage:", file=sys.stderr)
        print( f"\t$ {formatting.BOLD}{formatting.RED}{PROGRAM_NAME}{formatting.END} {formatting.GREEN}'Hello, world!'{formatting.END}", file=sys.stderr)
        print( f"\t$ {formatting.RED}echo{formatting.END} {formatting.GREEN}'Hello, world!'{formatting.END} | {formatting.BOLD}{formatting.RED}{PROGRAM_NAME}{formatting.END}", file=sys.stderr)
        exit(1)

    # Write to the log.
    with open(config.log_file, "a") as log_file:
        log(log_file, message)


if __name__ == "__main__":
    main()
