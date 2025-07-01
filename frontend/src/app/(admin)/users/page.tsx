import RequireRole from '@/components/auth/RequireRole';
import UserTable from '@/components/users/UserTable';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Пользователи | John Galt Company',
};

export default function UsersPage() {
  return (
    <RequireRole roles={["admin"]}>
      <UserTable />
    </RequireRole>
  );
}
