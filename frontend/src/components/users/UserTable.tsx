'use client'
import React, { useEffect, useState } from 'react';
import { Table, TableBody, TableCell, TableHeader, TableRow } from '@/components/ui/table';
import Button from '@/components/ui/button/Button';
import Spinner from '@/components/ui/Spinner';

interface User {
  id: number;
  email: string;
  role: string;
  status?: string;
}

export default function UserTable() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    async function load() {
      try {
        const res = await fetch('/users/');
        if (res.ok) {
          const data = await res.json();
          setUsers(data);
        } else {
          setError('Не удалось загрузить пользователей');
        }
      } catch {
        setError('Ошибка загрузки');
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  if (loading) return <Spinner />;
  if (error) return <p className="text-error-500">{error}</p>;

  return (
    <div className="overflow-x-auto">
      <Table className="min-w-full">
        <TableHeader>
          <TableRow>
            <TableCell isHeader className="px-4 py-2 text-left">Email</TableCell>
            <TableCell isHeader className="px-4 py-2 text-left">Role</TableCell>
            <TableCell isHeader className="px-4 py-2 text-left">Actions</TableCell>
          </TableRow>
        </TableHeader>
        <TableBody>
          {users.map((u) => (
            <TableRow key={u.id}>
              <TableCell className="px-4 py-2">{u.email}</TableCell>
              <TableCell className="px-4 py-2">{u.role}</TableCell>
              <TableCell className="px-4 py-2 space-x-2">
                <Button size="sm" variant="outline">Edit</Button>
                <Button size="sm" variant="outline">Block</Button>
                <Button size="sm" variant="outline">Delete</Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
