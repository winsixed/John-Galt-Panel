from fastapi import status
from fastapi.testclient import TestClient
from fastapi_app.main import app

client = TestClient(app)

def test_register_and_login():
    response = client.post('/api/auth/register', json={'username': 'testuser', 'password': 'secret', 'role': 'admin'})
    assert response.status_code == status.HTTP_201_CREATED
    token_res = client.post('/api/auth/login', data={'username': 'testuser', 'password': 'secret'})
    assert token_res.status_code == status.HTTP_200_OK
    token = token_res.json()['access_token']
    me = client.get('/api/auth/me', headers={'Authorization': f'Bearer {token}'})
    assert me.status_code == status.HTTP_200_OK
    assert me.json()['username'] == 'testuser'
    assert me.json()['role'] == 'admin'
