from fastapi import status
from fastapi.testclient import TestClient
from fastapi_app.main import app

client = TestClient(app)

def test_register_and_login():
    response = client.post('/auth/register', json={'email': 'user@example.com', 'password': 'secret', 'role': 'admin'})
    assert response.status_code == status.HTTP_201_CREATED
    token_res = client.post('/auth/login', data={'username': 'user@example.com', 'password': 'secret'})
    assert token_res.status_code == status.HTTP_200_OK
    token = token_res.json()['access_token']
    me = client.get('/auth/me', headers={'Authorization': f'Bearer {token}'})
    assert me.status_code == status.HTTP_200_OK
    assert me.json()['email'] == 'user@example.com'
