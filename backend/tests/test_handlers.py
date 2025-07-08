from fastapi import status
from fastapi.testclient import TestClient


def test_server_error_handler(client: TestClient):
    resp = client.get('/api/health/error')
    assert resp.status_code == status.HTTP_500_INTERNAL_SERVER_ERROR
    assert resp.json()['detail'] == 'Internal Server Error'
