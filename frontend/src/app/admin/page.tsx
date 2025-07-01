import RequireRole from "@/components/auth/RequireRole";
import { Role } from "@/types";

export default function AdminPage() {
  return (
    <RequireRole roles={[Role.Admin]}>
      <div className="p-6">Админ страница</div>
    </RequireRole>
  );
}
