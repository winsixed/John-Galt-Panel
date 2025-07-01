import RequireRole from '@/components/auth/RequireRole';
import UserCreateForm from '@/components/users/UserCreateForm';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Создать пользователя | John Galt Company',
};

export default function UserCreatePage() {
  return (
    <RequireRole roles={["admin"]}>
      <UserCreateForm />
    </RequireRole>
  );
}
