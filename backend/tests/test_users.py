from fastapi import status
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from fastapi_app import models


def create_admin(client: TestClient, db: Session):
    client.post('/api/auth/register', json={'username': 'adminuser', 'password': 'secretpw'})
    user = db.query(models.User).filter_by(username='adminuser').first()
    user.role = models.UserRole.admin
    db.commit()
    token_res = client.post(
        '/api/auth/login', json={'username': 'adminuser', 'password': 'secretpw'}
    )
    return token_res.json()['access_token']


def test_user_endpoints(client: TestClient, db_session: Session):
    token = create_admin(client, db_session)

    # create another user as admin
    res = client.post(
        '/api/users/create',
        json={'username': 'userone', 'password': 'secretpw', 'role': 'viewer'},
        headers={'Authorization': f'Bearer {token}'},
    )
    assert res.status_code == status.HTTP_200_OK
    assert res.json()['username'] == 'userone'

    # list users
    users = client.get('/api/users/', headers={'Authorization': f'Bearer {token}'})
    assert users.status_code == status.HTTP_200_OK
    assert len(users.json()) >= 1

    # admin-only endpoint
    secret = client.get('/api/users/admin-only', headers={'Authorization': f'Bearer {token}'})
    assert secret.status_code == status.HTTP_200_OK



def test_admin_required(client: TestClient):
    # regular user
    client.post('/api/auth/register', json={'username': 'bobby', 'password': 'secretpw'})
    token_res = client.post(
        '/api/auth/login', json={'username': 'bobby', 'password': 'secretpw'}
    )
    token = token_res.json()['access_token']

    res = client.post(
        '/api/users/create',
        json={'username': 'baduser', 'password': 'secretpw'},
        headers={'Authorization': f'Bearer {token}'},
    )
    assert res.status_code == status.HTTP_403_FORBIDDEN


def test_role_endpoints(client: TestClient, db_session: Session):
    # create staff user
    client.post('/api/auth/register', json={'username': 'staffer', 'password': 'secretpw'})
    user = db_session.query(models.User).filter_by(username='staffer').first()
    user.role = models.UserRole.staff
    db_session.commit()
    token = client.post('/api/auth/login', json={'username': 'staffer', 'password': 'secretpw'}).json()['access_token']
    # staff area allowed
    res = client.get('/api/users/staff', headers={'Authorization': f'Bearer {token}'})
    assert res.status_code == status.HTTP_200_OK

    # viewer cannot access staff area
    client.post('/api/auth/register', json={'username': 'viewerx', 'password': 'secretpw'})
    view = db_session.query(models.User).filter_by(username='viewerx').first()
    view.role = models.UserRole.viewer
    db_session.commit()
    vtoken = client.post('/api/auth/login', json={'username': 'viewerx', 'password': 'secretpw'}).json()['access_token']
    forb = client.get('/api/users/staff', headers={'Authorization': f'Bearer {vtoken}'})
    assert forb.status_code == status.HTTP_403_FORBIDDEN

    # inventory role endpoint
    client.post('/api/auth/register', json={'username': 'inv', 'password': 'secretpw'})
    inv = db_session.query(models.User).filter_by(username='inv').first()
    inv.role = models.UserRole.inventory
    db_session.commit()
    itoken = client.post('/api/auth/login', json={'username': 'inv', 'password': 'secretpw'}).json()['access_token']
    inv_ok = client.get('/api/users/inventory', headers={'Authorization': f'Bearer {itoken}'})
    assert inv_ok.status_code == status.HTTP_200_OK

