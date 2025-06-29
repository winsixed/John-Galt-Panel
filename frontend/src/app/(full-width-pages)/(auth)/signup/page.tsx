import SignUpForm from "@/components/auth/SignUpForm";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Регистрация | John Galt Company",
  description: "Страница регистрации в системе управления John Galt Company",
};

export default function SignUp() {
  return <SignUpForm />;
}
