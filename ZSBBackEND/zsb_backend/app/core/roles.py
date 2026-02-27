from enum import Enum


class UserRole(str, Enum):
    customer = "customer"
    support_agent = "support_agent"
    engineer = "engineer"
    manager = "manager"
    admin = "admin"
