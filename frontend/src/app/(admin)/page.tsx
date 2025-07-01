import type { Metadata } from "next";
import React from "react";
import RequireRole from "@/components/auth/RequireRole";
import { Role } from "@/types";

export const metadata: Metadata = {
  title: "Панель управления | John Galt Company",
  description: "Начальная страница административной панели",
};

export default function Dashboard() {
  return (
    <RequireRole roles={[Role.Admin, Role.Staff]}>
      <div className="p-6 rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/5">
        <h1 className="text-xl font-semibold text-gray-800 dark:text-white/90">Панель управления</h1>
      </div>
    </RequireRole>
  );
}
