import RequireRole from "@/components/auth/RequireRole";

export default function InventoryPage() {
  return (
    <RequireRole roles={["admin", "staff"]}>
      <div className="p-6">Инвентарь</div>
    </RequireRole>
  );
}
