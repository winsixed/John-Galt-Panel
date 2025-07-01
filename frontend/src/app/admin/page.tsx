import RequireRole from "@/components/auth/RequireRole";

export default function AdminPage() {
  return (
    <RequireRole roles={["admin"]}>
      <div className="p-6">Админ страница</div>
    </RequireRole>
  );
}
