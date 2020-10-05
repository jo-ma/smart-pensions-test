from fastapi.testclient import TestClient
from fastapi.encoders import jsonable_encoder

from app import app
from models import Reason

client = TestClient(app)


content = 'This is a test reason'


def test_get_ready():
    """Tests response to ready endpoint"""
    response = client.get('/ready')
    assert response.status_code == 200


def test_get_empty():
    """Tests response when no reasons available"""
    response = client.get('/reason')
    assert response.status_code == 404


def test_get_reason():
    """Tests getting a reason by id"""
    post_response = post_helper()
    if post_response == 200:
        response_id = post_response.json()['id']
        get_response = client.get(f'/reason/{response_id}')
        if get_response.status_code == 200:
            assert get_response.json()['reason'] == content


def test_get_reason_not_exists():
    """Tests getting a response that does not exist by id"""
    reason_id = '4d500f4e-0424-41de-9314-8daae0903757'
    get_response = client.get(f'reason/{reason_id}')
    assert get_response.status_code == 404


def test_get_reason_bad_request():
    """Tests getting a response with an invalid UUID"""
    reason_id = 'Invalid UUID'
    get_response = client.get(f'/reason/{reason_id}')
    assert get_response.status_code == 400


def test_get_all_reasons():
    """Tests getting all reasons"""
    post_response = post_helper()
    if post_response.status_code == 200:
        get_response = client.get('/reason')
        assert get_response.status_code == 200


def test_post_reason():
    """Tests creating a new reason"""
    post_response = post_helper()
    assert post_response.status_code == 200
    assert post_response.json()['reason'] == content


def post_helper():
    """Helper function to create a reason via a POST request"""
    return client.post('/reason', json={'reason': content})
