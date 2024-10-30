import os

class Config:
 SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'postgresql://admin:admin_password@localhost:5432/productdb')
 SQLALCHEMY_TRACK_MODIFICATIONS = False