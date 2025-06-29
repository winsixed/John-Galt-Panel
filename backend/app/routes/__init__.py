from .inventory import inventory_bp
from .employees import employees_bp

def register_routes(app):
    app.register_blueprint(inventory_bp, url_prefix='/api/inventory')
    app.register_blueprint(employees_bp, url_prefix='/api/employees')