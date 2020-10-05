import mysql.connector
import os
from models import Reason

connection = mysql.connector.connect(
    user=os.environ['DB_USER'],
    password=os.environ['DB_PASSWORD'],
    host=os.environ['DB_HOST'],
    database=os.environ['DB'])

cursor = connection.cursor()

create_reasons_table_stmt = """
    CREATE TABLE IF NOT EXISTS reasons(
    reason_id varchar(36) NOT NULL,
    reason varchar(1000),
    PRIMARY KEY (reason_id)
)
"""


def create_reasons_table():
    """Handles creation of the reasons schema.

    Prints the result to stdout.
    """
    try:
        cursor.execute(create_reasons_table_stmt)
    except mysql.connector.Error as err:
        print(err.msg)
    else:
        print('INFO:     Reasons table created or already exists.')


def insert_reason(reason: Reason):
    """Handles inserting a reason into the reasons table

    Arguments:
    reason -- The reason object to be inserted.

    On errors, prints error message to stdout.

    Returns:
    The reason object that was inserted.
    """
    try:
        stmt = 'INSERT INTO reasons (reason_id, reason) VALUES (%s, %s)'
        val = (reason.id, reason.reason)
        cursor.execute(stmt, val)
        connection.commit()
    except mysql.connector.Error as err:
        print(err.msg)
    else:
        return reason


def get_reasons():
    """Handles selecting all reasons from the reason table.

    On errors, prints error message to stdout.

    Returns:
    Dict of reason objects.
    """
    try:
        cursor.execute('SELECT reason_id, reason FROM reasons')
    except mysql.connector.Error as err:
        print(err.msg)

    reasons = {}

    for (reason_id, reason) in cursor:
        reasons[reason_id] = Reason(id=reason_id, reason=reason)

    return reasons
