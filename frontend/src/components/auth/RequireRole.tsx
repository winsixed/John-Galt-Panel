"use client";
import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { Role } from "@/types";

export default function RequireRole({
  children,
  roles,
}: {
  children: React.ReactNode;
  roles: Role[];
}) {
  const { user } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!user) {
      router.replace("/login");
    } else if (!roles.includes(user.role)) {
      router.replace("/unauthorized");
    }
  }, [user, roles, router]);

  if (!user || !roles.includes(user.role)) return null;
  return <>{children}</>;
}
