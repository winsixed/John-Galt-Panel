from fastapi import status
from fastapi.testclient import TestClient


def test_register_and_login(client: TestClient):
    response = client.post(
        '/api/auth/register',
        json={'username': 'testuser', 'password': 'secret', 'role': 'admin'},
    )
    assert response.status_code == status.HTTP_201_CREATED
    token_res = client.post(
        '/api/auth/login', json={'username': 'testuser', 'password': 'secret'}
    )
    assert token_res.status_code == status.HTTP_200_OK
    token = token_res.json()['access_token']
    me = client.get('/api/auth/me', headers={'Authorization': f'Bearer {token}'})
    assert me.status_code == status.HTTP_200_OK
    assert me.json()['username'] == 'testuser'
    assert me.json()['role'] == 'staff'


def test_cannot_register_as_admin(client: TestClient):
    res = client.post(
        '/api/auth/register',
        json={'username': 'newuser', 'password': 'pw', 'role': 'admin'},
    )
    assert res.status_code == status.HTTP_201_CREATED
    assert res.json()['role'] == 'staff'


def test_login_failures(client: TestClient):
    # nonexistent user
    bad = client.post('/api/auth/login', json={'username': 'none', 'password': 'pw'})
    assert bad.status_code == status.HTTP_401_UNAUTHORIZED

    # register user
    client.post('/api/auth/register', json={'username': 'bob', 'password': 'pw'})
    wrong = client.post('/api/auth/login', json={'username': 'bob', 'password': 'bad'})
    assert wrong.status_code == status.HTTP_401_UNAUTHORIZED


def test_login_validation_error(client: TestClient):
    # missing password
    resp = client.post('/api/auth/login', json={'username': 'bob'})
    assert resp.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY
