"""DuckDB connection helper for Cancer_Data_Commons.

Provides a simple `connect()` function that opens the project's
`database/cancer_commons.duckdb` file by default.
"""
from pathlib import Path
import duckdb

DEFAULT_DB = Path(__file__).resolve().parents[1] / "database" / "cancer_commons.duckdb"

def connect(db_path: str | Path | None = None, read_only: bool = False):
    """Return a DuckDB connection.

    Args:
        db_path: optional path to DuckDB file. If omitted, uses the project's
            `database/cancer_commons.duckdb` file.
        read_only: open the DB in read-only mode if supported.

    Returns:
        duckdb.DuckDBPyConnection
    """
    path = Path(db_path) if db_path else DEFAULT_DB
    return duckdb.connect(database=str(path), read_only=read_only)


if __name__ == "__main__":
    conn = connect()
    print("Connected to DuckDB at:", str(path))
