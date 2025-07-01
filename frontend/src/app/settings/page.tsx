import RequireRole from "@/components/auth/RequireRole";

export default function SettingsPage() {
  return (
    <RequireRole roles={["admin", "staff"]}>
      <div className="p-6">Настройки</div>
    </RequireRole>
  );
}
