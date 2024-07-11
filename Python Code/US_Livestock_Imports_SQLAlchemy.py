##Export Main Table to CSV using SQLAlchemy

#Second, connect Python to PostgreSQL using SQLAlchemy
##import dependencies
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Column
from sqlalchemy import String
from sqlalchemy import Integer
from sqlalchemy import Date

from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt

#establish database path
database_path = 'postgres://postgres:password@localhost:5432/postgres'

#create engine
engine = create_engine(f'postgresql://{database_path}')
conn = engine.connect()

#transform sql table into a pandas object
data = pd.read_sql("SELECT * FROM main_import_table", conn)

#turn pandas object into a dataframe
data = pd.DataFrame(data)

#export dataframe into local folder
filepath = Path('/Users/vito/Documents/Data_2024/LivestockMeatTrade/csv_files/main_import_table.csv')
filepath.parent.mkdir(parents=True, exist_ok=True)
data.to_csv(filepath)