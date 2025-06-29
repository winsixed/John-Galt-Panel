from .extensions import db

class InventoryItem(db.Model):
    __tablename__ = 'inventory_items'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), nullable=False)
    quantity = db.Column(db.Integer, default=0)
    brand = db.Column(db.String(64))
    flavor = db.Column(db.String(64))

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "quantity": self.quantity,
            "brand": self.brand,
            "flavor": self.flavor,
        }

class Employee(db.Model):
    __tablename__ = 'employees'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), nullable=False)
    role = db.Column(db.String(64))
    salary = db.Column(db.Float, default=0.0)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "role": self.role,
            "salary": self.salary,
        }