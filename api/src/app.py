import db
from models import Reason
from fastapi import FastAPI, HTTPException
import uuid

app = FastAPI()

db.create_reasons_table()


@app.get('/ready', status_code=200)
def get_ready():
    """Handles get request for the /ready endpoint

    Returns a status code 200 to indicate the service is available and ready.
    """


@app.get('/reason')
def get_reasons():
    """Handles GET request for the /reason endpoint.

    Raises a 404 HTTP Exception if there are no reasons.

    Returns a list of reasons as JSON object.
    """
    reasons = db.get_reasons()
    if len(reasons) < 1:
        raise HTTPException(status_code=404)
    return reasons


@app.get('/reason/{reason_id}')
def get_reason(reason_id: str):
    """Handles GET request for the /reason/id endpoint.

    Raises a 400 HTTP Exception if the id provided is not a valid UUID.
    Raises a 404 HTTP Exception if there is not reason with the provided id.

    Returns a reason as JSON object.
    """
    if not is_valid_uuid(reason_id):
        raise HTTPException(status_code=400)

    reasons = {}
    reason = reasons.get(reason_id)

    if not reason:
        raise HTTPException(status_code=404)

    return reason


@app.post('/reason')
def post_reason(reason: Reason):
    """Handles POST request for the /reason endpoint.

    Creates a UUID id for the new reason.

    Returns the new reason as a JSON object.
    """
    reason.id = str(uuid.uuid4())

    result = db.insert_reason(reason)

    return result


def is_valid_uuid(check_str):
    """Checks if a string is a valid UUID.

    Arguments:
    check_str -- the string to be validated.

    Returns:
    boolean to indicate if the string was a valid UUID.
    """
    try:
        _ = uuid.UUID(check_str, version=4)
    except ValueError:
        return False
    return True
