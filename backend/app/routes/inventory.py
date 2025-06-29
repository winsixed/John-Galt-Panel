from flask import Blueprint, jsonify

inventory_bp = Blueprint('inventory', __name__)

@inventory_bp.route('/', methods=['GET'])
def get_inventory():
    return jsonify({"message": "Inventory endpoint is working!"})