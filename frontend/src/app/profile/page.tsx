import RequireRole from "@/components/auth/RequireRole";
import { Role } from "@/types";

export default function Profile() {
  return (
    <RequireRole roles={[Role.Admin, Role.Staff, Role.Viewer]}>
      <div className="p-6">Профиль пользователя</div>
    </RequireRole>
  );
}
