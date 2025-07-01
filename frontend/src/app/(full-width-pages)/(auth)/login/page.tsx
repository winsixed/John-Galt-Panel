import { Metadata } from 'next';
import LoginClient from './LoginClient';

export const metadata: Metadata = {
  title: 'Вход | John Galt Company',
  description: 'Страница входа в систему управления',
};

export default function LoginPage() {
  return <LoginClient />;
}
