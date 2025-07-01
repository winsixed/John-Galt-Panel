import SignUpForm from "@/components/auth/SignUpForm";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Регистрация | John Galt Company",
  description: "Создание новой учетной записи",
};

export default function SignUp() {
  return <SignUpForm />;
}
