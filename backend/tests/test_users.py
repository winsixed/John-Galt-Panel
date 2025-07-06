from fastapi import status
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from fastapi_app import models


def create_admin(client: TestClient, db: Session):
    client.post('/api/auth/register', json={'username': 'admin', 'password': 'pw'})
    user = db.query(models.User).filter_by(username='admin').first()
    user.role = models.UserRole.admin
    db.commit()
    token_res = client.post(
        '/api/auth/login', json={'username': 'admin', 'password': 'pw'}
    )
    return token_res.json()['access_token']


def test_user_endpoints(client: TestClient, db_session: Session):
    token = create_admin(client, db_session)

    # create another user as admin
    res = client.post(
        '/api/users/create',
        json={'username': 'u1', 'password': 'pw', 'role': 'viewer'},
        headers={'Authorization': f'Bearer {token}'},
    )
    assert res.status_code == status.HTTP_200_OK
    assert res.json()['username'] == 'u1'

    # list users
    users = client.get('/api/users/', headers={'Authorization': f'Bearer {token}'})
    assert users.status_code == status.HTTP_200_OK
    assert len(users.json()) >= 1

    # admin-only endpoint
    secret = client.get('/api/users/admin-only', headers={'Authorization': f'Bearer {token}'})
    assert secret.status_code == status.HTTP_200_OK



def test_admin_required(client: TestClient):
    # regular user
    client.post('/api/auth/register', json={'username': 'bob', 'password': 'pw'})
    token_res = client.post(
        '/api/auth/login', json={'username': 'bob', 'password': 'pw'}
    )
    token = token_res.json()['access_token']

    res = client.post(
        '/api/users/create',
        json={'username': 'bad', 'password': 'pw'},
        headers={'Authorization': f'Bearer {token}'},
    )
    assert res.status_code == status.HTTP_403_FORBIDDEN

