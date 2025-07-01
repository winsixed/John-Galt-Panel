export const metadata = {
  title: 'Доступ запрещен',
};

export default function Unauthorized() {
  return (
    <div className="p-6">
      <h1 className="text-xl font-semibold text-error-500">Недостаточно прав</h1>
    </div>
  );
}
