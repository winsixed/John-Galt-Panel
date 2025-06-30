import SignInForm from "@/components/auth/SignInForm";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Вход | John Galt Company",
  description: "Страница входа в систему управления",
};

export default function SignIn() {
  return <SignInForm />;
}
