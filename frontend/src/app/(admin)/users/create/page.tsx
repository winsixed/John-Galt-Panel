import RequireRole from '@/components/auth/RequireRole';
import UserCreateForm from '@/components/users/UserCreateForm';
import type { Metadata } from 'next';
import { Role } from '@/types';

export const metadata: Metadata = {
  title: 'Создать пользователя | John Galt Company',
};

export default function UserCreatePage() {
  return (
    <RequireRole roles={[Role.Admin]}>
      <UserCreateForm />
    </RequireRole>
  );
}
