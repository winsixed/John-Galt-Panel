import type { Metadata } from "next";
import React from "react";

export const metadata: Metadata = {
  title: "Панель управления John Galt",
  description: "Добро пожаловать в административную панель John Galt Company",
};

export default function Dashboard() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold text-gray-800 dark:text-white">
        Добро пожаловать в панель управления John Galt
      </h1>
      <p className="text-gray-600 dark:text-gray-400">
        Здесь будут отображаться модули управления баром.
      </p>
    </div>
  );
}
