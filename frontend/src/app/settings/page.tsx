import RequireRole from "@/components/auth/RequireRole";
import { Role } from "@/types";

export default function SettingsPage() {
  return (
    <RequireRole roles={[Role.Admin, Role.Staff]}>
      <div className="p-6">Настройки</div>
    </RequireRole>
  );
}
