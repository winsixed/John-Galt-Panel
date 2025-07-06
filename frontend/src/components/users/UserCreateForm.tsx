'use client'
import React, { useState } from 'react';
import Input from '@/components/form/input/InputField';
import Label from '@/components/form/Label';
import Button from '@/components/ui/button/Button';
import Spinner from '@/components/ui/Spinner';

export default function UserCreateForm() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState('staff');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setMessage('');
    try {
      const res = await fetch('/api/users/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password, role }),
      });
      if (res.ok) {
        setMessage('Пользователь создан');
        setUsername('');
        setPassword('');
      } else {
        setMessage('Ошибка создания');
      }
    } catch {
      setMessage('Ошибка сети');
    } finally {
      setLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {message && <p>{message}</p>}
      <div>
        <Label>Username</Label>
        <Input value={username} onChange={(e) => setUsername(e.target.value)} />
      </div>
      <div>
        <Label>Пароль</Label>
        <Input value={password} onChange={(e) => setPassword(e.target.value)} />
      </div>
      <div>
        <Label>Роль</Label>
        <select value={role} onChange={(e) => setRole(e.target.value)} className="h-11 w-full rounded-lg border-gray-300">
          <option value="admin">admin</option>
          <option value="staff">staff</option>
          <option value="viewer">viewer</option>
        </select>
      </div>
      <Button type="submit" disabled={loading}>
        {loading ? (
          <span className="flex items-center gap-2"><Spinner /> Сохранение...</span>
        ) : (
          'Создать'
        )}
      </Button>
    </form>
  );
}
