import RequireRole from "@/components/auth/RequireRole";

export default function Profile() {
  return (
    <RequireRole roles={["admin", "staff", "viewer"]}>
      <div className="p-6">Профиль пользователя</div>
    </RequireRole>
  );
}
