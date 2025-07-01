import RequireRole from "@/components/auth/RequireRole";
import { Role } from "@/types";

export default function InventoryPage() {
  return (
    <RequireRole roles={[Role.Admin, Role.Staff]}>
      <div className="p-6">Инвентарь</div>
    </RequireRole>
  );
}
