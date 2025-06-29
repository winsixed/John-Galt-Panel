from flask import Blueprint, jsonify

employees_bp = Blueprint('employees', __name__)

@employees_bp.route('/', methods=['GET'])
def get_employees():
    return jsonify({"message": "Employees endpoint is working!"})